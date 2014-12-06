time = 10;
dt=time/424;
t=0:dt:dt*424;
t(end)=[];


% %% run one instance
p = PlanarRigidBodyManipulator('Acrobot.urdf'); 
v = p.constructVisualizer;
v.axis = [-4 4 -4 4];
x0 = [0;0;0;0];

[x_traj,u_traj] = iLQG_BK(x0,time,424);  
xtraj = PPTrajectory(foh(t,x_traj));
xtraj = xtraj.setOutputFrame(p.getStateFrame);
v.playback(xtraj) % dont play it yet...