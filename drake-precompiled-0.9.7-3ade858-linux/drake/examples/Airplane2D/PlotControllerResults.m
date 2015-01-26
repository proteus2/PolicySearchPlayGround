fname = 'cost_list_all_alpha_a=[3,30]_all_algo_if_cost_fun__';

traj_opt_cost = zeros(size(cost_list_all_alpha,1),2);
ctrl1_cost = zeros(size(cost_list_all_alpha,1),2);
ctrl2_cost = zeros(size(cost_list_all_alpha,1),2);
ctrl3_cost = zeros(size(cost_list_all_alpha,1),2);

for idx = 1:size(cost_list_all_alpha,1)
    traj_opt_cost(idx,1) = cost_list_all_alpha{idx,1}(1);
    traj_opt_cost(idx,2) = cost_list_all_alpha{idx,1}(2);
    
    ctrl1_cost(idx,1) = cost_list_all_alpha{idx,2}(1);
    ctrl1_cost(idx,2) = cost_list_all_alpha{idx,2}(2);
    
    ctrl2_cost(idx,1) = cost_list_all_alpha{idx,3}(1);
    ctrl2_cost(idx,2) = cost_list_all_alpha{idx,3}(2);
    
    ctrl3_cost(idx,1) = cost_list_all_alpha{idx,4}(1);
    ctrl3_cost(idx,2) = cost_list_all_alpha{idx,4}(2);
    
    ctrl4_cost(idx,1) = cost_list_all_alpha{idx,5}(1);
    ctrl4_cost(idx,2) = cost_list_all_alpha{idx,5}(2);
end

topt_mean = mean(traj_opt_cost);
topt_std = std(traj_opt_cost);

c1_mean = mean(ctrl1_cost);
c1_std = std(ctrl1_cost);
c2_mean = mean(ctrl2_cost);
c2_std = std(ctrl2_cost);
c3_mean = mean(ctrl3_cost);
c3_std = std(ctrl3_cost);
c4_mean = mean(ctrl4_cost);
c4_std = std(ctrl4_cost);

% 95% confidence interval
n=numel(alpha_list);
c1_CI = 1.96*c1_std/sqrt(n);
c2_CI = 1.96*c2_std/sqrt(n);
c3_CI = 1.96*c3_std/sqrt(n); 
c4_CI = 1.96*c4_std/sqrt(n);


topt_CI = 1.96*topt_std/sqrt(n);

<<<<<<< HEAD
figure;bar(-[c1_mean(1,1),c2_mean(1,1),topt_mean(1,1)],'black') 
hold on; errorbar([-c1_mean(1,1),-c2_mean(1,1),-topt_mean(1,1)],[c1_CI(1),c2_CI(1),topt_CI(1)],'o');

 ax = gca;
 ax.XTickLabel = {'mmd','supervised','trajopt'};
 ylabel('Accumulated Rewards','FontSize',24)
 xlabel('Algorithms','FontSize',24)
 title('Mean of Accumulated Rewards for 150 Different Random Models','FontSize',24)
=======
figure;bar(-[c1_mean(1,1),c2_mean(1,1),c3_mean(1,1),c4_mean(1,1),topt_mean(1,1)]) 
hold on; errorbar([-c1_mean(1,1),-c2_mean(1,1),-c3_mean(1,1),-c4_mean(1,1),-topt_mean(1,1)],[c1_CI(1),c2_CI(1),c3_CI(1),c4_CI(1),topt_CI(1)],'o');

 ax = gca;
 
    train_file1 = 'mmd_results_repmat=1,a=all,algo=nearest_neighbor,aggregation';
    train_file2 = 'mmd_results_repmat=1,a=all_nearest_neighbor';
    train_file3 = 'mmd_results_repmat=1,a=all,algo=RF,aggregation';
    train_file4 = 'mmd_results_repmat=10,a=all';
    
 ax.XTickLabel = {'aggregatedKNN','kNN','aggregatedRF','RF','trajopt'};
 ylabel('Accumulated Rewards')
 xlabel('Algorithms')
     
>>>>>>> b22c35be381c177f4120c8a58db12220866e0993
     