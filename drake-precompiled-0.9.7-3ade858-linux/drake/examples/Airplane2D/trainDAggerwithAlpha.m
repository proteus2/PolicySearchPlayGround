n_dagg_itern = 10;

n_x0=30;
x0_rand = rand(1,n_x0);
x0_x = 2*x0_rand + (1-x0_rand)*4;
x0_rand = rand(1,n_x0);
x0_y = 0*x0_rand + (1-x0_rand)*1;

if ~exist('./train_alpha_list.mat','file')
    train_alpha_list = 5*x0_rand + (1-x0_rand)*30;
    save('train_alpha_list','train_alpha_list');
else
    load('train_alpha_list')
end

if ~exist('./train_x0_list.mat','file')
    train_x0_list = [x0_x;x0_y;zeros(1,n_x0);zeros(1,n_x0)];
    save('train_x0_list','train_x0_list');
else
    load('train_x0_list');
end

[controller,data] = trainDAgger(train_x0_list,n_dagg_itern,train_alpha_list);
save('dagg_results_alpha_0.001.mat','controller','data','train_alpha_list','train_x0_list');
