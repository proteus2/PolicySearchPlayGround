train_alpha_list = [5,7,12,14,15,18,20,22,24];
n_mmd_itern = 50;
train_x0_list = {[2;0;0;0],[4;0;0;0],[10;0;0;0],[8;0;0;0]};

[controller,data] = trainMMD(train_x0_list,n_mmd_itern,train_alpha_list);
save('mmd_results_repmat=1','controller','data','train_alpha_list','train_x0_list');

% save('mmd_results_repmat=1,a=all,algo=RF,aggregation','controller','data','train_alpha_list');
