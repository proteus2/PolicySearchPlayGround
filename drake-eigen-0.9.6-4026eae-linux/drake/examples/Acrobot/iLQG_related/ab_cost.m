function l = ab_cost(x, u, Q, x_goal)
% Instantaneous costs for the cart-pole system

u(isnan(u))  = 0;

%l     = (x-x_goal)'*Q*(x-x_goal);
l = bsxfun(@minus,x,x_goal)'*Q*bsxfun(@minus,x,x_goal);
l = diag(l)';
