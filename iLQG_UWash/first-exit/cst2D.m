function [c,cx,cu,cxx,cxu,cuu] = cst2D(x,u,dt,k_x,k_u)

N     = size(x,2);

u(isnan(u)) = 0;

c     = .5*dt*(k_x'*x.^2 + k_u*u.^2);

if nargout > 1
   cx    = dt*shiftdim(diag(k_x) * x               ,-1);
   cxx   = dt*shiftdim(repmat(diag(k_x), [1 1 N])  ,-1);
   cu    = dt*shiftdim(k_u*u                       ,-1);
   cxu   = dt*shiftdim(zeros(2,1,N)                ,-1);
   cuu   = dt*shiftdim(k_u*ones(1,1,N)             ,-1);
end