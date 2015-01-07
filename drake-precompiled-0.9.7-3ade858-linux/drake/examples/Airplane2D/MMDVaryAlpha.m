alpha = [10,15,20];
x0=[3.9;0;0;0];
tf = 0.9263;

% Gather initial data
trainMMDwithAlpha(x0,tf,alpha,'traj_list')
% Gather MMD data, with alpha attached to the state

% Train MMD Controller


