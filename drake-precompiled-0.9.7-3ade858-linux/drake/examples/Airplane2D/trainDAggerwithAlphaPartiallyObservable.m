load('train_partially_observable_alpha_list')
train_x0_list= repmat([3.9; 0; 0; 0],1,30); 

n_dagg_itern = 1;
[controller,data] = trainPartiallyObservableDAgger(train_x0_list,n_dagg_itern,train_alpha_list,train_obs_list);
save('./controllers/dagger_partially_observable_controller.mat','controller','train_alpha_list','train_x0_list','data');
