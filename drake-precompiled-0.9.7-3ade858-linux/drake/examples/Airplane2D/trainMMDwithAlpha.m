train_alpha_list = [5,7,12,14,15,18,20,22,24];

n_mmd_itern = 5;
x0 = [3.9;0;0;0];
[controller,data] = trainMMD(x0,n_mmd_itern,train_alpha_list);
save('vary_alpha_mmd_results_allalpha_max_d','controller','data','train_alpha_list');
