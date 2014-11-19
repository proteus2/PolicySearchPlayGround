function totCost = acrobotEvaluator(policy, m1, m2)
    
    changeURDF(m1,m2);
    
    p = StochasticPlanarRigidBodyManipulator('Acrobot2.urdf');
    
    x0 = [pi 0 0 0]';
    %x0 = [0 0 0 0]';
    x_goal = [pi 0 0 0]';
    u = 0;
    t = 0;
    
    % initialize variables
    tape = x0;
    
    n_timesteps = 424;     %number of time steps
    simulation_time = 10; % number of seconds to simulate
    elapsed_time_perstep = simulation_time/n_timesteps; % time per step

    
    Q = eye(4,4)*10;
    cost = zeros(n_timesteps+1,1);
    cost(1)=(x0 - x_goal)' * Q  * (x0-x_goal);
    x = x0;

    
    for idx=1:n_timesteps
        [f,df] = p.dynamics(t,x,u);
        
        % add Gaussian white noise
        q_noise = normrnd(0,1,2,1);
        qd_noise = normrnd(0,0.1,2,1);
        x = x+f*elapsed_time_perstep+[q_noise;qd_noise];

        q = x(1:2);
        qd = x(3:4);

        % unwrap angles q(1) to [0,2pi] and q(2) to [-pi,pi]
        q(1) = q(1) - 2*pi*floor(q(1)/(2*pi));
        q(2) = q(2) - 2*pi*floor((q(2) + pi)/(2*pi));
        x=[q;qd];
        
        xbar = [q;qd] - x_goal;
        cost(idx) = xbar'*Q*xbar;
        
        
        u = policy*xbar;
        u = max(min(u,20),-20);
    end
    
    totCost = -sum(cost);
end