% Compare controllers
x0 = [3.9;0;0;0];
rand_list = rand(1,30);
alpha_list = rand_list*26 + (1-rand_list)*8;

for alpha = alpha_list
    optimaltraj_fname = sprintf('optimal_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
    optimaltraj_fname = strcat('./data_for_plots/',optimaltraj_fname);
    if exist(optimaltraj_fname,'file')
        getOptimalTraj = false;
    else
        getOptimalTraj = true;
    end

    if getOptimalTraj 
        [optimal_u,optimal_x] = getTrajectory(x0,alpha); 
        save(optimaltraj_fname,'optimal_u','optimal_x')
    else
        load(optimaltraj_fname);
    end


    apprxtraj_fname = sprintf('appx_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
    apprxtraj_fname = strcat('./data_for_plots/',apprxtraj_fname);
    if ~exist(apprxtraj_fname,'file')
        tf = optimal_u.getBreaks; tf=tf(end);
        load('vary_alpha_mmd_results');
        ctrl_list{1,1} = controller;
        load('vary_alpha_supervised_results.mat');
        ctrl_list{2,1} = controller;

        [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
        save(apprxtraj_fname,'traj_list','cost_list')
    else
        load(apprxtraj_fname)
    end

%     %load(apprxtraj_fname);
%     visualizeTraj(traj_list{1,1}); 
%     visualizeTraj(traj_list{2,1}); 
% 
%     visualizeTraj(optimal_x); 

end