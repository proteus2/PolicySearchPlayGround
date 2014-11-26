function [diverge, Vx, Vxx, l, L, dV] = back_pass(cx,cu,cxx,cxu,cuu,fx,fu,fxx,fxu,fuu,lambda,regType)  

if size(cx,1) == 1
   cx    = shiftdim(cx,  1);
   cu    = shiftdim(cu,  1);
   cxx   = shiftdim(cxx, 1);
   cxu   = shiftdim(cxu, 1);
   cuu   = shiftdim(cuu, 1);
end

n  = size(cx,1);
N  = size(cx,2);
m  = size(cu,1);

l     = zeros(m,N-1);
L     = zeros(m,n,N-1);
Vx    = zeros(n,N);
Vxx   = zeros(n,n,N);
dV    = [0 0];


Vx(:,N)     = cx(:,N);
Vxx(:,:,N)  = cxx(:,:,N);

diverge  = 0;
for k = N-1:-1:1

   Qu  = cu(:,k)      + fu(:,:,k)'*Vx(:,k+1);
   Qx  = cx(:,k)      + fx(:,:,k)'*Vx(:,k+1);   
   Qux = cxu(:,:,k)'  + fu(:,:,k)'*Vxx(:,:,k+1)*fx(:,:,k) + p13mm(Vx(:,k+1),fxu(:,:,:,k));
   Quu = cuu(:,:,k)   + fu(:,:,k)'*Vxx(:,:,k+1)*fu(:,:,k) + p13mm(Vx(:,k+1),fuu(:,:,:,k));
   Qxx = cxx(:,:,k)   + fx(:,:,k)'*Vxx(:,:,k+1)*fx(:,:,k) + p13mm(Vx(:,k+1),fxx(:,:,:,k));

   VxxF = (Vxx(:,:,k+1) + lambda*eye(n)*(regType == 2));
   QuxF = cxu(:,:,k)'   + fu(:,:,k)'*VxxF*fx(:,:,k) + p13mm(Vx(:,k+1),fxu(:,:,:,k));
   QuuF = cuu(:,:,k)    + fu(:,:,k)'*VxxF*fu(:,:,k) + p13mm(Vx(:,k+1),fuu(:,:,:,k)) +...
          lambda*eye(m)*(regType == 1);
   
   % cholesky decomposition, check for non-PD
   [R,d] = chol(QuuF);
   if d ~= 0
      diverge  = k;
      return;
   end

   % find control law
   lL = -R\(R'\[Qu QuxF]);
   lk = lL(:,1);
   Lk = lL(:,2:n+1);
   
   % update cost-to-go approximation

   dV          = dV + [lk'*Qu  .5*lk'*Quu*lk];

   Vx(:,k)     = Qx  + Lk'*Quu*lk + Lk'*Qu  + Qux'*lk;
   Vxx(:,:,k)  = Qxx + Lk'*Quu*Lk + Lk'*Qux + Qux'*Lk;
   Vxx(:,:,k)  = .5*(Vxx(:,:,k) + Vxx(:,:,k)');
   
   l(:,k)      = lk;
   L(:,:,k)    = Lk;
end


function c = p13mm(a,b)

c  = permute(sum(bsxfun(@times,a,b),1), [3 2 1]);

