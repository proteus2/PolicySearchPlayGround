alpha_list = [11,12,13,14,20];
x0=[3.9;0;0;0];
tf = 0.9263;

% Gather initial data
[c,data]=trainMMDwithAlpha(x0,tf,alpha_list,'traj_list');
% Gather MMD data, with alpha attached to the state
save('vary_alpha_mmd_results_smaller_mmd','c','data');
% Train MMD Controller


