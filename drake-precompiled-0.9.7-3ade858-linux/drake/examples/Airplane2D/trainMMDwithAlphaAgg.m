train_alpha_list = [5,7,12,14,15,18,20,22,24];
n_mmd_itern = 50;
train_x0_list = {[2;0;0;0],[4;0;0;0]};

x0_rand = rand(1,10);
x0_x = 5*x0_rand + (1-x0_rand)*2;
x0_rand = rand(1,10);
x0_y = 0*x0_rand + (1-x0_rand)*1;

if ~exist('./train_x0_list.mat','file')
train_x0_list = [x0_x;x0_y;zeros(1,10);zeros(1,10)];
train_x0_list = [train_x0_list [4;0;0;0]];
save('train_x0_list');
else
load('train_x0_list')
end
[controller,data] = trainMMD(train_x0_list,n_mmd_itern,train_alpha_list);
save('mmd_results_x0=2,4_agg','controller','data','train_alpha_list','train_x0_list');

% save('mmd_results_repmat=1,a=all,algo=RF,aggregation','controller','data','train_alpha_list');
% load('mmd_results_x0=2,4')
% ctrl_list{1,1}=controller;
% x0=[2;0;0;0]; tf = 2; alpha=5;
% [traj,cost] = EvaluateControllers(ctrl_list,x0,tf,alpha)
