
alpha_to_test = [11.3,12.3,14.5,16.3,18,10,9,8,7];
load('vary_alpha_mmd_results2.mat');
controller=c;
x0 = [3.9;0;0;0];
dt=0.001;

traj_cost_list = [];
ctrl_cost_list =[];
x_ctrller_list = cell(0,1);
x_traj_list = cell(0,1);

for alpha = alpha_to_test
    p=PlanePlant(alpha);
    varyAlpha = true;
    [x_ctrller,x_traj,traj_cost,ctrl_cost] = compareControllerAndTrajOpt(x0,controller,dt,p,varyAlpha);
end

save('vary_alpha_mmd_evaluation_results','alpha_list','traj_cost_list','ctrl_cost_list','x_ctrller_list','x_traj_list');
