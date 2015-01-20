train_alpha_list = [5,7,12,14,15,18,20,22,24];
train_alpha_list = [5];

n_mmd_itern = 5;
x0 = [3.9;0;0;0];
[controller,data] = trainMMD(x0,n_mmd_itern,train_alpha_list);
save('vary_alpha_mmd_results_alpha=5,7_recoveryTraj_ver1','controller','data','train_alpha_list');
