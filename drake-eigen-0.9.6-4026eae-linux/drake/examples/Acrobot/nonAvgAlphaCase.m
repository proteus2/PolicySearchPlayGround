m_list = [10;10];
changeURDF(m_list(1),m_list(2));


%% run the trajectory optimization
% --- setup a plant
p = PlanarRigidBodyManipulator('Acrobot.urdf');


% setup initial values and necessary variables for iLQG
n = 4; % dimension of my state
m = 1; % dimension of control

n_timesteps = 424;     %number of time steps
simulation_time = 10; % number of seconds to simulate
elapsed_time_perstep = simulation_time/n_timesteps; % time per steps
N = n_timesteps; % length of my trajectory

x0 = [pi 0 0 0]';
u0 = zeros(1,N);
x_goal = [pi 0 0 0]';
Q = eye(4,4)*1;

% --- select between iLQG and full DDP
order    = 4;

% --- set up finite differencing
h     = 2^-17;    % finite-difference parameter


% --- set up dynamics
F     = @(x,u) ab_dyn(p,x,u,elapsed_time_perstep,false);
Fp    = @(x,u) pour(F,x,u);  % function that I have no idea what it does.
DYN   = @(x,u,t) diff_xu(Fp, x, u, h, order);

% --- set up cost
C     = @(x,u) ab_cost(x,u,Q,x_goal);
Cp    = @(x,u) pour(C,x,u);
CST   = @(x,u,t) diff_xu(Cp, x, u, h, order);



% --- combine into DYNCST
DYNCST   = @(x,u,t) combine(DYN,CST,x,u,t);
Op    = struct('plot',-1,'print',3); 
[x, u, L]   = iLQG(DYNCST, x0, u0, Op);


%% Try evaluating using acrobotEval

%% supervised learning using Random Forest

