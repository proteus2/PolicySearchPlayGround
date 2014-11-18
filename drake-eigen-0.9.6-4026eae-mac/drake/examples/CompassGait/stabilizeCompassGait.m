% Compass Gait plant
p = CompassGaitPlant();

%% Get limit cycle initial condition (FILL ME IN) %%%%%%%%%%%%%%%%%%%%%%%%%
x0 = [    -0.323388563098678
   0.218668807978297
  -0.377182054327556
  -1.091826960670391]; % Your x0 from part (b) of the problem "Poincare analysis on compass gait"
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulate forwards from x0
xf = strideFunction(p,x0); % Your strideFunction from the previous problem

% Check that the resulting trajectory is periodic
if max(abs(xf-x0)) > 1e-4
    error('Simulating x0 does not result in a limit cycle');
end

% Simulate forwards from x0 to get the trajectory
xtraj = simulate(p,[0 1], [1; x0]);
xtraj = xtraj.traj{1}; % Extract first part of the trajectory (before collision)
ts = xtraj.getBreaks(); % Get time samples of trajectory
utraj = PPTrajectory(spline(ts,zeros(1,length(ts)))); % Define nominal u(t),
                                                      % which is all zeros since our
                                                      % system was passive                                                      
                                                      
% Set frames
xtraj = xtraj.setOutputFrame(p.modes{1}.getStateFrame);
utraj = utraj.setOutputFrame(p.modes{1}.getInputFrame);


%% Stabilize using tvlqr (Fill in jump equation) %%%%%%%%%%%%%%%%%%%%%%%%%%
% Define Q, Qf, R
Q = diag([10 10 1 1]);
R = 1;
Qf = Q;

options = struct();

converged = false;

while ~converged
% tvlqr for continuous phase
[tv,V] = tvlqr(p.modes{1},xtraj,utraj,Q,R,Qf,options);
QfV = Qf;

% Jump equation (FILL ME IN) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_t_plus = V.S.eval(0);
[xp,mode,status,dxp] = p.collisionDynamics(1,0,xtraj.eval(ts(end)),0);
% Ad is df_d/dx^- where f_d(x^-) is the guard function. and x^- is the x b4
% impact. dxp(:,3:6) returns gradients with respect to pre impact
Ad = dxp(:,3:6);
S_t_minus = Ad'*S_t_plus*Ad;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Qf = to S_t_minus
Qf = S_t_minus;

% Check for convergence (FILL ME IN)
if (sum(sum((Qf-QfV).^2)) < 0.01)
     converged = true;
end
% 
% 
end

Qf_converged = Qf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup tvlqr controller and simulate from x0 (Don't modify this block of code)

% Extend nominal limit cycle a little bit (see footnote at the bottom for
% an explanation of this - feel free to ignore this if you find it confusing
% This is a practical implementation issue.) 
tExtended = 1.0;                                                  
xtrajExtended = p.modes{1}.simulate([0 tExtended],x0); 
utrajExtended = PPTrajectory(spline(linspace(0,tExtended,100),zeros(1,100)));
xtrajExtended = xtrajExtended.setOutputFrame(p.modes{1}.getStateFrame);
utrajExtended = utrajExtended.setOutputFrame(p.modes{1}.getInputFrame);

[tv,V] = tvlqr(p.modes{1},xtrajExtended,utrajExtended,Q,R,Qf,options);

% Set frames of tvlqr controller
tv = tv.inOutputFrame(p.getInputFrame);
tv = tv.inInputFrame(p.getOutputFrame);

pmodel = SimulinkModel(p.getModel());

tv = tv.setInputFrame(pmodel.getOutputFrame);
tv = tv.setOutputFrame(pmodel.getInputFrame);

% Closed loop system (i.e., feedback system with TVLQR controller)
sysClosedLoop = feedback(pmodel,tv);

% Visualizer
v = CompassGaitVisualizer(p);

%% Simulate from x0 (syntax is useful for part (b)) %%%%%%%%%%%%%%%%%%%%%%%
x0=[   -0.323388563098678
   0.218668807978297
  -0.377182054327556
  -1.091826960670391];
p = CompassGaitPlant();
n = size(x0,1);
A = zeros(n,n);


xtrajSim = sysClosedLoop.simulate([0 1.0], [1;xtraj.eval(0)]);
xf = xtrajSim.traj{2}.eval(xtrajSim.te);

pmap0 = xtrajSim.traj{2}.eval(xtrajSim.te);
h = 1e-10;
for idx1=1:n
    x0_h = x0;
    x0_h(idx1) = x0(idx1) + h;
    xtrajSim = sysClosedLoop.simulate([0 1.0], [1;x0_h]);
    pmap_h = xtrajSim.traj{2}.eval(xtrajSim.te);
    
    A(:,idx1) = (pmap_h - pmap0)/h;
end
A

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Play trajectory back
xtrajSim = xtrajSim.setOutputFrame(p.getOutputFrame);
v.playback(xtrajSim);







%% Footnote (feel free to ignore) %%
% Since the continuous portion of our nominal trajectory is only defined for a finite amount of time
% [0,ts(end)], we need to deal with cases where the compass gait doesn't
% make contact with the ground before ts(end). Our solution here is to
% extend the nominal trajectory (xtrajExtended) a little beyond ts(end) (by just simulating
% the passive system forwards for longer). This is a reasonable thing to do,
% but still somewhat of a hack. However, this is an important
% implementation issue and worth thinking about in practice.
%%

















