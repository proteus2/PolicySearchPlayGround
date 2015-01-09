train_alpha_list = [5,7,12,14,15,18,20,22,24];

N = size(train_alpha_list,1);
n_dagg_itern = 5;

tf=[1.8647,1.3321,0.7679,0.6568,0.6106,0.5068,0.4557,0.4139,0.3791];

load('official_init_train_traj'); 
tic
for idx=1:N
    alpha = train_alpha_list(idx);
    x0 = [3.9;0;0;0];
    p=PlanePlant(alpha);
    [controller,data] = trainDAgger(x0,tf(idx),p,traj_list,n_dagg_itern,alpha);
end
train_time = toc
save('vary_alpha_dagger_results','controller','data','train_alpha_list','train_time');
