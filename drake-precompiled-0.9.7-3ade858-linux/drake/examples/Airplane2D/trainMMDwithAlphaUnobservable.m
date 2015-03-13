n_mmd_itern = 50;

n_x0=10;
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

% if ~exist('./train_x0_list.mat','file')
%     train_x0_list = [x0_x;x0_y;zeros(1,n_x0);zeros(1,n_x0)];
%     save('train_x0_list','train_x0_list');
% else
%     load('train_x0_list');
% end

train_alpha_list=train_alpha_list(1:n_x0);
train_x0_list= repmat([3.9; 0; 0; 0],1,n_x0); 
save('train_x0_list','train_x0_list');
aggregate=false;
[controller,data] = trainUnobservableMMD(train_x0_list,n_mmd_itern,train_alpha_list,aggregate);

save('mmd_unobservable_controller.mat','controller','data','train_alpha_list','train_x0_list');

% if aggregate
%     save('mmd_results_alpha_0.001_agg.mat','controller','data','train_alpha_list','train_x0_list');
% else
%     save('mmd_results_alpha_0.001_all_vals_norepmat.mat','controller','data','train_alpha_list','train_x0_list');
% end
% save('mmd_results_repmat=1,a=all,algo=RF,aggregation','controller','data','train_alpha_list');
% load('mmd_results_x0=2,4')
% ctrl_list{1,1}=controller;
% x0=[2;0;0;0]; tf = 2; alpha=5;
% [traj,cost] = EvaluateControllers(ctrl_list,x0,tf,alpha)
