% Compare controllers
x0 = [4.3;1;0;0];
rand_list = rand(1,100);
alpha_list = rand_list*35 + (1-rand_list)*5;

alpha_list = 5;
for alpha = alpha_list
    optimaltraj_fname = sprintf('optimal_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
    optimaltraj_fname = strcat('./data_for_plots/test/',optimaltraj_fname);
    if exist(optimaltraj_fname,'file')
        getOptimalTraj = false;
    else
        getOptimalTraj = true;
    end

    if getOptimalTraj 
        [optimal_u,optimal_x] = getTrajectory(x0,alpha,false); 
        u{1,1} = optimal_u;
        tf=optimal_u.getBreaks; tf=tf(end);
        [traj_list_opt,cost_list_opt]=EvaluateControllers(u,x0,tf,alpha);
        save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list','cost_list');
    else
        load(optimaltraj_fname);
    end


    apprxtraj_fname = sprintf('appx_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
    apprxtraj_fname = strcat('./data_for_plots/test/',apprxtraj_fname);
    if ~exist(apprxtraj_fname,'file')
        tf = optimal_u.getBreaks; tf=tf(end);
        load('vary_alpha_mmd_results_only_alpha=5_ver6.mat');
%         mmd_ctrl=MMDController();
%         for idx=1:size(controller.data_sets_unnormalized,1)
%             mmd_ctrl = setNewController(mmd_ctrl,controller.data_sets_unnormalized{idx,1},controller.data_sets_unnormalized{idx,2});
%         end
%         ctrl_list{1,1} = mmd_ctrl;
        ctrl_list{1,1} = controller;
        
        load('vary_alpha_supervised_results_alpha=5,iter=5');
        %load('vary_alpha_mmd_results_only_alpha=5_ver2.mat');
        ctrl_list{2,1} = controller;

        [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
        save(apprxtraj_fname,'traj_list','cost_list','alpha')
    else
        load(apprxtraj_fname)
    end

%     %load(apprxtraj_fname);
   
%   
     x1 = traj_list{1,1}.eval(traj_list{1,1}.getBreaks);
      x2 = traj_list{2,1}.eval(traj_list{1,1}.getBreaks);
     optx = optimal_x.eval(optimal_x.getBreaks);
     
     figure; scatter(x1(1,:),x1(2,:),'r');
      hold on; scatter(x2(1,:),x2(2,:),'blue');
     hold on; scatter(optx(1,:),optx(2,:),'black');
     legend('mmd','sup','opt','Location','southwest');
%      visualizeTraj(optimal_x,alpha);
     visualizeTraj(traj_list{1,1},alpha);
      visualizeTraj(traj_list{2,1},alpha);


end
