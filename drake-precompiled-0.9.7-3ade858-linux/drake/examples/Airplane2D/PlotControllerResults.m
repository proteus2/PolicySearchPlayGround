fname = 'mmd_results_training_error2';
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

n = size(cost_list_all_alpha,1);

topt_mean = mean(traj_opt_cost);
topt_std = std(traj_opt_cost);
topt_CI = 1.96*topt_std/sqrt(n);

ctrl_mean=mean(ctrl_cost);
ctrl_std = std(ctrl_cost);
ctrl_CI = 1.96*ctrl_std/sqrt(n);


figure;bar(-[ ctrl_mean]) 
hold on; errorbar(-[ ctrl_mean],[ ctrl_CI],'o');

ax = gca;
 ax.XTickLabel = {'trajopt','aggregatedRF'};
 ylabel('Average Rewards')
 xlabel('Algorithms')

% 
% figure;bar(-[c1_mean(1,2),c2_mean(1,2),topt_mean(1,2)]) 
% hold on; errorbar([-c1_mean(1,2),-c2_mean(1,2),-topt_mean(1,2)],[c1_CI(2),c2_CI(2),topt_CI(2)],'o');

% figure;bar(-[c1_mean(1,2),topt_mean(1,2)]) 
% hold on; errorbar([-c1_mean(1,2),-topt_mean(1,2)],[c1_CI(2),topt_CI(2)],'o');

% figure;bar(-[c1_mean(1,2),c2_mean(1,2),c3_mean(1,2),topt_mean(1,2)]) 
% hold on; errorbar([-c1_mean(1,2),-c2_mean(1,2),-c3_mean(1,2),-topt_mean(1,2)],[c1_CI(2),c2_CI(2),c3_CI(2),topt_CI(2)],'o');

%  ax = gca;
% %  ax.XTickLabel = {'aggregatedKNN','kNN','aggregatedRF','RF','trajopt'};
%  ax.XTickLabel = {'aggregatedRF','RF','trajopt'};
%  ylabel('Accumulated Rewards')
%  xlabel('Algorithms')
     
     