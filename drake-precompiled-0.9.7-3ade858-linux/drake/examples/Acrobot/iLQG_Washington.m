function [xtraj,utraj] = iLQG_Washington(x0,simulation_time,n_timesteps)


    %% run the trajectory optimization
    % --- setup a plant
    p = PlanarRigidBodyManipulator('Acrobot.urdf');


    % setup initial values and necessary variables for iLQG
    n = 4; % dimension of my state
    m = 1; % dimension of control

    elapsed_time_perstep = simulation_time/n_timesteps; % time per steps
    N = n_timesteps; % length of my trajectory

    u0 = ones(1,N)*15;
    x_goal = [pi 0 0 0]';
    Q = eye(4,4);
    Q(1,1)=10;
    Q(2,2)=10;

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

    u(u>20) = 20;
    u(u<-20) = -20;

    xtraj = x;
    utraj = u;
end

%% Try evaluating using acrobotEval

%% supervised learning using Random Forest

