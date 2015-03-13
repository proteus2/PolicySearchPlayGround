load('sup_unobservable_test_error')
score_list = zeros(1,size(traj_list_all_alpha,1));
for idx=1:size(traj_list_all_alpha,1)
    xtraj = traj_list_all_alpha{idx}{1};
    score_list(idx) =checkSuccess(xtraj);
end

