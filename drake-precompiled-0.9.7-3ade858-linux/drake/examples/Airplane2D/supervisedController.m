% potential alpha=velocity, mass, initial and final goal states
 
gatherData = true;
if gatherData == true
    N = 10;
    traj_list = cell(N,2);
   
    for idx=0:N-1
        rand_num = (0.5-0)*rand(1) + 0;
        if rand(1) <0.3
            x=3.9+rand_num;
        elseif rand(1)>=0.3 && rand(1) <=0.6
            x=3.9
        else
            x=3.9-rand_num;
        end
        x0 = [x;0;0;0];
        [utraj,xtraj] = getTrajectory(x0);
        %visualizeTraj(xtraj);
        traj_list{idx+1,1} = xtraj;
        traj_list{idx+1,2} = utraj;
    end

    save('traj_list','traj_list');
end

return;

% get each state and action trajectory
%load('traj_list_good_vary_x,y=9');
load('traj_list');
N = size(traj_list,1);
x=[];y=[];
dt=0.001;
for idx=1:N
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

% test controller and different x0s.
x0 = [4.2571;0;0;0];
[x_ctrller,x_traj,traj_cost,ctrl_cost] = compareControllerAndTrajOpt(x0,controller,dt);
visualizeTraj(x_ctrller)
figure;visualizeTraj(x_traj);

% Evaluate and visualize trajectories at each training x0
% plotTrajectories(controller,dt,traj_list);


