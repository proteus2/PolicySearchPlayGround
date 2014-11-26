function [x, u, L, Vx, Vxx, cost, lambda, trace, stop, fx, fxx] = iLQG(DYNCST, x0, u0, Op)
% Solve the deterministic finite-horizon optimal control problem.
% 
% Inputs
% ======
% DYNCST - a combined function for the dynamics and cost. It is called in
% three different formats:
% [xnew,cnew] = DYNCST(x,u,i) is called during the forward pass (if no
% function is given, see 'F_PASS' below). In this case x, u and xnew are
% vectors, and cnew and i (the time index) are scalars.
% [~,cnew] = DYNCST(x,nan) is called at the end the forward pass compute
% the final cost. 
% Finally,
% [~,~,fx,fu,fxx,fxu,fuu,cx,cu,cxx,cxu,cuu] = DYNCST(x,u,I) computes the
% derivatives along the trajectory. In this case size(x)==[n N+1] where N 
% is the trajectory length. size(u)==[m N+1] with NaNs in the last column
% to indicate final-cost. The time indexes are always I=(1:N)
%
% x0 - the initial state from which to solve the control problem. x0
% should be a column vector
%
% u0 - the initial control sequence. It is a matrix of size(u0)==[m N]
% where m is the dimension of the control and N is the number of state 
% transitions. 
%
% Op - an optional structure of parameters, see below
%
% Outputs
% =======
% x - the optimal state trajectory found by the algorithm.
%     size(x)==[n N+1]
%
% u - the optimal open-loop control sequence.
%     size(u)==[m N]
%
% L - the optimal closed loop control gains. These gains multiply the
%     deviation of a simulated trajectory from the nominal trajectory x.
%     size(L)==[m n N]
%
% Vx - the gradient of the Value. size(Vx)==[n N+1]
%
% Vxx - the Hessian of the Value. size(Vxx)==[n n N+1]
%
% cost - the costs along the trajectory. size(cost)==[1 N+1]
%        the cost-to-go is V = fliplr(cumsum(fliplr(cost))) 
%
% lambda - the final value of the regularization parameter
%
% trace - a trace of various convergence-related values

%---------------------- user-adjustable parameters ------------------------
defaults = {'lambdaInit',     .1,...            initial value for lambda
            'dlambdaInit',    1,...             initial value for dlambda
            'lambdaFactor',   1.2,...           lambda "second derivative"
            'lambdaMax',      1e10,...          lambda maximum value
            'lambdaMin',      1e-6,...          below this value lambda = 0      
            'regType'         2,...             regularization type 1: q_uu+lambda*eye(); 2: V_xx+lambda*eye()
            'zMin',           0.2,...           minimal accepted reduction ratio
            'tolFun',         1e-9,...          reduction exit criterion
            'tolGrad',        1e-6,...          gradient exit criterion
            'maxIter',        500,...           maximum iterations
            'Alpha',          1.1.^-((0:9).^2),... backtracking coefficients
            'plot',           1,...             0: no;  k>0: every k iters; k<0: 1 window every k iters
            'print',          2,...             0: no;  1: final; 2: iter; 3: iter, detailed
            'F_PASS',         nan,...           fast implementation of forward_pass
            };

% --- proccess options          
if nargin < 4,
   Op = struct();
end
Op  = setOpts(defaults,Op);

verbosity = Op.print;
      
if isa(Op.F_PASS,'function_handle')
   forward_pass   = Op.F_PASS;
else
   forward_pass   = @(x0,u,L,x) f_pass(x0,u,L,x,DYNCST);
end

% --- initialization
n        = size(x0, 1);          % size of state vector
m        = size(u0, 1);          % size of control vector
N        = size(u0, 2);          % number of time steps
u        = u0;                   % initial control sequence

lambda   = Op.lambdaInit;
dlambda  = Op.dlambdaInit;

% --- forward simulation of initial trajectory
for alpha = Op.Alpha
   [diverge,x,un,cost]  = forward_pass(x0(:,1),alpha*u,zeros(m,n,N),zeros(n,N+1));
   if ~diverge
      u = un;
      break
   end
end
if diverge
   [L,Vx,Vxx,cost]  = deal(nan);
   if verbosity > 0
      fprintf('\nEXIT: Initial control sequence caused divergence\n');
   end
   return
