train_alpha_list = [5,7,12,14,15,18,20,22,24];

N = size(train_alpha_list,2);
n_mmd_itern = 5;
tf=[0.7679,0.6568,1.3321,0.6106,1.8647,0.5068,0.4557,0.4139,0.3791];
%tf=[1.8647,1.3321,0.7679,0.6568,0.6106,0.5068,0.4557,0.4139,0.3791];

tf = 1.8647;
load('official_init_train_traj');  
init_traj_train_data = traj_list;
tic
for idx=1:N
    alpha = train_alpha_list(idx);
    x0 = [3.9;0;0;0];
    p=PlanePlant(alpha);
    if idx==1
    	[controller,data] = trainMMD(x0,tf(idx),p,init_traj_train_data,n_mmd_itern,alpha);
    else
    	[controller,data] = trainMMD(x0,tf(idx),p,init_traj_train_data,n_mmd_itern,alpha,controller);
    end
    save('vary_alpha_mmd_results_allalpha','controller','data','train_alpha_list');
end
train_time = toc
save('vary_alpha_mmd_results_allalpha','controller','data','train_alpha_list','train_time');
