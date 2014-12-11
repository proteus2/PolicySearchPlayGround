
% function [x_traj,u_traj] = AcrobotRunTrajectory(x0,p)
    %dt=0.001;
    clear all;
    cost=[]
    x_traj_list = cell(10);
    for N=100:100:1000
        dt=5/N
        time = 5;
        %N =time/dt;
        t=0:dt:dt*N;
        t(end)=[];


        % %% run one instance
        p = PlanarRigidBodyManipulator('Acrobot.urdf'); 
        v = p.constructVisualizer;
        v.axis = [-4 4 -4 4];
        x0  = [0;0;0;0]%+[rand(2,1)/2;zeros(2,1)];
        dist_to_goal = norm(x0-[pi;0;0;0]); %this is more or less like enery required
        u_init = zeros(1,N)+min(10*norm(x0-[pi;0;0;0]),20);
        u_init(1)
        x0
        N
        % 

        UWASHINGTON = false;
        Q = eye(4,4);
        Q(1,1)=10;Q(2,2)=10;
        R=1/(dist_to_goal+eps)
        if UWASHINGTON
            [x_traj,u_traj] = iLQG_Washington(x0,time,N);  
            x_traj(:,end)=[];
        else
         [x_traj,u_traj,new_cost] = iLQG_BK(p,x0,u_init,Q,R,time,N);    
         x_traj_list{N/100} = x_traj;
        end
        cost = [cost new_cost];
    %   
    end
    save('everything');
    xtraj = PPTrajectory(foh(t,x_traj));
    xtraj = xtraj.setOutputFrame(p.getStateFrame);
    v.playback(xtraj);
% end