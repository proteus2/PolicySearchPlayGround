clear all;
close all;

n_alpha = 10;
n_obs = 50;
test_alpha_list = zeros(n_obs,n_alpha);
if ~exist('./test_obs_list.mat','file')
    test_obs_list = 0.05*obs_rand + (1-obs_rand)*0.1;
    
    % sample alpha values for each observations: alpha_list(n_obs,n_alphas)
    for obs_idx = 1:n_obs
        obs = test_obs_list(obs_idx);        
        % each alpha value is drawn according to N(1/obs,1)
        test_alpha_list(obs_idx,:) = randn(1,n_alpha) + 1/obs;
    end
    
    % save the alpha values
    save('test_partially_observable_alpha_list','test_alpha_list','test_obs_list');
else
    load('test_partially_observable_alpha_list')
end
load('train_alpha_list');


%% Eval script
trainTest = false;
if trainTest  
    fprintf('Training error evaluation...')
    x0_list = train_x0_list;
    alpha_list = train_alpha_list;
else
    x0_list = repmat([3.9;0;0;0],1,n_obs);
    alpha_list = test_alpha_list;
end

train_file='mmd_partially_observable_controller.mat';
load(train_file);
ctrl_list{1,1} = controller;

x0_alpha_list  = [x0_list; test_obs_list];
for idx=1:size(x0_alpha_list,2)
        x0 = x0_alpha_list(1:4,idx);
        obs = x0_alpha_list(5,idx);
        alpha = test_alpha_list(idx,1);

            fprintf('Will be completing=%0.1f percent\n', idx/size(x0_alpha_list,2) *100);
            if trainTest
                optimaltraj_fname = sprintf('./InitTraining/initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4));
            else
                optimaltraj_fname = sprintf('optimal_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
                optimaltraj_fname = strcat('./data_for_plots/test/',optimaltraj_fname);
            end
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
                save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list_opt','traj_opt_cost');
            else
                load(optimaltraj_fname);
                if trainTest
                    optimal_u = utraj;
                    optimal_x = xtraj;
                end
                u{1,1} = optimal_u;
                tf=optimal_u.getBreaks; tf=tf(end);
                [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha);
                traj_opt_cost
            end

            apprxtraj_fname = './data_for_plots/test/';
                fname = train_file;
                if getLearningCurve
                    fname = strcat(fname,'_learning_curve');
                end
                apprxtraj_fname = strcat(apprxtraj_fname,fname);

            apprxtraj_fname =strcat(apprxtraj_fname,sprintf('_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f]',alpha,x0(1),x0(2),x0(3),x0(4)),'.mat');

            tf = optimal_u.getBreaks; tf=tf(end);
            tf=tf+2;
            [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);


            cost_list_all_alpha{idx,1} = traj_opt_cost;
            cost_list_all_alpha{idx,2} = cost_list(:,:);
            traj_list_all_alpha{idx,1} = traj_list;
            traj_opt_list_all_alpha{idx,1} = traj_list_opt;

end

save('mmd_partially_observable_test_error_sup.mat','cost_list_all_alpha','alpha_list','traj_list_all_alpha','traj_opt_list_all_alpha');
