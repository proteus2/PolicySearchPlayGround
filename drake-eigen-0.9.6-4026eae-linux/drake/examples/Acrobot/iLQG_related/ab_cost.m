function l = ab_cost(x, u, Q, x_goal)

u(isnan(u))  = 0;

xerr = bsxfun(@minus,x_goal,x);
xerr(1,:) = mod(xerr(1,:)+pi,2*pi)-pi;
xerr(2,:) = mod(xerr(2,:)+pi,2*pi)-pi;
l = 1/2*xerr'*Q*xerr;
size(diag(l)')
size(diag((u.*u)'))
l = diag(l)' + (u.*u);


% 
% 
% u(isnan(u))  = 0;
% x_goal = [pi 0 0 0]';
% 
% %l     = (x-x_goal)'*Q*(x-x_goal);
% Q = eye(4,4);
% Q(1,1) = 100;
% Q(2,2) = 100;
%     
% xerr = bsxfun(@minus,x_goal,x);
% xerr(1,:) = mod(xerr(1,:)+pi,2*pi)-pi;
% xerr(2,:) = mod(xerr(2,:)+pi,2*pi)-pi;
% l =1/2*repmat(diag( xerr'*Q*xerr )',1,size(u,2));

