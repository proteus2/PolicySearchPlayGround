function test_control_policy
    checkDependency('lcmgl');
    success_score = zeros(4,10);
    
        fname= sprintf('./MMD_training_output/MMD_predicted_traj_%d_%d.mat',1,9);
        load(fname);
        q_sol=xtraj(1:end-1,1:end);
        q_sol = [q_sol];
        h_sol = [xtraj(end,:)];

        len = 0.2;
        obj_end_pose = [0; 0.5; len/2; zeros(3,1)]; % [x,y,z,roll,pitch,yaw]

        robot = createRobot();
        v = robot.constructVisualizer();
        qtraj_sol = PPTrajectory(foh(cumsum(h_sol), q_sol));
        qtraj_sol = qtraj_sol.setOutputFrame(v.getInputFrame);

    v.playback(qtraj_sol, struct('slider', true));
    lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'goal');
    lcmgl.glColor3f(1,0,0);
    lcmgl.sphere(obj_end_pose(1:3), 0.01, 20, 20);
    lcmgl.switchBuffers();
    norm(xtraj(1:3,end)-[0;0.5;0.1])
    keyboard
end

function robot = createRobot()
    n_samples = 2;
    
    objects_urdf{1} = 'cylinder1.urdf';
    objects_urdf{2} = 'cylinder2.urdf';
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