train_alpha_list = [5,7,12,14,15,18,20,22,24];

N = size(train_alpha_list,2);
n_dagg_itern = 5;



x0 = [3.9;0;0;0];
% [utraj,xtraj]=getTrajectory(x0,10,false);
% traj_list{1,1} = xtraj; traj_list{1,2} = utraj;
% save('init_traj_train_data','traj_list')
load('init_traj_train_data');
init_traj_train_data = traj_list;

tic
[controller,data] = trainDAgger(x0,init_traj_train_data,n_dagg_itern,train_alpha_list);
train_time = toc
save('dagger_train_time','train_time');