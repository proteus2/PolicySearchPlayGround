function xnew = cp_dyn(E,x,u)  %#eml
% --- Cart-Pole dynamics (Runge Kutta integrator)
% Inputs
% ======
% E - an environment structure that holds information about the physical
% constants of the cart and pole and the time step dt.
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

dt    = E.dt;
k1    = dt*cp_f(E,x,u);
dx    = k1;

if E.RK
   k2    = dt*cp_f(E,x+0.5*k1,u);
   k3    = dt*cp_f(E,x+0.5*k2,u);
   k4    = dt*cp_f(E,x+k3    ,u);
   dx    =(k1+k4)/6+(k2+k3)/3;  
end

xnew  = x + dx;



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