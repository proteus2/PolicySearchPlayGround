train_alpha_list = [7,12,14,15,18,20,22,24];

N = size(train_alpha_list,2);
n_dagg_itern = 5;
tf=[1.8647,1.3321,0.7679,0.6568,0.6106,0.5068,0.4557,0.4139,0.3791];

load('official_init_train_traj'); 
init_traj_train_data = traj_list;
x0 = [3.9;0;0;0];
tic
[controller,data] = trainDAgger(x0,tf,init_traj_train_data,n_dagg_itern,train_alpha_list);
train_time = toc
save('dagger_train_time','train_time');