function test_control_policy
    checkDependency('lcmgl');
    success_score = zeros(4,10);
    
    %valid only from obs_idx=2
    obs_idx =35;
            partial=true

    load('./observable_init/com_list_for_partially_observations_list.mat');
    obs = obs_cands(obs_idx+1,:);
    obs(2)/2
    com = zeros(2,3);
    com(1,:) = com_list(obs_idx+1,:,1);
    com(2,:) = com_list(obs_idx+1,:,2);
    com(1,3) = com(1,3)+obs(2)/2; com(2,3) = com(2,3)+obs(2)/2; 
    %com(1,2)=0; com(2,2)=0;
%     test_predicted_traj=false;
%     if test_predicted_traj
%         fname= sprintf('./MMD_training_output_partially_observable/MMD_predicted_traj_%d_%d.mat',obs_idx,0)
%         load(fname);
%         q_sol=xtraj(1:end-1,1:end);
%         q_sol = [q_sol];
%         h_sol = [xtraj(end,:)];
%     else
        if partial
            fname= sprintf('./partial_observable_init/new_traj_%d.mat',obs_idx)
        else
            fname= sprintf('./observable_init/new_traj_%d.mat',obs_idx)
        end
        
        load(fname);

        h_sol = [0 h_sol];
%     end
    % q_sol(1:6) = obj location


    
   
    
    %% Related to visualization
    obj_goal_pose = [0; 0.5; obs(2)/2; zeros(3,1)]; % [x,y,z,roll,pitch,yaw]
    robot = createRobot(obs);
    v = robot.constructVisualizer();
    qtraj_sol = PPTrajectory(foh(cumsum(h_sol), q_sol));
    qtraj_sol = qtraj_sol.setOutputFrame(v.getInputFrame);

    v.playback(qtraj_sol, struct('slider', true));
    lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'goal');
    lcmgl.glColor3f(1,0,0);

    lcmgl.sphere(obj_goal_pose(1:3), 0.01, 20, 20);
    lcmgl.sphere(com(1,:), 0.01, 20, 20);
    lcmgl.sphere(com(2,:), 0.01, 20, 20);

    lcmgl.switchBuffers();
    keyboard
end

function robot = createRobot(obs)
    n_samples = 1;
    uncertainty(obs(1),obs(2));
    objects_urdf{1} = 'cylinder1.urdf';
    hand_urdf = 'robotiq_hand_description/cfg/s-model_articulated_fourbar_remove_package.urdf';
  
    
    radius = 0.04;
    len = 0.2; % object length
    object_struct = struct('type','cylinder','radius',radius,'len',len);
    object_struct.name = 'cylinder';
    object_struct.axis = [0;0;1];
    object_struct.axis_origin = [0;0;0];
    object_struct.mu = 1;
    
    for i=1:n_samples
        robot = RigidBodyManipulator(objects_urdf{i},struct('floating',true,'replace_cylinders_with_capsules',false));
        object_idx = robot.findLinkInd(object_struct.name);
        robot = robot.addRobotFromURDF(hand_urdf,[],[],struct('floating',true));
    end

end


function urdf = uncertainty(radius,len)
% load('RF_seed');
% rng(RF_seed);
% rand_num=rand();
inertia = zeros(3);

inertia(1,1) = 1e-3;
inertia(2,2) = 1e-3;
inertia(3,3) = 5e-3;
theta = 2*pi;
com = [[cos(theta) -sin(theta);sin(theta) cos(theta)]*[radius;0];len*(-0.5)];
mass =1;
urdf = sprintf('cylinder%d.urdf',1);
fid = fopen(urdf,'w');
cylinder_urdf =['<?xml version="1.0" ?>\n'...
'<robot name="cylinder" xmlns:xacro="http://www.ros.org/wiki/xacro">\n'...
'  <link name="cylinder">\n'...
'    <inertial>\n'...
'      <mass value="%f"/>\n'...
'      <origin xyz="%f %f %f"/>\n'...
'      <inertia ixx="%f" ixy="0.0" ixz="0.0" iyy="%f" iyz="0.0" izz="%f"/>\n'...
'    </inertial>\n'...
'    <collision>\n'...
'      <geometry>\n'...
'        <cylinder length="%f" radius="%f"/>\n'...
'      </geometry>\n'...
'      <origin rpy="0 0 0" xyz="0 0 0"/>\n'...
'    </collision>\n'...
'    <visual>\n'...
'      <geometry>\n'...
'        <cylinder length="%f" radius="%f"/>\n'...
'      </geometry>\n'...
'      <material name="gray">\n'...
'        <color rgba="0.5 0.5 .5 1"/>\n'...
'      </material>\n'...
'      <origin rpy="0 0 0" xyz="0 0 0"/>\n'...
'    </visual>\n'...
'  </link>\n'...
'</robot>\n'...
];
fprintf(fid,cylinder_urdf,mass,com(1),com(2),com(3),inertia(1,1),inertia(2,2),inertia(3,3),len,radius,len,radius);
fclose(fid);
end
