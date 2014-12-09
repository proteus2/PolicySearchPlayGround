N = 450;
time = 8;
dt=time/N;
t=0:dt:dt*N;
t(end)=[];


% %% run one instance
p = PlanarRigidBodyManipulator('Acrobot.urdf'); 
v = p.constructVisualizer;
v.axis = [-4 4 -4 4];
x0  = [0;0;0;0]+rand(4,1);
x0
% 

UWASHINGTON = false;

if UWASHINGTON
    [x_traj,u_traj] = iLQG_Washington(x0,time,N);  
    x_traj(:,end)=[];
else
 [x_traj,u_traj] = iLQG_BK(x0,time,N);    
end

xtraj = PPTrajectory(foh(t,x_traj));
xtraj = xtraj.setOutputFrame(p.getStateFrame);
v.playback(xtraj) % dont play it yet...¢¢