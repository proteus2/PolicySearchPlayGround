function build_f_pass(n,m,N,E)

x0 = zeros(n,1);
u  = zeros(m,N);
L  = zeros(m,n,N);
x  = zeros(n,N+1);

display('==== compiling forward pass function ====')

% old style eml compiler
% emlmex cp_forward_pass  -eg {x0,u,L,x,E}

% new style codegen (Matlab 2011a and later)
codegen cp_forward_pass  -args {x0,u,L,x,E} -o cp_forward_pass -launchreport
