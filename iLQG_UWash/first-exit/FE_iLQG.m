function [x, u, L, Vx, Vxx, cost, lambda, trace, stop, fx, fxx] = iLQG(DYNCST, x0, u0, Op)
% Solve the deterministic finite-horizon or first-exit optimal control 
% problem.
% 
% Inputs
% ======
% DYNCST - a combined function for the dynamics and cost. It is called in
% three different formats:
% [xnew,eFlg] = DYNCST(x,u) is called during the forward pass (if no
% function is given, see 'F_PASS' below). In this case x, u and xnew are
% vectors, and eFlg is 1 if the exit manifold was reached and 0 otherwise.
% [~,~,c] = DYNCST(x,u) is called after the forward pass is done to compute
% the costs along the trajectory. In this case size(x)==[n N+1] where N is
% the trajectory length. size(u)==[m N+1] with NaNs in the last column
% to indicate final-cost. Finally
% [~,~,~,fx,fu,fxx,fxu,fuu,cx,cu,cxx,cxu,cuu] = DYNCST(x,u) computes the
% derivatives along the trajectory.
%
% x0 - the initial state from which to solve the control problem. x0
% should be a column vector
%
% u0 - the initial control sequence. It is a matrix of size(u0)==[m N]
% where m is the dimension of the control and N+1 is the number of states 
% in the trajectory. In the first-exit case size(u,2) indicates the maximum
% trajectory length.
%
% Op - an optional structure of optional arguments, see below
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
            'lambdaMax',      1e7,...           lambda maximum value
            'lambdaMin',      1e-6,...          below this value lambda = 0      
            'regType'         2,...             regularization type 1: q_uu+lambda*eye(); 2: V_xx+lambda*eye()
            'zMin',           0.2,...           minimal accepted reduction ratio
            'tolFun',         1e-9,...          reduction exit criterion
            'tolGrad',        1e-6,...          gradient exit criterion
            'maxIter',        500,...           maximum iterations
            'Alpha',          1.1.^-((0:8).^2),... backtracking coefficients
            'plot',           1,...             0: no;  1: yes
            'print',          1,...             0: no;  1: yes;
            'F_PASS',         nan,...           fast implementation of forward_pass
            };

% --- proccess options         
if nargin < 4,
   Op = struct();
end
Op  = setOpts(defaults,Op);

if Op.print
   myprint = @(varargin) fprintf(varargin{:});
else
   myprint = @(varargin)[];
end

if Op.plot
   graphics = @(varargin) do_graphics(varargin{:});
else
   graphics = @(varargin)[];
end
      
if isa(Op.F_PASS,'function_handle')
   forward_pass   = Op.F_PASS;
else
   forward_pass   = @(x0,u,L,x) f_pass(x0,u,L,x,DYNCST);
end

% --- initialization
n        = size(x0, 1);          % size of state vector
m        = size(u0, 1);          % size of control vector
Nmax     = size(u0, 2);          % maximum number of time steps
N        = Nmax;                 % number of time steps
u        = u0;                   % initial control sequence

lambda   = Op.lambdaInit;
dlambda  = Op.dlambdaInit;

% --- forward simulation of initial trajectory
for alpha = Op.Alpha
   [diverge,x,un,N]  = forward_pass(x0(:,1),alpha*u,zeros(m,n,N),zeros(n,N+1));
   if ~diverge
      u = un;
      break
   end
end
if diverge
   [L,Vx,Vxx,cost]  = deal(nan);
   return
end
[~,~,cost]  = DYNCST(x(:,1:N+1), [u(:,1:N) nan(m,1)]);

