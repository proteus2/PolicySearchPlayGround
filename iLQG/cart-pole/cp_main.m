% --- cart-pole parameters
E.mp     = 0.5;   % mass of pole
E.mc     = 1;     % mass of cart
E.muc    = 0.05;  % cart friction
E.mup    = 0.05;  % pole friction
E.l      = 1;     % pole length
E.g      = 9.8;   % gravity

E.dt     = 0.04;  % time-step
E.RK     = 0;     % use Runge-Kutta ?
T        = 4;     % total time

% --- problem parameters
N        = T/E.dt;            % number of time steps
E.cu     = 0.01;              % u-cost coefficient
E.cx     = [.1 .01 1 .01]';   % state cost
x0       = [0 0 pi .2]';      % initial state
u0       = zeros(1,N);        % initial control sequence

% --- select between iLQG and full DDP
order    = 4;

% --- set up finite differencing
h     = 2^-17;    % finite-difference parameter
n     = 4;
m     = 1;

% --- set up dynamics
F     = @(x,u) cp_dyn(E,x,u); % function that given x and u, returns x'
Fp    = @(x,u) pour(F,x,u);  % function 
DYN   = @(x,u,t) diff_xu(Fp, x, u, h, order);

% --- set up cost
C     = @(x,u) cp_cost(E,x,u);
Cp    = @(x,u) pour(C,x,u);
CST   = @(x,u,t) diff_xu(Cp, x, u, h, order);

% --- combine into DYNCST
DYNCST   = @(x,u,t) combine(DYN,CST,x,u,t);

% --- options 
Op    = struct('plot',-1,'print',3); 

% --- compile forward pass (uncomment to activate)
% build_f_pass(n,m,N,E)
% Op.F_PASS   = @(varargin) cp_forward_pass(varargin{:},E);


% --- solve 
[x, u, L]   = iLQG(DYNCST, x0, u0, Op);
