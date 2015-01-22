train_alpha_list = [5,7,12,14,15,18,20,22,24];
train_alpha_list = [5,7,24];
n_mmd_itern = 50;
x0 = [3.9;0;0;0];

[controller,data] = trainMMD(x0,n_mmd_itern,train_alpha_list);
save('mmd_results_repmat=10,a=5,7,24','controller','data','train_alpha_list');
