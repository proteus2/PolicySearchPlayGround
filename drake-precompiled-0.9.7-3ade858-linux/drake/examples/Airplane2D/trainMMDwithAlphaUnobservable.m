n_mmd_itern = 50;

n_x0=10;
x0_rand = rand(1,n_x0);
if ~exist('./train_unobs_alpha_list.mat','file')
    train_alpha_list = 5*x0_rand + (1-x0_rand)*30;
    save('train_unobs_alpha_list','train_alpha_list');
else
    load('train_unobs_alpha_list')
end

train_alpha_list=train_alpha_list(1:n_x0);
train_x0_list= repmat([3.9; 0; 0; 0],1,n_x0); 
aggregate=false;
[controller,data] = trainUnobservableMMD(train_x0_list,n_mmd_itern,train_alpha_list,aggregate);
save('mmd_unobservable_controller2.mat','controller','data','train_alpha_list','train_x0_list');
