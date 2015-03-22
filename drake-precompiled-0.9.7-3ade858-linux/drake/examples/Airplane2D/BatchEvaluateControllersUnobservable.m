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

train_file='./controllers/mmd_unobservable_controller.mat';
load(train_file);
ctrl_list{1,1} = controller;



train_file='./controllers/supervised_unobservable_controller.mat';
load(train_file);
ctrl_list{2,1} = controller;

x0_alpha_list  = [x0_list; alpha_list];
for idx=1:size(x0_alpha_list,2)
        x0 = x0_alpha_list(1:4,idx);
        alpha = x0_alpha_list(5,idx);
        
    	fprintf('Will be completing=%0.1f percent\n', idx/size(x0_alpha_list,2) *100);
        %optimaltraj_fname = sprintf('optimal_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
        optimaltraj_fname = sprintf('robust_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
        optimaltraj_fname = strcat('./data_for_plots/test/',optimaltraj_fname);
        
        if exist(optimaltraj_fname,'file')
            getOptimalTraj = false;
        else
            getOptimalTraj = true;
        end

        if getOptimalTraj 
            %[optimal_u,optimal_x] = getTrajectory(x0,alpha,false);
            [optimal_u,optimal_x] = getRobustTrajectory(x0,alpha,false);         

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
controller_name = strtok(train_file,'.');
save_fname=strcat(controller_name,'_test_error.mat');
save_fname=strcat('.',save_fname);
save(save_fname,'cost_list_all_alpha','alpha_list','traj_list_all_alpha','traj_opt_list_all_alpha');

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
