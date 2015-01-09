alpha_to_test = [11.3,12.3,14.5,16.3,18,10,9,8,7];
load('vary_alpha_mmd_results_from_mac');
controller=c;
x0 = [3.9;0;0;0];
dt=0.001;

traj_cost_list = [];
ctrl_cost_list =[];
x_ctrller_list = cell(0,1);
x_traj_list = cell(0,1);
n=1
for alpha = alpha_to_test 
    alpha
    p=PlanePlant(alpha);
    varyAlpha = true;
    [x_ctrller,x_traj,traj_cost,ctrl_cost] = compareControllerAndTrajOpt(x0,controller,dt,p,varyAlpha);
    traj_cost_list = [traj_cost_list;traj_cost];
    ctrl_cost_list = [ctrl_cost_list;ctrl_cost];
    x_ctrller_list{n,1} = x_ctrller;
    x_traj_list{n,1} = x_traj;
    n=n+1;
end

save('vary_alpha_mmd_evaluation_results_with_data_from_mac','alpha_to_test','traj_cost_list','ctrl_cost_list','x_ctrller_list','x_traj_list');


load('vary_alpha_mmd_evaluation_results');

for idx = 1:size(x_traj_list,1)
    xtraj=x_traj_list{idx,1};
    tf = xtraj.getBreaks(); tf=tf(end);
    ts=0:0.01:tf;
    xtraj=xtraj.eval(ts);
    figure; scatter(xtraj(1,:),xtraj(2,:));
    xtraj=x_ctroller_list{idx,1};
    tf = xtraj.getBreaks(); tf=tf(end);
    ts=0:0.01:tf;
    xtraj=xtraj.eval(ts);
    hold on; scatter(xtraj(1,:),xtraj(2,:));
    title(sprintf('alpha = %0.1d',alpha_to_test(idx)));
    legend('trajopt','ctrller')
end 

load('vary_alpha_mmd_results.mat');
p=PlanePlant(21);
varyAlpha = true;
x0 = [3.9;0;0;0];
dt=0.001;
controller=c;
[x_ctrller,x_traj,traj_cost,ctrl_cost] = compareControllerAndTrajOpt(x0,controller,dt,p,varyAlpha);