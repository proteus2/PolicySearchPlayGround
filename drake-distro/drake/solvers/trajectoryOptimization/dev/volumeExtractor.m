    load('./observable_init/com_list_for_partially_observations_list.mat');
vols = pi* obs_cands(:,1).^2 .* obs_cands(:,2);

[sorted_vols,sorted_idx] = sort(vols(1:40));
sorted_idx(1)
sorted_idx(15)
sorted_idx(30)
sorted_idx(end-2)