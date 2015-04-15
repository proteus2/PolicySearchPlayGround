function testRobustGrasp
%checkDependency('lcmgl');

hand_urdf = 'robotiq_hand_description/cfg/s-model_articulated_fourbar_remove_package.urdf';
hand = RigidBodyManipulator(hand_urdf,struct('floating',true));
nq_hand = hand.getNumPositions();
nv_hand = hand.getNumVelocities();
hand_tip1 = 'finger_1_link_3';
hand_tip2 = 'finger_2_link_3';
hand_tip3 = 'finger_middle_link_3';
palm = 'palm';
%hand_tip_names = {hand_tip1, hand_tip2, hand_tip3, palm};
hand_tip_names = {hand_tip1, hand_tip2, hand_tip3};
%hand_tip_pts = [0.01;0.01;0]*ones(1,4);
%hand_tip_pts(:,4) = [0; 0.05; 0];
%hand_tip_pts = [0.01;0.01;0]*ones(1,3);
hand_tip_pts = [[0.03;0.0225;0]] * ones(1,3);
back_tip_pts = zeros(3,10);
%back_tip_pts(:,1:3) = [0.02; 0; 0] * ones(1,3);
%back_tip_pts(:,4:6) = [0.04; -0.015; 0] * ones(1,3);
%back_tip_pts(:,7:9) = [0.02; 0.005; 0] * ones(1,3);
%back_tip_pts(:,10) = [0; -0.05; 0];
back_tip_names = {};
%back_tip_names = {'finger_1_link_3', 'finger_2_link_3', 'finger_middle_link_3',...
%  'finger_1_link_1', 'finger_2_link_1', 'finger_middle_link_1',...
%  'finger_1_link_2', 'finger_2_link_2', 'finger_middle_link_2',...
%  'palm'};
radius = 0.04;
len = 0.2; % object length
object_struct = struct('type','cylinder','radius',radius,'len',len);
object_struct.name = 'cylinder';
object_struct.axis = [0;0;1];
object_struct.axis_origin = [0;0;0];
object_struct.mu = 1;
tf_range = [0.5 5];
%Q_comddot = eye(3);

% what are these qs?
Q_comddot = zeros(3);
Qv = 0.01*eye(nv_hand+6);
%Q = 0.1*eye(nq_hand+6);
Q = zeros(nq_hand+6);
N = 10;
q_nom = zeros(nq_hand+6,N);
Q_contact_force = zeros(3); % penlaty on the force applied to the object

num_samples = 1;
%Q_contact_force = eye(3)/(hand.getMass*norm(hand.gravity))^2;
ncp_tol = 1e-6;

obj_beg_pose = zeros(6,1);
obj_beg_pose(3) = len/2;
obj_beg_pose(5,1) = 0;
obj_end_pose = [0; 0.5; len/2; zeros(3,1)]; % [x,y,z,roll,pitch,yaw]
hand_beg_pose = [0; -0.5; 0.1; zeros(3,1)];
hand_beg_vel = zeros(6,1);

plan = RobustGrasp(hand_urdf,hand_tip_names,...
  hand_tip_pts, back_tip_names, back_tip_pts,...
  object_struct,...
  obj_beg_pose, obj_end_pose, hand_beg_pose, hand_beg_vel, ...
  N,tf_range,Q_comddot,Qv,Q,q_nom, Q_contact_force, @(i) uncertainty(radius,len,i),num_samples,ncp_tol);
% add constraint on dt
plan = plan.addBoundingBoxConstraint(BoundingBoxConstraint(0.05*ones(N-1,1),0.2*ones(N-1,1)),plan.planners{1}.h_inds(:));

plan = plan.setSolverOptions('snopt', 'iterationslimit', 1e6);
%plan = plan.setSolverOptions('snopt', 'majoriterationslimit', 1000);
plan = plan.setSolverOptions('snopt', 'majoriterationslimit', 150);
plan = plan.setSolverOptions('snopt', 'majoroptimalitytolerance', 1e-4);
x_seed = zeros(plan.num_vars, 1);
for i = 1:num_samples
  last_q_inds = plan.planners{i}.q_inds(:,N);
  x_seed(last_q_inds(plan.robot.getBody(plan.robot.findLinkInd('palm')).position_num)) = [0; 0.5; zeros(4,1)];
end
plan = plan.setSolverOptions('snopt','print','ik_robust.out');
plan = plan.setSolverOptions('snopt','superbasicslimit',2000);

% Explicitly specifying the solver
plan = plan.setSolver('snopt');

delete('fort.15');
delete('ik_robust.out');
system('touch ik_robust.out');
tic
[x_sol,F,info] = plan.solve(x_seed); % F=value of objective fcn after optimization
toc

info
% load('new_traj_28.mat');

[q_sol,v_sol,h_sol] = parseSolution(plan, x_sol)

% q_beg_obj = q_sol(1:6,1);
% q_beg_hand = q_sol(7:12,1);
% q_beg_obj(5,1) = pi/2;
% q_sol(1:6,1) = q_beg_obj

% save('3_samples_no_cc_on_ground','q_sol','v_sol','h_sol');

v = plan.robot.constructVisualizer();
qtraj_sol = PPTrajectory(foh(cumsum([0 h_sol]), q_sol));
qtraj_sol = qtraj_sol.setOutputFrame(v.getInputFrame);
v.playback(qtraj_sol, struct('slider', true));
lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'goal');
lcmgl.glColor3f(1,0,0);
lcmgl.sphere(obj_end_pose(1:3), 0.01, 20, 20);
%lcmgl.switchBuffers();
keyboard
end

%[g,h]=plan.nonlinearConstraints(x_sol);
%lower_bound_violation = plan.cin_name(g<plan.cin_lb)
%upper_bound_violation = plan.cin_name(g>plan.cin_ub)
%violated_ceq = plan.ceq_name(h~=0)

function [q_sol,v_sol,h_sol] = parseSolution(plan, x_sol)
    % q_sol(1:6,:) = obj xyz positions, then roll pitch yaw
    % q_sol(7:12,:) = hand xyz positions, then roll pitch yaw
    
    q_sol = x_sol(plan.planners{1}.q_inds);
    v_sol = x_sol(plan.planners{1}.v_inds);
    h_sol = x_sol(plan.planners{1}.h_inds)';
end


function urdf = uncertainty(radius,len,count)
mass = rand()+1;
inertia = zeros(3);
inertia(1,1) = 0.01+rand()*1e-3;
inertia(2,2) = 0.01+rand()*1e-3;
inertia(3,3) = 0.04+rand()*5e-3;
theta = rand()*2*pi;
com = [rand()*[cos(theta) -sin(theta);sin(theta) cos(theta)]*[radius;0];len*(rand()-0.5)];

urdf = sprintf('cylinder%d.urdf',count);
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
