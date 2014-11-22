function [diverge,xnew,unew,cnew] = cp_forward_pass(x0,u,L,x,E)  %#eml
n        = size(x0,1);
m        = size(u,1);
N        = size(u,2);

xnew     = [x0 zeros(n,N)];
unew     = zeros(m,N);
cnew     = zeros(1,N+1);
diverge  = 0;
for k = 1:N
   dx           = xnew(:,k) - x(:,k);
   unew(:,k)    = u(:,k) + L(:,:,k)*dx;
   xnew(:,k+1)  = cp_dyn(E,xnew(:,k),unew(:,k));
   cnew(k)      = cp_cost(E,xnew(:,k),unew(:,k));
   if any(abs(xnew(:,k+1)) > 1e6)
      diverge  = 1;
      return
   end
end
cnew(N+1) = cp_cost(E,xnew(:,N),nan);