end

flgChange   = 1;
t_total     = tic;
diff_t      = 0;
back_t      = 0;
fwd_t       = 0;
stop        = 0;
expected    = 0;
trace       = zeros(Op.maxIter,7); %[iter lambda alpha g_norm dcost z sum(cost)];
trace(1,:)  = [1 lambda nan nan nan nan sum(cost)];
L           = zeros(m,n,N);
Vx          = zeros(n,N+1);
Vxx         = zeros(n,n,N+1);
fx          = zeros(n,n,N);
fxx         = zeros(n,n,N); % fxx         = zeros(n,n,n,N); 
graphics(Op.plot,x(:,1:N+1),u,L,Vx,Vxx,fx,fxx,trace(1,:),1);
if verbosity > 0
   fprintf('\n=========== begin iLQG ===========\n');
end
for iter = 1:Op.maxIter
   if stop
      break;
   end

   %====== STEP 1: differentiate dynamics and cost along new trajectory
   if flgChange
      t_diff = tic;
      [~,~,fx,fu,fxx,fxu,fuu,cx,cu,cxx,cxu,cuu]   = DYNCST(x, [u nan(m,1)], 1:N);
      diff_t = diff_t + toc(t_diff);
      flgChange   = 0;
   end
   
   %====== STEP 2: backward pass, compute optimal control law and cost-to-go
   backPassDone   = 0;
   while ~backPassDone
      
      t_back   = tic;
      [diverge, Vx, Vxx, l, L, dV] = back_pass(cx,cu,cxx,cxu,cuu,fx,fu,fxx,fxu,fuu,lambda,Op.regType);
      back_t   = back_t + toc(t_back);
      
      if diverge
         if verbosity > 2
            fprintf('Cholesky failed at timestep %d.\n',diverge);
         end
         dlambda   = max(dlambda * Op.lambdaFactor, Op.lambdaFactor);
         lambda    = max(lambda * dlambda, Op.lambdaMin);           
         if lambda > Op.lambdaMax
            break;
         end
         continue
      end
      backPassDone      = 1;
   end
   % check for termination due to small gradient
   g_norm         = mean(max(abs(l) ./ (abs(u)+1),[],1));
   trace(iter,[1 4 7])  = [iter g_norm nan];
   if g_norm < Op.tolGrad
      if verbosity > 0
         fprintf('\nSUCCESS: gradient norm < tolGrad\n');
      end
      break;
   end    
   
   %====== STEP 3: line-search to find new control sequence, trajectory, cost
   fwdPassDone  = 0;
   if backPassDone
      t_fwd = tic;
      for alpha = Op.Alpha

         [diverge,xnew,unew,costnew]   = forward_pass(x0 ,u+l*alpha, L, x);

         dcost    = sum(cost) - sum(costnew) - 1e10*diverge;
         expected = max(-alpha*(dV(1) + alpha*dV(2)), 0);
         z        = dcost/expected;
         if (z > Op.zMin) 
            fwdPassDone = 1;
            break;
         end 
      end
      fwd_t = fwd_t + toc(t_fwd);
   end
   
   %====== STEP 4: accept (or not), draw graphics
   if fwdPassDone
      
      % decrease lambda
      if alpha > min(Op.Alpha)
         dlambda   = min(dlambda / Op.lambdaFactor, 1/Op.lambdaFactor);
         lambda    = lambda * dlambda * (lambda > Op.lambdaMin);
      end
      
      % accept changes
      u              = unew;
      x              = xnew;
      cost           = costnew;
      flgChange      = 1;
      
      % print status
      if verbosity > 1
         fprintf('iter: %-3d  cost: %-9.6g  reduc: %-9.3g  gradient: %-9.3g  log10lam: %3.1f\n', ...
            iter, sum(cost), dcost, g_norm, log10(lambda));     
      end      
      % update trace
      trace(iter,:)  = [iter lambda alpha g_norm dcost z sum(cost)];
      
      % terminate ?
      if dcost < Op.tolFun
         if verbosity > 0
            fprintf('\nSUCCESS: cost change < tolFun\n');
         end
         break;
      end      
      
   else % no cost improvement
      % increase lambda
      dlambda  = max(dlambda * Op.lambdaFactor, Op.lambdaFactor);
      lambda   = max(lambda * dlambda, Op.lambdaMin);  
      
      % print status
      if verbosity > 1
         fprintf('iter: %-3d  REJECTED    expected: %-11.3g    actual: %-11.3g    log10lam: %3.1f\n',...
                  iter,expected ,dcost, log10(lambda));
      end

      % update trace
      trace(iter,:)  = [iter lambda 0 g_norm 0 0 sum(cost)];      
      
      % terminate ?
      if lambda > Op.lambdaMax,
         if verbosity > 0
            fprintf('\nEXIT: lambda > lambdaMax\n');
         end
         break;
      end
   end
   stop           = graphics(Op.plot,x,u,L,Vx,Vxx,fx,fxx,trace(1:iter,:),0);   
