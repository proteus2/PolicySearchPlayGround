% Compare controllers
clear all;
close all;

n_x0=50;
x0_rand = rand(1,n_x0);
if ~exist('./test_alpha_list.mat','file')
    test_alpha_list = 5*x0_rand + (1-x0_rand)*30;
    save('test_alpha_list','test_alpha_list');
else
    load('test_alpha_list')
end

load('train_alpha_list');


%% Eval script
trainTest = false;
if trainTest  
    fprintf('Training error evaluation...')
    x0_list = train_x0_list;
    alpha_list = train_alpha_list;
else
    x0_list = repmat([3.9;0;0;0],1,n_x0);
    alpha_list = test_alpha_list;
end

train_file='mmd_observable_controller.mat';
% train_file = 'supervised_controller.mat';
load(train_file);
trainOnSelection = false;
getLearningCurve = false;
% 
% ctrl_list = cell(n_files,1);
% for fidx = 1:n_files
%     train_file = train_files{1,fidx};
%     load(train_file,'controller');
%     ctrl_list{fidx,1} = controller;
% end
            
if trainOnSelection
    switch class(controller)
        case 'MMDController'
            data_set = controller.data_sets_unnormalized;
            controller_name = 'MMDController';
        otherwise
            data_set = data;
            controller_name = 'TreeBagger';
    end
        
    if getLearningCurve
        ctrl_list = cell(size(data_set,1),1);
        for trainIdx = 1:size(data_set,1)
            ctrl_list{trainIdx,1} = trainOnSelectedData(1:trainIdx,data_set,controller_name);
        end
    else
        ctrl_list{1,1} = trainOnSelectedData(trainIdx,data_set,controller,'TreeBagger');
    end
else
    ctrl_list{1,1} = controller;
%     train_file='supervised_controller.mat';
%     load(train_file)
%     ctrl_list{2,1} = controller;
%         train_file='dagg_results_alpha_0.001.mat';
%     load(train_file);
%     ctrl_list{3,1} = controller;
end
%  
% load('ctrl_list');
x0_alpha_list  = [x0_list; alpha_list];
% a=ctrl_list{end,1};
% ctrl_list ={};
% ctrl_list{1} = a;
for idx=1:size(x0_alpha_list,2)
        x0 = x0_alpha_list(1:4,idx);
        alpha = x0_alpha_list(5,idx);
        
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
%             if ~trainTest
%                 save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list_opt','traj_opt_cost');
%             end
        end

        apprxtraj_fname = './data_for_plots/test/';
            fname = train_file;
            if getLearningCurve
                fname = strcat(fname,'_learning_curve');
            end
            apprxtraj_fname = strcat(apprxtraj_fname,fname);
            
        apprxtraj_fname =strcat(apprxtraj_fname,sprintf('_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f]',alpha,x0(1),x0(2),x0(3),x0(4)),'.mat');

%         if ~exist(apprxtraj_fname,'file')
            tf = optimal_u.getBreaks; tf=tf(end);
            tf=tf+2;
            [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
%             save(apprxtraj_fname,'traj_list','cost_list','alpha','ctrl_list')
%         else
%             load(apprxtraj_fname)
%             tf = optimal_u.getBreaks; tf=tf(end);
%             tf=tf+2;
%             [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
%             save(apprxtraj_fname,'traj_list','cost_list','alpha','ctrl_list')
%         end

        cost_list_all_alpha{idx,1} = traj_opt_cost;
        cost_list_all_alpha{idx,2} = cost_list(:,:);
         traj_list_all_alpha{idx,1} = traj_list;
         traj_opt_list_all_alpha{idx,1} = traj_list_opt;
         
end

save('observable_test_error.mat','cost_list_all_alpha','alpha_list','traj_list_all_alpha','test_x0_list','traj_opt_list_all_alpha');
% 
% traj_opt_cost = zeros(size(cost_list_all_alpha,1),2);
% 
% ctrl1_cost = zeros(size(cost_list_all_alpha,1),2);
% ctrl2_cost = zeros(size(cost_list_all_alpha,1),2);
% 
% for idx = 1:size(cost_list_all_alpha,1)
%     traj_opt_cost(idx,1) = cost_list_all_alpha{idx,1}(1);
%     traj_opt_cost(idx,2) = cost_list_all_alpha{idx,1}(2);
%     
%     ctrl1_cost(idx,1) = cost_list_all_alpha{idx,2}(1);
%     ctrl1_cost(idx,2) = cost_list_all_alpha{idx,2}(2);
%     
%     ctrl2_cost(idx,1) = cost_list_all_alpha{idx,3}(1);
%     ctrl2_cost(idx,2) = cost_list_all_alpha{idx,3}(2);
% end
% 
% topt_mean = mean(traj_opt_cost);
% topt_std = std(traj_opt_cost);
% 
% c1_mean = mean(ctrl1_cost);
% c1_std = std(ctrl1_cost);
% c2_mean = mean(ctrl2_cost);
% c2_std = std(ctrl2_cost);
% 
% abs(c1_mean-topt_mean)
% abs(c1_mean-c2_mean)
