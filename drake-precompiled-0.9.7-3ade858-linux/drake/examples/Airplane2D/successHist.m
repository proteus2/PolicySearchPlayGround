files = {    
    %'./controllers/mmd_par```tially_observable_controller_h_not_same_smaller_sigma_test_error.mat',...
    %'./controllers/mmd_partially_observable_controller_h_not_same_test_error',...
    %'./controllers/supervised_partially_observable_controller_3_alphas_test_error.mat',...
    './controllers/test_error/mmd_observable_controller_test_error.mat';
    './controllers/test_error/supervised_observable_controller_test_error.mat';
    };

% files = {'./controllers/supervised_mmd_unobservable_controller_test_error'};
all_scores = {};
ctrl_mean_list = [];
ctrl_CI_list = [];
for fidx=1:numel(files)
    fname = files{fidx};
    load(fname);
    n = numel(traj_list_all_alpha);
    score_list = zeros(size(traj_list_all_alpha{1},1),size(traj_list_all_alpha,1));
    for idx=1:size(traj_list_all_alpha,1)
        for idx2=1:size(traj_list_all_alpha{idx},1)
            xtraj = traj_list_all_alpha{idx}{idx2};
            score_list(idx2,idx) =checkSuccess(xtraj);
        end
    end

    success_rate = sum(score_list,2)./size(traj_list_all_alpha,1)
    
    ctrl_mean_list=[ctrl_mean_list mean(score_list,2)'];
    ctrl_std = std(score_list,0,2);
    ctrl_CI_list = [ctrl_CI_list 1.96*ctrl_std'./sqrt(n)];
end
%% For partially obs case
%ctrl_mean_list([1,3]) = ctrl_mean_list([3,1]);
%ctrl_mean_list(1) = ctrl_mean_list(1)-0.03;
%ctrl_CI_list([1,3]) = ctrl_CI_list([3,1]);
%%

trajopt_score_list = zeros(1,size(traj_list_all_alpha,1));
for idx=1:size(traj_list_all_alpha,1)
    xtraj = traj_opt_list_all_alpha{idx}{1};
    trajopt_score_list(idx) = checkSuccess(xtraj);
end

success_rate = sum(score_list)/size(traj_list_all_alpha,1)
traj_opt_success_rate = sum(trajopt_score_list)/size(traj_list_all_alpha,1)
    
traj_opt_mean = mean(trajopt_score_list);
traj_opt_CI =  1.96*std(std(trajopt_score_list))/sqrt(n);

% figure;bar([traj_opt_mean 0 ctrl_mean_list]) 
% hold on; errorbar([traj_opt_mean 0 ctrl_mean_list],[traj_opt_CI 0 ctrl_CI_list],'o');


figure;bar([traj_opt_mean ctrl_mean_list]) 
hold on; errorbar([traj_opt_mean ctrl_mean_list],[traj_opt_CI ctrl_CI_list],'o');

ax = gca;
ax.XTickLabel = {'trajopt','DAgger','TOIL','Supervised'};
title('Success Rate for 50 Different Models')
ylim([0 1])
ylabel('Success Rate')
xlabel('Algorithms')
