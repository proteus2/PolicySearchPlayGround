alpha_list = [10 rand(1,10)*20];
alpha_list = [1,2,3,4,5,6,7,8,9];
x0=[3.9;0;0;0];
tf = 0.9263;

% Gather initial data
[c,data]=trainMMDwithAlpha(x0,tf,alpha_list,'traj_list');
% Gather MMD data, with alpha attached to the state
save('vary_alpha_mmd_results','c','data');
% Train MMD Controller


