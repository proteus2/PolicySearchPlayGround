% Compare controllers
x0 = [3.9;0;0;0];
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
        [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha);
        save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list','traj_opt_cost');
    else
        load(optimaltraj_fname);
    end


    apprxtraj_fname = sprintf('appx_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
    
    train_file1 = 'mmd_results_repmat.mat';
    train_file2 = 'vary_alpha_supervised_results_alpha=5,iter=5';
    apprxtraj_fname = strcat('./data_for_plots/test/',train_file1,'_',train_file2,'_',apprxtraj_fname);
    
    if ~exist(apprxtraj_fname,'file')
        tf = optimal_u.getBreaks; tf=tf(end);
        load(train_file1);
        ctrl_list{1,1} = controller;
        
        load(train_file2);
        ctrl_list{2,1} = controller;

        [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
        save(apprxtraj_fname,'traj_list','cost_list','alpha')
    else
        load(apprxtraj_fname)
    end

%      x1 = traj_list{1,1}.eval(traj_list{1,1}.getBreaks);
%       x2 = traj_list{2,1}.eval(traj_list{1,1}.getBreaks);
%      optx = optimal_x.eval(optimal_x.getBreaks);
%      
%      figure; scatter(x1(1,:),x1(2,:),'r');
%       hold on; scatter(x2(1,:),x2(2,:),'blue');
%      hold on; scatter(optx(1,:),optx(2,:),'black');
%      legend('mmd','sup','opt','Location','southwest');
% 
%      figure;bar(-[cost_list(1,1),cost_list(2,1),traj_opt_cost(1,1)])
%      ax = gca;
%      ax.XTickLabel = {'mmd','supervised','trajopt'};
%      ylabel('Accumulated Rewards')
%      xlabel('Algorithms')
%      
%      figure;bar(-[cost_list(1,2),cost_list(2,2),traj_opt_cost(1,2)])
%      ax = gca;
%      ax.XTickLabel = {'mmd','supervised','trajopt'};
%      ylabel('Average Rewards')
%      xlabel('Algorithms')
     
%      visualizeTraj(traj_list{1,1},alpha);
%       visualizeTraj(traj_list{2,1},alpha);
end
