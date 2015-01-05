% potential alpha=velocity, mass, initial and final goal states

% gather initial data
gatherData = false;
if gatherData == true
    N = 10;
    traj_list = cell(N,2);
   
    for idx=0:N-1
        x0 = [idx;9;0;0];
        [utraj,xtraj] = getTrajectory(x0);
        %visualizeTraj(xtraj);
        traj_list{idx+1,1} = xtraj;
        traj_list{idx+1,2} = utraj;
    end

    save('traj_list','traj_list');
end


% train using DAgger
p = PlanePlant();
x0 = [0; 9; 0; 0]; 
tf=2;
[controller,dagger_data] = trainDAgger(x0,tf,p);
save('dagger_data','dagger_data');

% run runge katta with the controller
p = PlanePlant();
tic
x1 = rungeKattaSimulation(x0,controller,tf,p);
toc


% visualize trajectory
t=0:dt:1;
traj_exed = x1.eval(t);
figure;scatter(traj_exed(1,:),traj_exed(2,:)); 
xtraj = traj_list{1,1};
tf = xtraj.getBreaks; tf=tf(end);
t = 0:dt:tf;
xtraj = xtraj.eval(t);
hold on; scatter(xtraj(1,:),xtraj(2,:),'r');
%visualizeTraj(x1)

