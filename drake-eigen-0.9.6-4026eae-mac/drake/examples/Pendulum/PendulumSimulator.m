p = PendulumPlant();


n_timestep = 10;

x0 = [pi - .1*randn;0;0;0];
x0 = [0; 0; 0; 0];
u = 0;
t = 0;
tape = x0;
x = x0;

for idx=1:n_timestep    
    [f,df] = p.dynamics(t,x,u);
    x = x+f;
    
%     q = x(1:2);
%     qd = x(3:4);
%       
%     % unwrap angles q(1) to [0,2pi] and q(2) to [-pi,pi]
%     q(1) = q(1) - 2*pi*floor(q(1)/(2*pi));
%     q(2) = q(2) - 2*pi*floor((q(2) + pi)/(2*pi));
      
    tape = [tape x];
end

