fname = 'cost_list_all_alpha_a=[4,30]_repmat=10';
load(fname);

temp1 = alpha_list;
temp2 = cost_list_all_alpha;

fname2 = 'cost_list_all_alpha_a=[3,10]_repmat=10';
load(fname2);

alpha_list = [alpha_list temp1];
cost_list_all_alpha = [cost_list_all_alpha;temp2];

traj_opt_cost = zeros(size(cost_list_all_alpha,1),2);

ctrl1_cost = zeros(size(cost_list_all_alpha,1),2);
ctrl2_cost = zeros(size(cost_list_all_alpha,1),2);

for idx = 1:size(cost_list_all_alpha,1)
    traj_opt_cost(idx,1) = cost_list_all_alpha{idx,1}(1);
    traj_opt_cost(idx,2) = cost_list_all_alpha{idx,1}(2);
    
    ctrl1_cost(idx,1) = cost_list_all_alpha{idx,2}(1);
    ctrl1_cost(idx,2) = cost_list_all_alpha{idx,2}(2);
    
    ctrl2_cost(idx,1) = cost_list_all_alpha{idx,3}(1);
    ctrl2_cost(idx,2) = cost_list_all_alpha{idx,3}(2);
end
traj_opt_cost = (traj_opt_cost);
ctrl1_cost = (ctrl1_cost);
ctrl2_cost = (ctrl2_cost);

topt_mean = mean(traj_opt_cost);
topt_std = std(traj_opt_cost);

c1_mean = mean(ctrl1_cost);
c1_std = std(ctrl1_cost);
c2_mean = mean(ctrl2_cost);
c2_std = std(ctrl2_cost);

% 95% confidence interval
n=numel(alpha_list);
c1_CI = 1.96*c1_std/sqrt(n);
c2_CI = 1.96*c2_std/sqrt(n);
topt_CI = 1.96*topt_std/sqrt(n);

figure;bar(-[c1_mean(1,1),c2_mean(1,1),topt_mean(1,1)]) 
hold on; errorbar([-c1_mean(1,1),-c2_mean(1,1),-topt_mean(1,1)],[c1_CI(1),c2_CI(1),topt_CI(1)],'o');

 ax = gca;
 ax.XTickLabel = {'mmd','supervised','trajopt'};
 ylabel('Accumulated Rewards')
 xlabel('Algorithms')
     
     