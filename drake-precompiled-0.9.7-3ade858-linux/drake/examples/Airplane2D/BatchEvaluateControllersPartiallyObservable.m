% Compare controllers
clear all;
close all;

n_x0=50;
n_alpha = 5;
test_alpha_list = zeros(n_x0,n_alpha);
obs_rand = rand(1,n_x0);

if ~exist('./test_partially_observable_alpha_list.mat','file')
    test_obs_list = 0.05*obs_rand + (1-obs_rand)*0.1;
    
    % sample alpha values for each observations: alpha_list(n_obs,n_alphas)
    for obs_idx = 1:n_x0
        obs = test_obs_list(obs_idx);        
        % each alpha value is drawn according to N(1/obs,1)
        test_alpha_list(obs_idx,:) = randn(1,n_alpha) + 1/obs;
    end
    
    % save the alpha values
    save('test_partially_observable_alpha_list','test_alpha_list','test_obs_list');
else
    load('test_partially_observable_alpha_list')
end


%% Eval script
x0_list = repmat([3.9;0;0;0],1,n_x0);
alpha_list = test_alpha_list;

train_file='./controllers/supervised_partially_observable_controller.mat';
load(train_file);
trainOnSelection = false;
getLearningCurve = false;
ctrl_list{1,1} = controller;
x0_alpha_list  = [x0_list; test_obs_list];


for idx=1:size(x0_alpha_list,2)
        x0 = x0_alpha_list(1:4,idx);
        obs = x0_alpha_list(5,idx);
        
    	fprintf('Will be completing=%0.1f percent\n', idx/size(x0_alpha_list,2) *100);
        optimaltraj_fname = sprintf('optimal_traj_with_obs=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',obs,x0(1),x0(2),x0(3),x0(4));
        optimaltraj_fname = strcat('./data_for_plots/test/',optimaltraj_fname);
        
        if exist(optimaltraj_fname,'file')
            getOptimalTraj = false;
        else
            getOptimalTraj = true;
        end

        % for each obs, take one alpha value to test.
        if getOptimalTraj 
            alpha_for_obs = test_alpha_list(idx,:);
            [optimal_u,optimal_x] = getRobustTrajectory(x0,alpha_for_obs,false);         
            u{1,1} = optimal_u;
            tf=optimal_u.getBreaks; tf=tf(end);
            [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha_for_obs(1));
            save(optimaltraj_fname,'optimal_u','optimal_x','alpha_for_obs','traj_list_opt','traj_opt_cost');
        else
            load(optimaltraj_fname);
            u{1,1} = optimal_u;
            tf=optimal_u.getBreaks; tf=tf(end);
            [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha_for_obs(1));
            traj_opt_cost
        end

        apprxtraj_fname = './data_for_plots/test/';
        fname = train_file;
        apprxtraj_fname = strcat(apprxtraj_fname,fname);
        apprxtraj_fname =strcat(apprxtraj_fname,sprintf('_obs=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f]',obs,x0(1),x0(2),x0(3),x0(4)),'.mat');

        tf = optimal_u.getBreaks; tf=tf(end);
        tf=tf+2;
        [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha_for_obs(1));


        cost_list_all_alpha{idx,1} = traj_opt_cost;
        cost_list_all_alpha{idx,2} = cost_list(:,:);
        traj_list_all_alpha{idx,1} = traj_list;
        traj_opt_list_all_alpha{idx,1} = traj_list_opt;
         
end
controller_name = strtok(train_file,'.');
save_fname=strcat(controller_name,'_test_error.mat');
save(save_fname,'cost_list_all_alpha','alpha_list','traj_list_all_alpha','traj_opt_list_all_alpha');

