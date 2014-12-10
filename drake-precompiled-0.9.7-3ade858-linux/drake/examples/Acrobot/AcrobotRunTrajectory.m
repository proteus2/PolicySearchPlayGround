dt=0.0125;
time = 5;
N =time/dt;
t=0:dt:dt*N;
t(end)=[];


% %% run one instance
p = PlanarRigidBodyManipulator('Acrobot.urdf'); 
v = p.constructVisualizer;
v.axis = [-4 4 -4 4];
x0  = [0;0;0;0]+[rand(2,1);zeros(2,1)];
u_init = zeros(1,N)+min(8*norm(x0-[pi;0;0;0]),20);
u_init(1)
% 

UWASHINGTON = false;

if UWASHINGTON
    [x_traj,u_traj] = iLQG_Washington(x0,time,N);  
    x_traj(:,end)=[];
else
 [x_traj,u_traj] = iLQG_BK(x0,u_init,time,N);    
end

xtraj = PPTrajectory(foh(t,x_traj));
xtraj = xtraj.setOutputFrame(p.getStateFrame);
v.playback(xtraj) % dont play it yet...��