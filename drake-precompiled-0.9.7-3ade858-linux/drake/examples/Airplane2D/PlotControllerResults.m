fname = 'mmd_partial_results_test_error.mat';
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

