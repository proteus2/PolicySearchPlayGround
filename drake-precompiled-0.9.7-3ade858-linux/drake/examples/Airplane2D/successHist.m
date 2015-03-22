load('./controllers/mmd_observable_controller_test_error.mat')

score_list = zeros(1,size(traj_list_all_alpha,1));
for idx=1:size(traj_list_all_alpha,1)
    xtraj = traj_list_all_alpha{idx}{1};
    score_list(idx) =checkSuccess(xtraj);
end

success_rate = sum(score_list)/size(traj_list_all_alpha,1)

trajopt_score_list = zeros(1,size(traj_list_all_alpha,1));
for idx=1:size(traj_list_all_alpha,1)
    xtraj = traj_opt_list_all_alpha{idx}{1};
    trajopt_score_list(idx) = checkSuccess(xtraj);
end

traj_opt_success_rate = sum(trajopt_score_list)/size(traj_list_all_alpha,1)
