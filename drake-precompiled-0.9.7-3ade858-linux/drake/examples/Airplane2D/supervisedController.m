% potential alpha=velocity, mass, initial and final goal states
 
gatherData = false;
if gatherData 
    N = 10;
    traj_list = cell(N,2);
   
    for idx=1:N
        seed_num = rand(1);
        rand_num = (0.5-0)*seed_num+ 0;
        if seed_num <=0.3
            x=3.9+rand_num;
        elseif seed_num>0.3 && seed_num <=0.6
            x=3.9;
        else
            x=3.9-rand_num;
        end
        x0 = [x;0;0;0];
        [utraj,xtraj] = getTrajectory(x0);
        %visualizeTraj(xtraj);
        traj_list{idx,1} = xtraj;
        traj_list{idx,2} = utraj;
    end

    save('supervised_data','traj_list');
    return;
end

varyAlphaGatherData = true;
if varyAlphaGatherData 
    traj_list = cell(N,2);
    alpha_vals = zeros(N,1);
    train_alpha_list = [];
    N = size(train_alpha_list,1);
    for idx=1:N
        alpha = train_alpha_list(idx);
        x0 = [3.9;0;0;0];
        [utraj,xtraj] = getTrajectory(x0,alpha);
        %visualizeTraj(xtraj);
        traj_list{idx,1} = xtraj;
        traj_list{idx,2} = utraj;
    end
    [x,y] = aggregateDataFromCell(traj_list); 
    controller = TreeBagger(50,x,y,'Method','regression');
    data = traj_list;
    save('vary_alpha_supervised_results','controller','data','train_alpha_list');
    return;
end


% get each state and action trajectory
%load('traj_list_good_vary_x,y=9');
% load('supervised_vary_alpha,data');
% N = size(traj_list,1);
% x=[];y=[];
% dt=0.001;
% for idx=1:size(traj_list,1)
%         xtraj = traj_list{idx,1};
%         tf = xtraj.getBreaks; tf=tf(end); 
%         t = 0:0.001:tf;
%         alpha = ones(1,size(t,2))*alpha_vals(idx);
%         xtraj = xtraj.eval(t);
%         xtraj = [xtraj; alpha];
% 
%         utraj = traj_list{idx,2};
%         utraj = utraj.eval(t);
% 
%         % make it into a data form
%         x = [x xtraj];
%         y = [y utraj];
% end
% x=x';y=y';  
% 
% % train Random Forest
% controller = TreeBagger(50,x,y,'Method','regression');
% 
% % test controller and different x0s.
% x0 = [3.9;0;0;0];
% dt=0.001;
% alpha_list = [];
% traj_cost_list = [];
% ctrl_cost_list =[];
% x_ctrller_list = cell(0,1);
% x_traj_list = cell(0,1);
% for n=1:10
%     alpha = rand(1)*20;
%     alpha_list = [alpha_list alpha];
%     p = PlanePlant(alpha);
%     [x_ctrller,x_traj,traj_cost,ctrl_cost] = compareControllerAndTrajOpt(x0,controller,dt,p,true);
%     traj_cost_list = [traj_cost_list;traj_cost];
%     ctrl_cost_list = [ctrl_cost_list;ctrl_cost];
%     x_ctroller_list{n,1} = x_ctrller;
%     x_traj_list{n,1} = x_traj;
%     x_ctrller_list{n,1} = x_ctrller;
% end
% 
% save('vary_alpha_supervised_results','alpha_list','traj_cost_list','ctrl_cost_list','x_ctrller_list','x_traj_list');
%visualizeTraj(x_ctrller)
%figure;visualizeTraj(x_traj);

% Evaluate and visualize trajectories at each training x0
% plotTrajectories(controller,dt,traj_list);


