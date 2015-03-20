n_dagg_itern = 1;

n_x0=10;
if ~exist('./train_alpha_list.mat','file')
    train_alpha_list = 5*x0_rand + (1-x0_rand)*30;
    save('train_alpha_list','train_alpha_list');
else
    load('train_alpha_list')
end


train_alpha_list=train_alpha_list(1:n_x0);
train_x0_list= repmat([3.9; 0; 0; 0],1,n_x0); 
[controller,data] = trainUnobservableDAgger(train_x0_list,n_dagg_itern,train_alpha_list);
save('./controllers/dagger_unobservable_controller.mat','controller','train_alpha_list','train_x0_list','data');
