time = 10;
dt=time/424;
t=0:dt:dt*424;
t(end)=[];


% %% run one instance
% p = PlanarRigidBodyManipulator('Acrobot.urdf'); 
% v = p.constructVisualizer;
% v.axis = [-4 4 -4 4];
% 
% [x_traj,u_traj] = iLQG_BK([0;0;0;0],time,424);  
% xtraj = PPTrajectory(foh(t,x_traj));
% xtraj = xtraj.setOutputFrame(p.getStateFrame);
% v.playback(xtraj) % dont play it yet...


%% Trajectory Optimization
x_traj_list=[]; u_traj_list=[];
DIRCOL=false;
theta_range = [pi pi-0.6283 pi-0.6283*2];

if DIRCOL == true
    p = AcrobotPlant;
    v = AcrobotVisualizer(p);
    for th1 = [pi pi-0.6283 pi-0.6283*2]
        for th2 = [0]
            xinit = [th1;th2;0;0];
            [u_traj,x_traj] = swingUpTrajectory(p,xinit,time);  
            x_traj = x_traj.eval(t);
            u_traj = u_traj.eval(t);
            x_traj_list = [x_traj_list x_traj];
            u_traj_list = [u_traj_list u_traj];
        end
    end
else
    for th1 = theta_range
        for th2 = 0
            xinit = [th1;th2;0;0];
            [x_traj,u_traj] = iLQG_BK(xinit,time,424);  
            x_traj_list = [x_traj_list x_traj];
            u_traj_list = [u_traj_list u_traj];
        end
    end
end

save('trajectory_list','x_traj_list','u_traj_list');

%% Regression - turning trajectories into controller
load('trajectory_list');
x = x_traj_list'; y= u_traj_list;
controller = TreeBagger(50,x,y,'Method','regression');
x1=zeros(4,424);
x1(:,1) = [0;0;0;0];
u=[];
for k=1:424-1
    control =  max(min(controller.predict(x1(:,k)'),20),-20);
    %control=-1.22551370e-07;
    u=[u control];
    xdot = p.dynamics(0,x1(:,k),control);
    xnew = x1(:,k) + xdot*dt;
    q = xnew(1:2,:);
    qd = xnew(3:4,:);
    q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
    q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));

    x1(:,k+1)=[q;qd];
end

xtraj = PPTrajectory(foh(t,x1));
xtraj = xtraj.setOutputFrame(p.getStateFrame);
v.playback(xtraj) % dont play it yet...

% 
% controller = AcrobotRegressionController(p,pi);
% sys_closedloop = feedback(p,controller);
% xtraj=simulate(sys_closedloop,[0 time-5],xinit);
