train_alpha_list = [5,7,12,14,15,18,20,22,24];

n_dagg_itern = 5;



x0 = [3.9;0;0;0];


tic
[controller,data] = trainDAgger(x0,n_dagg_itern,train_alpha_list);
train_time = toc
save('dagger_train_time','train_time');