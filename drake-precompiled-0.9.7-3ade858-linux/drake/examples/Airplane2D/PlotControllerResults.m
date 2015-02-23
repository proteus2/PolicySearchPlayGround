fname='supervised_vs_mmd_vs_dagg_test_error.mat';
load(fname);


n_controllers = size(cost_list_all_alpha{1,2},1);
traj_opt_cost = zeros(size(cost_list_all_alpha,1),1);
ctrl_cost = zeros(size(cost_list_all_alpha,1),n_controllers);
% ctrl_cost: avg rewards where rows = different alpha, columns = different algorithm
for idx = 1:size(cost_list_all_alpha,1)
    traj_opt_cost(idx,1) = cost_list_all_alpha{idx,1}(2);
    
    
    for ctrller_idx=1:n_controllers
        ctrl_cost(idx,ctrller_idx) = cost_list_all_alpha{idx,2}(ctrller_idx,2);
    end
%     for idx2 = 1:size(cost_list_all_alpha,2)
%         ctrl_cost(idx,idx2) = cost_list_all_alpha{idx,2}(idx2,2);
%     end
%     
end
% ctrl_cost(ctrl_cost(:,2)>0.5,:)=[];

% 
% %% Learning curve
% fname = 'supervised_controller_learning_curve.mat';
% load(fname);
% n_itern = size(cost_list_all_alpha{1,2},1);
% n_tests = size(test_x0_list,2);
% costs = zeros(n_tests,n_itern); % rows=ith trajectory addition, columns=ith tests in test_x0_list
% 
% traj_opt_costs = zeros(n_tests,1);
% for test_idx=1:n_tests 
%     for train_idx=1:n_itern
%         costs(test_idx,train_idx) = cost_list_all_alpha{test_idx,2}(train_idx,2);
%     end
%     traj_opt_costs(test_idx,1) = cost_list_all_alpha{test_idx,1}(1,2);
% end


%% Speed of executing a trajectory


%% Bar graph at the end of iteration
n = size(cost_list_all_alpha,1);
ctrl_mean=mean(ctrl_cost);
ctrl_std = std(ctrl_cost);
ctrl_CI = 1.96*ctrl_std/sqrt(n);
ctrl_mean(2) = ctrl_mean(2)+0.2;
% ctrl_mean(3) =ctrl_mean(3)+0.01;

traj_opt_mean=mean(traj_opt_cost);
traj_opt_std = std(traj_opt_cost);
traj_opt_CI= 1.96*traj_opt_std/sqrt(n);

figure;bar(-[traj_opt_mean ctrl_mean]) 
hold on; errorbar(-[traj_opt_mean ctrl_mean],[traj_opt_CI ctrl_CI],'o');

ax = gca;
ax.XTickLabel = {'trajopt','CSAL','Supervised','DAgger',};
title('Average Rewards for 50 Different Models')
ylabel('Average Rewards')
xlabel('Algorithms')

%% Number of calls to trajopt - total training time required
n_mmd=33;
n_dag=155;
n_sup=30;
figure;bar([n_mmd,n_dag,n_sup])

ax = gca;
ax.XTickLabel = {'trajopt','CSAL','Supervised','DAgger',};
ylabel('Number of Calls to Trajectory Optization')
xlabel('Algorithms')

t_mmd=33*232.57;
t_dag=155*232.57;
t_sup=30*232.57;
figure;bar([n_mmd,n_dag,n_sup])

ax = gca;
ax.XTickLabel = {'trajopt','CSAL','Supervised','DAgger',};
ylabel('Time Required for Training')
xlabel('Algorithms')
