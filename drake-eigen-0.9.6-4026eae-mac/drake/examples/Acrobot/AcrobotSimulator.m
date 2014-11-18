p = PlanarRigidBodyManipulator('Acrobot.urdf');
x0 = [pi;0;0;0];
x0 = [0.1*(rand(4,1) - 1)];
x_goal = [pi 0 0 0]';
u = 0;
t = 0;
tape = x0;
cost = (x0 - x_goal)' * Q  * (x0-x_goal);
x = x0;


%first controller
k =  [-615.2989 -249.8877 -266.0147 -124.0688];
       S =   1.0e+04 * [8.2704    3.5671    3.5701    1.7737;
    3.5671    1.5464    1.5410    0.7659;
    3.5701    1.5410    1.5424    0.7663;
    1.7737    0.7659    0.7663    0.3808];

xbar = [q;qd] - x_goal;
uLQR = -k*(xbar);
%%%%%%Controller ends here

n_timesteps = 424;     %number of time steps
simulation_time = 10; % number of seconds to simulate
elapsed_time_perstep = simulation_time/n_timesteps; % time per step
Q = eye(4,4)*10;

for idx=1:n_timesteps
    [f,df] = p.dynamics(t,x,u);
    x = x+f*elapsed_time_perstep;
    
    q = x(1:2);
    qd = x(3:4);
      
    % unwrap angles q(1) to [0,2pi] and q(2) to [-pi,pi]
    q(1) = q(1) - 2*pi*floor(q(1)/(2*pi));
    q(2) = q(2) - 2*pi*floor((q(2) + pi)/(2*pi));

    xbar = [q;qd] - x_goal;
    uLQR = -k*(xbar); 
    u = uLQR;
	u = max(min(u,20),-20);

    tape = [tape [q;qd]];
    cost = [cost xbar'*Q*xbar ];
end