end

if stop
   if verbosity > 0
      fprintf('\nEXIT: Terminated by user\n');
   end
end

if iter == Op.maxIter
   if verbosity > 0
      fprintf('\nEXIT: Maximum iterations reached.\n');
   end
end


if ~isempty(iter)
   total_t = toc(t_total);
   if verbosity > 0
      fprintf(['\n'...
               'iterations:   %-3d\n'...
               'final cost:   %-12.7g\n' ...
               'final grad:   %-12.7g\n' ...               
               'time / iter:  %-5.0f ms\n'...               
               'total time:   %-5.2f seconds, of which\n'...
               '  derivs:     %-4.1f%%\n'... 
               '  back pass:  %-4.1f%%\n'...
               '  fwd pass:   %-4.1f%%\n'...
               '  other:      %-4.1f%% (inc. graphics)\n'...
               '=========== end iLQG ===========\n'],...
               iter,sum(cost),g_norm,1e3*total_t/iter,total_t, [diff_t, back_t, fwd_t, (total_t-diff_t-back_t-fwd_t)]*100/total_t);         
   end
   trace = trace(1:max(trace(:,1)),:);
   graphics(Op.plot,x,u,L,Vx,Vxx,fx,fxx,trace,2); % draw legend
end


function [diverge,xnew,unew,cnew] = f_pass(x0,u,L,x,DYNCST)
tolDiv   = 1e6;   % criterion for determining divergence

n        = size(x0,1);
m        = size(u,1);
N        = size(u,2);

xnew     = [x0 zeros(n,N)];
unew     = zeros(m,N);
cnew     = zeros(1,N+1);
diverge  = 0;
for i = 1:N
   dx                      = xnew(:,i) - x(:,i);
   unew(:,i)               = u(:,i) + L(:,:,i)*dx;
   [xnew(:,i+1),cnew(i)]   = DYNCST(xnew(:,i),unew(:,i),i);
   if any(abs(xnew(:,i+1)) > tolDiv)
      diverge  = 1;
      return
   end
end
[~,cnew(N+1)] = DYNCST(xnew(:,N+1),nan(m,1),i);


function  stop = graphics(figures, x,u,L,Vx,Vxx,fx,fxx,trace,init)
stop = 0;

if figures == 0
   return;
end

n  = size(x,1);
N  = size(x,2);
Np = size(Vx,2);
m  = size(u,1);

