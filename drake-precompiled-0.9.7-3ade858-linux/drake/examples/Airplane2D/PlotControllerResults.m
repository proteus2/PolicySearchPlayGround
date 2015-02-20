fname = 'mmd_partial_controller_data.mat';
load(fname);
traj_opt_cost = zeros(size(cost_list_all_alpha,1),1);
ctrl_cost = zeros(size(cost_list_all_alpha,1),1);
% ctrl_cost: avg rewards where rows = different alpha, columns = different algorithm
for idx = 1:size(cost_list_all_alpha,1)
%     traj_opt_cost(idx,1) = cost_list_all_alpha{idx,1}(2);
    for idx2 = 1:size(cost_list_all_alpha,2)
        ctrl_cost(idx,idx2) = cost_list_all_alpha{idx,idx2}(2);
    end
    
end
ctrl_cost(ctrl_cost(:,2)>0.5,:)=[];


%% Learning curve
fname = 'supervised_controller_learning_curve.mat';
load(fname);
n_itern = size(cost_list_all_alpha{1,2},1);
n_tests = size(test_x0_list,2);
costs = zeros(n_tests,n_itern); % rows=ith trajectory addition, columns=ith tests in test_x0_list

traj_opt_costs = zeros(n_tests,1);
for test_idx=1:n_tests 
    for train_idx=1:n_itern
        costs(test_idx,train_idx) = cost_list_all_alpha{test_idx,2}(train_idx,2);
    end
    traj_opt_costs(test_idx,1) = cost_list_all_alpha{test_idx,1}(1,2);
end


%% Speed of executing a trajectory


%% Bar graph at the end of iteration
n = size(cost_list_all_alpha,1);
ctrl_mean=mean(ctrl_cost);
ctrl_std = std(ctrl_cost);
ctrl_CI = 1.96*ctrl_std/sqrt(n);

figure;bar(-[ ctrl_mean]) 
hold on; errorbar(-[ ctrl_mean],[ ctrl_CI],'o');

ax = gca;
ax.XTickLabel = {'trajopt','aggregatedRF'};
ylabel('Average Rewards')
xlabel('Algorithms')

