% potential alpha=velocity, mass, initial and final goal states

% gather initial data
gatherData = false;
if gatherData == true
    traj_list = cell(1,2);

    x0 = [3.9;0;0;0];
    [utraj,xtraj] = getTrajectory(x0);
    %visualizeTraj(xtraj);
    tf=xtraj.getBreaks; tf=tf(end);
    t=0:0.001:tf;
    traj_list{1,1} = xtraj.eval(t);
    traj_list{1,2} = utraj.eval(t);

    save('traj_list','traj_list');
end

% set final time
load('traj_list');
tf=0.9263;

% train using DAgger 
%TODO: collect new data with tf=0.9263
train = true;
if train
    p = PlanePlant();
    x0 = [3.9; 0; 0; 0]; 
    
%     dt = 0.001;
%     x1 = rungeKattaSimulation(x0,traj_list{1,2},dt,tf,p);
%     t=0:dt:tf; xtraj=x1.eval(t); utraj=traj_list{1,2}.eval(t);
    %figure;scatter(xtraj(1,:),xtraj(2,:),'r');
    %title('Initial Training Data');
    
    [controller,mmd_data] = trainMMD(x0,tf,traj_list,p);
    save('mmd_data','mmd_data');
end

if ~exist('controller','var')
    load('mmd_data');
    dt=0.01; t=0:dt:tf; 
    controller = MMDController();
    for idx=1:size(mmd_data,1)
        controller = setNewController(controller,mmd_data{idx,1},mmd_data{idx,2});
    end
end

% run runge katta with the controller
%% visualize trajectory
dt=0.001;
p = PlanePlant(); x0=[3.9;0;0;0];
tic
x1 = rungeKattaSimulation(x0,controller,dt,tf,p);
toc

dt=0.01;
t = 0:dt:tf;
traj_exed = mmd_data{5,1}.eval(t);
scatter(traj_exed(1,:),traj_exed(2,:)); 

xtraj = mmd_data{1,1};
hold on; scatter(xtraj(1,:),xtraj(2,:),'r');
legend('ctrller','trajopt','Location','southeast')
title('MMD with dt=0.01, rungeKatta with dt=0.001, scatter with dt=0.01')
%visualizeTraj(x1)

