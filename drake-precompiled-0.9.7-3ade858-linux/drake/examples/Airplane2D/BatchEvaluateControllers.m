% Compare controllers
clear all;
close all;
x0 = [2;0.7;0;0];
rand_list = rand(1,100);
alpha_list = rand_list*30 + (1-rand_list)*4;

load('cost_list_all_alpha_a=[4,30]_repmat=1','alpha_list');
temp=alpha_list;
load('cost_list_all_alpha_a=[3,10]_repmat=1','alpha_list');
alpha_list = [alpha_list temp];
cost_list_all_alpha = {};


n_x0=10;
x0_rand = rand(1,n_x0);
x0_x = 5*x0_rand + (1-x0_rand)*2;
x0_rand = rand(1,n_x0);
x0_y = 0*x0_rand + (1-x0_rand)*1;

if ~exist('./test_alpha_list.mat','file')
    test_alpha_list = 5*x0_rand + (1-x0_rand)*20;
    save('test_alpha_list','test_alpha_list');
else
    load('test_alpha_list')
end

if ~exist('./test_x0_list.mat','file')
    test_x0_list = [x0_x;x0_y;zeros(1,n_x0);zeros(1,n_x0)];
    test_x0_list = [test_x0_list [4;0;0;0]];
    save('test_x0_list','test_x0_list');
else
    load('test_x0_list')
end

alpha_list = test_alpha_list;

%% Eval script
    alpha_idx =    1;
for x0_idx=1:size(test_x0_list,2)
    x0 = test_x0_list(:,x0_idx);

    for alpha = alpha_list
        optimaltraj_fname = sprintf('optimal_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
        optimaltraj_fname = strcat('./data_for_plots/test/',optimaltraj_fname);
        if exist(optimaltraj_fname,'file')
            getOptimalTraj = false;
        else
            getOptimalTraj = true;
        end

        if getOptimalTraj 
            [optimal_u,optimal_x] = getTrajectory(x0,alpha,false);         
            u{1,1} = optimal_u;
            tf=optimal_u.getBreaks; tf=tf(end);
            [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha);
            save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list_opt','traj_opt_cost');
        else
            load(optimaltraj_fname);
            u{1,1} = optimal_u;
            tf=optimal_u.getBreaks; tf=tf(end);
            [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha);
            save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list_opt','traj_opt_cost');
        end

        train_files={'mmd_results_init_at_alpha_R>0_agg'};
        n_files = size(train_files,2);

        apprxtraj_fname = './data_for_plots/test/';
        for idx=1:n_files
            fname = train_files{1,idx};
            if idx == n_files
                apprxtraj_fname = strcat(apprxtraj_fname,fname);
            else
                apprxtraj_fname = strcat(apprxtraj_fname,fname,'_');
            end
        end

        if ~exist(apprxtraj_fname,'file')
            tf = optimal_u.getBreaks; tf=tf(end);
            ctrl_list = cell(n_files,1);
            for fidx = 1:n_files
                train_file = train_files{1,fidx};
                load(train_file);
                ctrl_list{fidx,1} = controller;
            end
            [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
            save(apprxtraj_fname,'traj_list','cost_list','alpha','ctrl_list')
        else
            load(apprxtraj_fname)
            tf = optimal_u.getBreaks; tf=tf(end)+0.01;
            [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
            save(apprxtraj_fname,'traj_list','cost_list','alpha','ctrl_list')
        end

        cost_list_all_alpha{alpha_idx,1} = traj_opt_cost;
        for fidx = 1:n_files
            cost_list_all_alpha{alpha_idx,fidx+1} = cost_list(fidx,:);
            traj_list_all_alpha{alpha_idx,fidx} = traj_list{fidx};
        end

        alpha_idx = alpha_idx+1;
    %     
    %      x1 = traj_list{1,1}.eval(traj_list{1,1}.getBreaks);
    %      x2 = traj_list{2,1}.eval(traj_list{1,1}.getBreaks);
    %      optx = optimal_x.eval(optimal_x.getBreaks);
    %      
    %      figure; scatter(x1(1,:),x1(2,:),'r');
    %      hold on; scatter(x2(1,:),x2(2,:),'blue');
    %      hold on; scatter(optx(1,:),optx(2,:),'black');
    %      legend('mmd','sup','opt','Location','southwest');
    % 
    %      figure;bar(-[cost_list(1,1),cost_list(2,1),traj_opt_cost(1,1)])
    %      ax = gca;
    %      ax.XTickLabel = {'mmd','supervised','trajopt'};
    %      ylabel('Accumulated Rewards')
    %      xlabel('Algorithms')
    %      
    %      figure;bar(-[cost_list(1,2),cost_list(2,2),traj_opt_cost(1,2)])
    %      ax = gca;
    %      ax.XTickLabel = {'mmd','supervised','trajopt'};
    %      ylabel('Average Rewards')
    %      xlabel('Algorithms')
           %visualizeTraj(optimal_x,alpha);
           %visualizeTraj(traj_list{1,1},alpha);
          %visualizeTraj(traj_list{2,1},alpha);
    %      visualizeTraj(traj_list{3,1},alpha);

    %       visualizeTraj(traj_list{4,1},alpha);


    end
end
keyboard;
save('cost_list_all_alpha_a=[3,30]_all_algo_if_cost_fun__','cost_list_all_alpha','alpha_list','traj_list_all_alpha');
% 
% traj_opt_cost = zeros(size(cost_list_all_alpha,1),2);
% 
% ctrl1_cost = zeros(size(cost_list_all_alpha,1),2);
% ctrl2_cost = zeros(size(cost_list_all_alpha,1),2);
% 
% for idx = 1:size(cost_list_all_alpha,1)
%     traj_opt_cost(idx,1) = cost_list_all_alpha{idx,1}(1);
%     traj_opt_cost(idx,2) = cost_list_all_alpha{idx,1}(2);
%     
%     ctrl1_cost(idx,1) = cost_list_all_alpha{idx,2}(1);
%     ctrl1_cost(idx,2) = cost_list_all_alpha{idx,2}(2);
%     
%     ctrl2_cost(idx,1) = cost_list_all_alpha{idx,3}(1);
%     ctrl2_cost(idx,2) = cost_list_all_alpha{idx,3}(2);
% end
% 
% topt_mean = mean(traj_opt_cost);
% topt_std = std(traj_opt_cost);
% 
% c1_mean = mean(ctrl1_cost);
% c1_std = std(ctrl1_cost);
% c2_mean = mean(ctrl2_cost);
% c2_std = std(ctrl2_cost);
% 
% abs(c1_mean-topt_mean)
% abs(c1_mean-c2_mean)