% === first figure
if figures ~= 0  && ( mod(trace(end,1)-1,figures) == 0 || init == 2 )
   
   fig1 = findobj(0,'name','iLQG - convergence');
   if  isempty(fig1)
      fig1 = figure();
      set(fig1,'NumberTitle','off','Name','iLQG - convergence','KeyPressFcn',@Kpress,'user',0);
   end

   if size(trace,1) == 1
      set(fig1,'user',0);
   end

   set(0,'currentfigure',fig1);
   clf(fig1);

   subplot(2,2,1);
   plot(x','LineWidth',1);
   grid on
   set(gca,'xlim',[1 N]);
   title 'state';

   subplot(2,2,3);
   [ax,h1] = plotyy((1:N-1)',u(:,1:N-1)',(1:N-1)',reshape(L(:,:,1:N-1),n*m,N-1)');
   set(h1,'linewidth',2);
   set(ax,'Ylimmode','auto','Ytickmode','auto')
   ylabel(ax(1),'open-loop sequence')
   ylabel(ax(2),'closed-loop gains')
   title 'policy'
   grid on
   set(ax(1),'xlim',[1 N-1+eps]);
   set(ax(2),'xlim',[1 N-1+eps]);
   xlabel 'timesteps'

   T        = trace(:,1);
   mT       = max(T); 
   
   ax1      = subplot(2,2,2); 
   set(ax1,'XAxisL','top','YAxisL','right','xlim',[1 mT+eps],'xtick',[])
   hV = line(T,trace(:,7),'linewidth',2,'color','k');
   ax2 = axes('Position',get(ax1,'Position'));
   hT = semilogy(T,trace(:,2:5),'.-');    
   set(ax2,'xlim',[1 mT+eps],'Ygrid','on','YMinorGrid','off','color','none');
   set(ax1,'Position',get(ax2,'Position'));
   title 'parameter trace'

   subplot(2,2,4);
   plot(T,trace(:,6),'.-');
   title 'actual reduction / expected reduction'
   set(gca,'xlim',[0 mT+1],'ylim',[0 2],'Ygrid','on');
   xlabel 'iterations'
   
   stop = get(fig1,'user');
end

if figures < 0  &&  (mod(abs(trace(end,1))-1,figures) == 0 || init == 2)

   fig2 = findobj(0,'name','iLQG - derivatives');
   if  isempty(fig2)
      fig2 = figure();
      set(fig2,'NumberTitle','off','Name','iLQG - derivatives','KeyPressFcn',@Kpress,'user',0);
   end

   if size(trace,1) == 1
      set(fig2,'user',0);
   end

   set(0,'currentfigure',fig2);
   clf(fig2);

   subplot(2,2,1);
   z = reshape(fx,n^2,Np-1)';
   zd = (1:n+1:n^2);
   plot(1:Np-1,z(:,zd),'r');
   hold on;
   plot(1:Np-1,z(:,setdiff(1:n^2,zd)),'b');
   set(gca,'xlim',[1 Np-1+eps]);
   hold off
   grid on;
   title 'f_{x}' 

   subplot(2,2,2);
   plot(1:Np,Vx');
   set(gca,'xlim',[1 Np]);
   title 'V_x'
   grid on;

   nxx = numel(fxx);
   if nxx == n^3*(Np-1) || nxx == n^2*(Np-1)
      subplot(2,2,3);
      z  = reshape(fxx,[nxx/(Np-1) Np-1])';
      plot(1:Np-1,z);
      title 'f_{xx}'
      grid on;   
      set(gca,'xlim',[1 Np-1+eps]);
      xlabel 'timesteps'
   end

   subplot(2,2,4);
   z = reshape(Vxx,n^2,Np)';
   zd = (1:n+1:n^2);
   plot(1:Np,z(:,zd),'r');
   hold on;
   plot(1:Np,z(:,setdiff(1:n^2,zd)),'b');
   hold off
   grid on;
   set(gca,'xlim',[1 Np]);
   title 'V_{xx}'
   xlabel 'timesteps'
   
   stop = stop + get(fig2,'user');
end

if init == 1
   if figures < 0
      figure(fig2);
   end
   figure(fig1);
elseif init == 2
   strings  = {'V','\lambda','\alpha','\partial_uV','\Delta{V}'};
   legend([hV; hT],strings,'Location','Best');
end

drawnow;

function Kpress(src,evnt)
if strcmp(evnt.Key,'escape')
   set(src,'user',1)
end


% setOpts - a utility function for setting default parameters
% ===============
% defaults  - either a cell array or a structure of field/default-value pairs.
% options   - either a cell array or a structure of values which override the defaults.
% params    - structure containing the union of fields in both inputs. 
function params = setOpts(defaults,options)

if nargin==1 || isempty(options)
   user_fields  = [];
else
   if isstruct(options)
      user_fields   = fieldnames(options);
   else
      user_fields = options(1:2:end);
      options     = struct(options{:});
   end
end

if isstruct(defaults)
   params   = defaults;
else
   params   = struct(defaults{:});
end

for k = 1:length(user_fields)
   params.(user_fields{k}) = options.(user_fields{k});
end
