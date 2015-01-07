% potential alpha=velocity, mass, initial and final goal states

% gather initial data
gatherData = false;
if gatherData == true
    traj_list = cell(1,2);

    x0 = [3.9;0;0;0];
    [utraj,xtraj] = getTrajectory(x0);
    %visualizeTraj(xtraj);
    traj_list{1,1} = xtraj;
    traj_list{1,2} = utraj;

    save('traj_list','traj_list');
end


% train using DAgger
train =false;
if train
    load('traj_list');
    p = PlanePlant();
    x0 = [3.9; 0; 0; 0]; 
    tf=2;
    [controller,mmd_data] = trainMMD(x0,tf,traj_list,p);
    save('mmd_data','mmd_data');
end

load('mmd_data');
dt=0.001; t=0:dt:tf; 
controller = MMDController(t);
for idx=1:size(mmd_data,1)
    controller = setNewController(controller,mmd_data{idx,1},mmd_data{idx,2});
end

% run runge katta with the controller
%% visualize trajectory
tf=1.0; dt=0.01;
p = PlanePlant();
tf=2;
tic
x1 = rungeKattaSimulation(x0,controller,dt,tf,p);
toc


tf=1
t=0:dt:tf;
traj_exed = x1.eval(t);
figure;scatter(traj_exed(1,:),traj_exed(2,:)); 
xtraj = traj_list{1,1};
tf = xtraj.getBreaks; tf=tf(end);
t = 0:dt:tf;
xtraj = xtraj.eval(t);
hold on; scatter(xtraj(1,:),xtraj(2,:),'r');
legend('ctrller','trajopt')
%visualizeTraj(x1)

