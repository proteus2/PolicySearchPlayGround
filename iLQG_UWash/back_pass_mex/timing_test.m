n = 20;
m = 10;
N = 2000;

cx    = zeros(1,n,N+1);
cu    = zeros(1,m,N+1);
cxx   = zeros(n,n,N+1);
cxu   = zeros(n,m,N+1);
cuu   = repmat(eye(m),[1 1 N+1]);
fx    = zeros(n,n,N);
fu    = zeros(n,m,N);
fxx   = zeros(n,n,n,N);
fxu   = zeros(n,n,m,N);
fuu   = zeros(n,m,m,N);

lambda   = 1;
regType  = 2;

tic
[diverge, Vx, Vxx, l, L, dV] = back_pass2(cx,cu,cxx,cxu,cuu,fx,fu,fxx,fxu,fuu,lambda,regType);
toc
diverge