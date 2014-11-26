function l = cp_cost(E, x, u)
% Instantaneous costs for the cart-pole system

u(isnan(u))  = 0;

l     = E.dt*(E.cu*u.^2+ E.cx(1)*x(1,:).^2 +E.cx(2)*x(2,:).^2 -E.cx(3)*cos(x(3,:)) +E.cx(4)*x(4,:).^2);