flgChange   = 1;
t_total     = tic;
diff_t      = 0;
back_t      = 0;
fwd_t       = 0;
stop        = 0;
expected    = 0;
trace       = zeros(Op.maxIter,7);
L           = zeros(m,n,Nmax);
Vx          = zeros(n,Nmax+1);
Vxx         = zeros(n,n,Nmax+1);
fx          = zeros(n,n,Nmax);
fxx         = zeros(n,n,n,Nmax);
graphics(x(:,1:N+1),u,L,Vx,Vxx,fx,fxx,ones(1,6),1);
myprint('\n=========== Begin iLQG ===========\n');
for iter = 1:Op.maxIter
   if stop
      break;
   end
   t_iter = tic;
   %====== STEP 1: differentiate dynamics and cost along new trajectory
   if flgChange
      t_diff = tic;
      [~,~,~,fx,fu,fxx,fxu,fuu,cx,cu,cxx,cxu,cuu]   = DYNCST(x(:,1:N+1), [u(1:N) nan(m,1)]);
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
         myprint('Value divergence at timestep %d.\n',diverge);
         dlambda   = max(dlambda * Op.lambdaFactor, Op.lambdaFactor);
         lambda    = max(lambda * dlambda, Op.lambdaMin);           
         if lambda > Op.lambdaMax
            break;
         end
         continue
      end
      l(:,N:Nmax)     = l(:,N*ones(1,Nmax+1-N));
      L(:,:,N:Nmax)   = L(:,:,N*ones(1,Nmax+1-N));
      backPassDone      = 1;
   end
   % check for termination due to small gradient
   g_norm   = mean(max(abs(l) ./ (abs(u)+1),[],1));
   if g_norm < Op.tolGrad
      myprint('\nSUCCESS: gradient norm < tolGrad\n');
      break;
   end    
   
   %====== STEP 3: line-search to find new control sequence, trajectory, cost
   fwdPassDone  = 0;
   if backPassDone
      t_fwd = tic;
      for alpha = Op.Alpha

         [diverge,xnew,unew,Nnew]   = forward_pass(x0 ,u+l*alpha, L, x);
         [~,~,costnew]              = DYNCST(xnew(:,1:Nnew+1), [unew(:,1:Nnew) nan(m,1)]);

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
      iter_t   = toc(t_iter);
      
      % decrease lambda
      if alpha > min(Op.Alpha)
         dlambda   = min(dlambda / Op.lambdaFactor, 1/Op.lambdaFactor);
         lambda    = lambda * dlambda * (lambda > Op.lambdaMin);
      end
      
      % accept changes
      N              = Nnew;
      u              = unew;
      u(:,N:Nmax)    = u(:,N*ones(1,Nmax-N+1));
      x              = xnew;
      cost           = costnew;
      flgChange      = 1;
      
      % print status
      myprint('Iter: %-3d  time: %5.3fs  Cost: %-9.6g  Reduction: %-9.3g  log10Lambda: %3.1f  N: %-3d\n', ...
         iter , iter_t, sum(cost), dcost, log10(lambda), N);     
      
      % graphics
      trace(iter,:)  = [iter lambda alpha g_norm dcost z sum(cost)];
      stop           = graphics(x(:,1:N+1),u,L,...
                        Vx,Vxx,fx,fxx,trace(1:iter,:),0);
      
      % terminate ?
      if dcost < Op.tolFun
         myprint('\nSUCCESS: cost change < tolFun\n');
         break;
      end      
      
   else
      myprint('No cost improvement. Expected reduction: %.1e; Actual reduction: %.1e\n',expected ,dcost);
      
      % increase lambda
      dlambda  = max(dlambda * Op.lambdaFactor, Op.lambdaFactor);
      lambda   = max(lambda * dlambda, Op.lambdaMin);  
      
      % terminate ?
      if lambda > Op.lambdaMax,
         myprint('\nEXIT: lambda > lambdaMax\n');
         break;
      end
   end
end

if stop
   myprint('\nEXIT: Terminated by user\n');
end

if iter == Op.maxIter
   myprint('\nEXIT: Maximum iterations reached.\n');
end

x     = x(:,1:N+1);
u     = u(:,1:N);

if ~isempty(iter)
   total_t = toc(t_total);
   myprint(['\nTotal time:   %4.2fs, of which\n'...
            'derivatives:  %4.1f%%\n'... 
            'back pass:    %4.1f%%\n'...
            'fwd pass:     %4.1f%%\n'...
            'other:        %4.1f%% (inc. graphics)\n'],...
            total_t, [diff_t, back_t, fwd_t, (total_t-diff_t-back_t-fwd_t)]*100/total_t);         
   trace = trace(1:iter,:);
   graphics(x,u,L,Vx,Vxx,fx,fxx,trace,2); % draw legend
end

L     = L(:,:,1:N);
Vx    = Vx(:,1:N+1);
Vxx   = Vxx(:,:,1:N+1);




function [diverge,xnew,unew,N] = f_pass(x0,u,L,x,DYNCST)
n        = size(x0,1);
m        = size(u,1);
Nmax     = size(u,2);

xnew     = [x0 zeros(n,Nmax)];
unew     = zeros(m,Nmax);
diverge  = 0;
for N = 1:Nmax
   dx                   = xnew(:,N) - x(:,N);
   unew(:,N)            = u(:,N) + L(:,:,N)*dx;
   [xnew(:,N+1),eFlg]   = DYNCST(xnew(:,N),unew(:,N));
   if eFlg
      unew(:,N:Nmax) = unew(:,N*ones(1,Nmax-N+1));
      return
   end
   if any(abs(xnew(:,N+1)) > 1e6)
      diverge  = 1;
      return
   end
end


function  stop = do_graphics(x,u,L,Vx,Vxx,fx,fxx,trace,init)

n  = size(x,1);
N  = size(x,2);
Np = size(Vx,2);
m  = size(u,1);

fig1 = findobj(0,'name','iLQG - convergence');
if  isempty(fig1)
   fig1 = figure();
   set(fig1,'NumberTitle','off','Name','iLQG - convergence','KeyPressFcn',@Kpress,'user',0);
end

fig2 = findobj(0,'name','iLQG - derivatives');
if  isempty(fig2)
   fig2 = figure();
   set(fig2,'NumberTitle','off','Name','iLQG - derivatives','KeyPressFcn',@Kpress,'user',0);
end

if size(trace,1) == 1
   set(fig1,'user',0);
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

subplot(2,2,3);
z  = reshape(fxx,[n^3 Np-1])';
plot(1:Np-1,z);
title 'f_{xx}'
grid on;   
set(gca,'xlim',[1 Np-1+eps]);
xlabel 'timesteps'

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
 
subplot(2,2,2);
T        = trace(:,1);
mT       = max(T);
T(T==0)  = nan;
semilogy(T,trace(:,2:5),'.-');
title 'parameter trace'
set(gca,'xlim',[0 mT+1]);

subplot(2,2,4);
plot(T,trace(:,6),'.-');
title 'actual reduction / expected reduction'
set(gca,'xlim',[0 mT+1],'ylim',[0 2]);
xlabel 'iterations'
   
if init == 1
   figure(fig2);
   figure(fig1);
elseif init == 2
   subplot(2,2,2);
   legend('\lambda','\alpha','|\Delta{u}|_\infty','\Delta{V}');
   legend('Location','Best');
end
stop = get(fig1,'user') + get(fig2,'user');
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
