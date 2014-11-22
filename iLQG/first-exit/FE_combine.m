function [y,eFlg,c,yx,yu,yxx,yxu,yuu,cx,cu,cxx,cxu,cuu] = combine(DYN, CST, x, u, BOUND)

n     = size(x,1);
[m N] = size(u);
N     = N-1; % last column is NaNs

if nargout == 2
   y  = DYN(x, u);
elseif nargout == 3
   c  = CST(x, u);
   y  = DYN(x(:,N), u(:,N));
else
   [y,yx,yu,yxx,yxu,yuu]   = DYN(x(:,1:N), u(:,1:N));
   [c,cx,cu,cxx,cxu,cuu]   = CST(x,        u);
end


if nargin > 4
   b     = BOUND(y(:,end));
   eFlg  = b < 0;    
   if eFlg
      if nargout == 2
         yc             = exit_step(x, u, DYN, CST, BOUND);
         y              = yc(1:n);
         
      elseif nargout == 3
         yc             = exit_step(x(:,N), u(:,N), DYN, CST, BOUND);
         c(:,N)         = yc(n+1);
        
      else
         fun            = @(z) exit_step(z(1:n,:), z(n+1:n+m,:), DYN, CST, BOUND);
         xu             = [x(:,N); u(:,N)];
         [ye, yz, yzz]  = fin_diff(fun, xu, 2^-18);
         
         % --- unpack
         y(:,N)         = ye(1:n);
         yx(:,:,N)      = yz(1:n,1:n);
         yu(:,:,N)      = yz(1:n,n+1:n+m);
         yxx(:,:,:,N)   = yzz(1:n,1:n,1:n);
         yxu(:,:,:,N)   = yzz(1:n,1:n,n+1:n+m);
         yuu(:,:,:,N)   = yzz(1:n,n+1:n+m,n+1:n+m);
         
         c(:,N)         = ye(n+1);
         cx(:,:,N)      = yz(n+1,1:n);
         cu(:,:,N)      = yz(n+1,n+1:n+m);
         cxx(:,:,:,N)   = yzz(n+1,1:n,1:n);
         cxu(:,:,:,N)   = yzz(n+1,1:n,n+1:n+m);
         cuu(:,:,:,N)   = yzz(n+1,n+1:n+m,n+1:n+m);  
      end
   end
else
   eFlg  = 0;
end

function yc = exit_step(x, u, DYN, CST, BOUND)

maxIter  = 1;

n        = size(x,1);

y        = DYN(x,u);
c        = CST(x,u);

f        = y - x;

[b,g]    = BOUND(x);
gf       = sum(g.*f,1);
h        = -b./gf;
y        = x + h(ones(n,1),:).*f;

for i = 1:maxIter
   [b,g]    = BOUND(y);
   gf       = sum(g.*f,1);
   dh       = - b./gf;
   h        = max(0,min(1,h + dh));
   y        = x + h(ones(n,1),:).*f;
end

yc = [y; h.*c];

