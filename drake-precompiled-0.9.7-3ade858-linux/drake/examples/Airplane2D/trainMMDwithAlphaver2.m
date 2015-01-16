train_alpha_list = [5,7,12,14,15,18,20,22,24];
train_alpha_list = [5,7];

n_mmd_itern = 5;
x0 = [3.9;0;0;0];
[controller,data] = trainMMDver2(x0,n_mmd_itern,train_alpha_list);
save('vary_alpha_mmd_results_only_alpha=5_ver6','controller','data','train_alpha_list','train_time');
