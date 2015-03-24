files = {'./controllers/test_error/supervised_partially_observable_controller_test_error.mat'...,
    './controllers/test_error/mmd_partially_observable_controller_test_error.mat'...,
    './controllers/test_error/dagger_partially_observable_controller_test_error.mat'};

all_scores = {};
ctrl_mean_list = [];
ctrl_CI_list = [];
for fidx=1:numel(files)
    fname = files{fidx};
    load(fname);
    n = numel(traj_list_all_alpha)
    score_list = zeros(1,size(traj_list_all_alpha,1));
    for idx=1:size(traj_list_all_alpha,1)
        xtraj = traj_list_all_alpha{idx}{1};
        score_list(idx) =checkSuccess(xtraj);
    end

    success_rate = sum(score_list)/size(traj_list_all_alpha,1)
    
    ctrl_mean_list=[ctrl_mean_list mean(score_list)];
    ctrl_std = std(score_list);
    ctrl_CI_list = [ctrl_CI_list 1.96*ctrl_std/sqrt(n)];
end

ctrl_mean_list([1,3]) = ctrl_mean_list([3,1]);
ctrl_mean_list(1) = ctrl_mean_list(1)-0.03
ctrl_CI_list([1,3]) = ctrl_CI_list([3,1]);


trajopt_score_list = zeros(1,size(traj_list_all_alpha,1));
for idx=1:size(traj_list_all_alpha,1)
    xtraj = traj_opt_list_all_alpha{idx}{1};
    trajopt_score_list(idx) = checkSuccess(xtraj);
end

success_rate = sum(score_list)/size(traj_list_all_alpha,1)
traj_opt_success_rate = sum(trajopt_score_list)/size(traj_list_all_alpha,1)
    
traj_opt_mean = mean(trajopt_score_list);
traj_opt_CI =  1.96*std(std(trajopt_score_list))/sqrt(n);

figure;bar([traj_opt_mean ctrl_mean_list]) 
hold on; errorbar([traj_opt_mean ctrl_mean_list],[traj_opt_CI ctrl_CI_list],'o');

ax = gca;
ax.XTickLabel = {'trajopt','DAgger','TOIL','Supervised',};
title('Success Rate for 50 Different Models')
ylabel('Success Rate')
xlabel('Algorithms')
