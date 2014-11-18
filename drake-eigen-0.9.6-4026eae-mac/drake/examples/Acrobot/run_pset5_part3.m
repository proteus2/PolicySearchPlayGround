% RUN THIS to generate your solution
megaclear

%[p,xtraj,utraj,v,x0] = pset5_catch;

% if you want to display the trajectory again
%v.playback(xtraj);

% ********YOUR CODE HERE ********
% Set Q, R, and Qf for time varying LQR
% See problem statement for instructions here

load('output');

xf = xtraj.eval(3);
q = xf(1:5);
qd = xf(6:10);
kinsol = obj.doKinematics(q);
hand_body = 3;
pos_on_hand_body = [0;-2.1];
% Calculate position of the hand in world coordinates
% the gradient, dHand_pos, is the derivative w.r.t. q
[hand_pos,dHand_pos] = p.forwardKin(kinsol,hand_body,pos_on_hand_body);

% Find out how the position of hand changes w.r.t theta1 and theta2
dHand_theta = dHand_pos(:,1:2);

% Observe how the ball is changing w.r.t theta1 and theta2

% Penalize theta1 theta2 x_ball y_ball theta_ball

Q = eye(10,10);
R = 1;
Qf = eye(10,10);
% q=[theta1 theta2 x_ball y_ball theta_ball]
% x=[q qdot]



% *******************************

c = p.tvlqr(xtraj,utraj,Q,R,Qf);
sys_cl = p.feedback(c);

%%
x0_test = x0;
x0_test(3) = x0(3) + .1;
traj_test_1 = sys_cl.simulate(xtraj.tspan,x0_test);
v.playback(traj_test_1);

x0_test = x0 + .02*(rand(10,1) - 1);
traj_test_2 = sys_cl.simulate(xtraj.tspan,x0_test);
v.playback(traj_test_2);

% submit x_grade below
x_grade = [traj_test_1.eval(xtraj.pp.breaks) traj_test_2.eval(xtraj.pp.breaks) Qf repmat(xtraj.tspan(2),10,1)]';

format short
display(x_grade)
format long