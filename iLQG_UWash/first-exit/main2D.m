% --- problem parameters
dt       = 0.05;              % time-step
Nmax     = 100;               % maximum number of time steps
k_u      = 0.1;               % u-cost coefficient
k_x      = [1 0.2]';          % state cost
x0       = [1 1]';            % initial state
u0       = zeros(1,Nmax-1);   % initial control sequence

DYN      = @(x,u) dyn2D(x,u,dt);
CST      = @(x,u) cst2D(x,u,dt,k_x,k_u);

DYNCST   = @(x,u) FE_combine(DYN, CST, x, u, @boundary);

% --- options 
Op    = struct('plot',0,'print',0,'tolFun',1e-9,'maxIter',500); 

% --- solve and plot
figure(3)
ng    = 300;
lim   = 1.5;
gx = linspace(-lim,lim,300);
[Xg,Yg] = meshgrid(gx);
Bg = reshape(boundary([Xg(:) Yg(:)]'),[ng ng]);
clf
set(gcf,'color','w')
contourf(Xg,Yg,Bg,[0 0])
hold on
axis(lim*[-1 1 -1 1])
axis equal

ns       = 6;
gs       = linspace(-.9*lim,.9*lim,ns);
[X0,Y0]  = meshgrid(gs);
X0       = [X0(:) Y0(:)]'; 

for i = 1:ns^2
   x0 = X0(:,i);
   if boundary(x0) < 1e-2
      continue;
   else
      [x, u, L, Vx, Vxx, cost, lambda, trace, stop] = FE_iLQG(DYNCST, x0, u0, Op);
      set(0,'currentfigure',3)
      plot(x(1,:),x(2,:),'k')
      plot(x(1,1),x(2,1),'.b')

      axis(lim*[-1 1 -1 1])
      drawnow
      if stop
         break
      end
   end
end



