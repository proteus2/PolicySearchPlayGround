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
trainDagger = false;
if trainDagger 
    p = PlanePlant();
    x0 = [3.9; 0; 0; 0]; 
    load('traj_list');
    tf = traj_list{1,1}.getBreaks; tf = tf(end);

    [controller,dagger_data] = trainDAgger(x0,tf,p,traj_list);
    save('dagger_data','dagger_data');
else
    load('dagger_data');
    [x,y]=aggregateDataFromCell(dagger_data);
    controller = TreeBagger(50,x,y,'Method','regression');
end

% run runge katta with the controller
x0=[3.9;0;0;0];
p = PlanePlant();
tf=0.9246;
tic
x1 = rungeKattaSimulation(x0,controller,0.001,tf,p);
toc


% visualize trajectory
dt=0.001;
t=0:dt:tf;
traj_exed = x1.eval(t);
figure;scatter(traj_exed(1,:),traj_exed(2,:)); 

xtraj = dagger_data{1,1};
tf = xtraj.getBreaks; tf=tf(end);
t = 0:dt:tf;
xtraj = xtraj.eval(t);
hold on; scatter(xtraj(1,:),xtraj(2,:),'r');
%visualizeTraj(x1)

