% potential alpha=velocity, mass, initial and final goal states

 
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


% get each state and action trajectory
load('traj_list');
n = size(traj_list,1);
x=[];y=[];
dt=0.001;
for idx=1:10
    if idx == 5
        continue;
    end
    xtraj = traj_list{idx,1};
    tf = xtraj.getBreaks; tf=tf(end);
    t = 0:dt:tf;
    xtraj = xtraj.eval(t);
    utraj = traj_list{idx,2};
    utraj = utraj.eval(t);

    % make it into a data form
    x = [x xtraj];
    y = [y utraj];
end
x=x';y=y';  


% train Random Forest
controller = TreeBagger(50,x,y,'Method','regression');

% run runge katta with the controller
x0 = [0; 9; 0; 0]; 
p = PlanePlant();
tic
x1 = rungeKattaSimulation(x0,controller,1,p);
toc

t=0:dt:2;
traj_exed = x1.eval(t);
figure;scatter(traj_exed(1,:),traj_exed(2,:)); 
xtraj = traj_list{1,1};
tf = xtraj.getBreaks; tf=tf(end);
t = 0:dt:tf;
xtraj = xtraj.eval(t);
hold on; scatter(xtraj(1,:),xtraj(2,:),'r');
% visualize
%visualizeTraj(x1)

