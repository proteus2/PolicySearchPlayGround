% Compare controllers
x0 = [3.5;3;0;0];
rand_list = rand(1,100);
alpha_list = rand_list*26 + (1-rand_list)*8;

alpha_list = 26;
for alpha = alpha_list
    optimaltraj_fname = sprintf('optimal_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
    optimaltraj_fname = strcat('./data_for_plots/individual_runs/',optimaltraj_fname);
    if exist(optimaltraj_fname,'file')
        getOptimalTraj = false;
    else
        getOptimalTraj = true;
    end

    if getOptimalTraj 
        [optimal_u,optimal_x] = getTrajectory(x0,alpha); 
        u{1,1} = optimal_u;
        tf=optimal_u.getBreaks; tf=tf(end);
        [traj_list,cost_list]=EvaluateControllers(u,x0,tf,alpha);
        save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list','cost_list');
    else
        load(optimaltraj_fname);
    end


    apprxtraj_fname = sprintf('appx_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
    apprxtraj_fname = strcat('./data_for_plots/individual_runs/',apprxtraj_fname);
    if ~exist(apprxtraj_fname,'file')
        tf = optimal_u.getBreaks; tf=tf(end);
        load('vary_alpha_mmd_results');
        ctrl_list{1,1} = controller;
        load('vary_alpha_supervised_results.mat');
        ctrl_list{2,1} = controller;

        [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
        save(apprxtraj_fname,'traj_list','cost_list','alpha')
    else
        load(apprxtraj_fname)
    end

%     %load(apprxtraj_fname);
   
%   
     visualizeTraj(optimal_x,alpha);
     visualizeTraj(traj_list{1,1},alpha);
     visualizeTraj(traj_list{2,1},alpha);

end