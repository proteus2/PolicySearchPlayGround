function xnew = ab_dyn(p,x,u,dt,RK)  %#eml
% --- Acrobot dynamics for iLQG. Wrapper around p.dynamics (Runge Kutta integrator)
% Inputs
% ======
%
% x - the 4-dimensional state(s) of the system given by
%     x = [cart_position cart_velocity pole_angle pole_angular_velocity]'
%     when inputting N states, then size(x)==[4 N]
%
% u - the control force applied to the cart. size(u)==[1 N]
%
% Output
% ======
% xnew - the new states after 4th order RK integration (or Euler if ~E.RK)

%k1    = dt*cp_f(E,x,u);

f = zeros(size(x));
for idx=1:size(x,2)
    [f(:,idx),~] = p.dynamics(0,x(:,idx),u(:,idx));
end

k1   = dt.*f;
dx    = k1;

if RK
   f2    = p.dynamics(0,x+0.5*k1,u);
   k2    = dt*f2;
   f3    = p.dynamics(0,x+0.5*k2,u);
   k3    = dt*f3;
   f4    = p.dynamics(0,x+k3,u);
   k4    = dt*f4;
   dx    =(k1+k4)/6+(k2+k3)/3;  
end

xnew  = x + dx;
q = xnew(1:2,:);
qd = xnew(3:4,:);
q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));
xnew=[q;qd];

function dXdt = cp_f(E,X,u)  %#eml

mp    = E.mp;
mc    = E.mc;
muc   = E.muc;
mup   = E.mup;
l     = E.l;
g     = E.g;

V     = X(2,:);
TH    = X(3,:);
OM    = X(4,:);

Q     = 1./(8*mc + (5 - 3*cos(2*TH))*mp);
A     = sin(u/3)/1.5 + u - muc*V - mp*sin(TH)*l.*OM.^2;
B     = g*sin(TH)*mp-mup*OM/l;

AccX  = (8*A + 6*cos(TH).*B).*Q;
Z1    = 6*(mp*cos(TH).*A + (mc+mp)*B);
AccTH = Z1.*(Q/(l*mp));

dXdt  = [V; AccX; OM; AccTH];