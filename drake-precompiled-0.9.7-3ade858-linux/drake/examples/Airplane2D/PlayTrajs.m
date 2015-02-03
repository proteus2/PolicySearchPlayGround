load('cost_list_kmm_500_vs_vs_mmd'); 
idx=1;
for x0_idx=1:size(test_x0_list,2)
    x0=test_x0_list(:,x0_idx);
    for alpha_idx=1:numel(alpha_list)
        alpha = alpha_list(alpha_idx);
        x0,alpha
        traj = traj_list_all_alpha{idx,1};
        visualizeTraj(traj)
        idx = idx+1;
    end
end