% Compare controllers
clear all;
close all;

n_x0=10;
x0_rand = rand(1,n_x0);
x0_x = 5*x0_rand + (1-x0_rand)*0;
x0_rand = rand(1,n_x0);
x0_y = 0*x0_rand + (1-x0_rand)*0;


if ~exist('./test_alpha_list.mat','file')
    test_alpha_list = 5*x0_rand + (1-x0_rand)*20;
    save('test_alpha_list','test_alpha_list');
else
    load('test_alpha_list')
end

if ~exist('./test_x0_list.mat','file')
    test_x0_list = [x0_x;x0_y;zeros(1,n_x0);zeros(1,n_x0)];
    test_x0_list = [test_x0_list];
    save('test_x0_list','test_x0_list');
else
    load('test_x0_list')
end


load('train_x0_list');
load('train_alpha_list');


%% Eval script
trainTest = false;
if trainTest 
    x0_list = train_x0_list;
    alpha_list = train_alpha_list;
else
    x0_list = test_x0_list;
    alpha_list = test_alpha_list;
end

trainOnSelection = false;
if trainOnSelection
    load('RF_seed');
    load('mmd_results_alpha_0.001_all_vals3.mat');
    trainIdx = [1:16,18:size(controller.data_sets_unnormalized,1)];
    % trainIdx=1:size(controller.data_sets_unnormalized,1);
    ctrl = MMDController(RF_seed);
    for idx=1:numel(trainIdx)
        tidx = trainIdx(idx);
        data_x = controller.data_sets_unnormalized{tidx,1};
        data_y = controller.data_sets_unnormalized{tidx,2};
        idx,data_y
        ctrl =setNewController(ctrl,data_x,data_y);
    end
    controller = ctrl;
    save('mmd_partial_data_ctrller.mat','controller','controller');
end
x0_alpha_list  = [x0_list; alpha_list];


for idx=1:size(x0_alpha_list,2)
% for idx=9;
        x0 = x0_alpha_list(1:4,idx);
        alpha = x0_alpha_list(5,idx);
        
    	fprintf('Will be completing=%0.1f percent\n', idx/size(x0_alpha_list,2) *100);
        if trainTest
            optimaltraj_fname = sprintf('./InitTraining/initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4));
        else
            optimaltraj_fname = sprintf('optimal_traj_with_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f].mat',alpha,x0(1),x0(2),x0(3),x0(4));
            optimaltraj_fname = strcat('./data_for_plots/test/',optimaltraj_fname);
        end
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
            if trainTest && ~exist('optimal_u','var')
                optimal_u = utraj;
                optimal_x = xtraj;
            end
            u{1,1} = optimal_u;

            tf=optimal_u.getBreaks; tf=tf(end);
            [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha);
            save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list_opt','traj_opt_cost');
        end

        train_files={'mmd_results_alpha_0.001_all_vals3.mat'};
        n_files = size(train_files,2);

        apprxtraj_fname = './data_for_plots/test/';
        for fidx=1:n_files
            fname = train_files{1,fidx};
            if idx == n_files
                apprxtraj_fname = strcat(apprxtraj_fname,fname);
            else
                apprxtraj_fname = strcat(apprxtraj_fname,fname,'_');
            end
        end
        apprxtraj_fname =strcat(apprxtraj_fname,sprintf('_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f]',alpha,x0(1),x0(2),x0(3),x0(4)),'.mat');

        if ~exist(apprxtraj_fname,'file')
            tf = optimal_u.getBreaks; tf=tf(end);
            ctrl_list = cell(n_files,1);
            for fidx = 1:n_files
                train_file = train_files{1,fidx};
                load(train_file,'controller');
                ctrl_list{fidx,1} = controller;
            end
            [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
            save(apprxtraj_fname,'traj_list','cost_list','alpha','ctrl_list')
        else
            load(apprxtraj_fname)
            tf = optimal_u.getBreaks; tf=tf(end);
            [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);
            save(apprxtraj_fname,'traj_list','cost_list','alpha','ctrl_list')
        end

        cost_list_all_alpha{idx,1} = traj_opt_cost;
        for fidx = 1:n_files
            cost_list_all_alpha{idx,fidx+1} = cost_list(fidx,:);
            traj_list_all_alpha{idx,fidx} = traj_list{fidx};
        end

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
%           visualizeTraj(traj_list{1,1},alpha);
%  visualizeTraj(traj_list{2,1},alpha);
%   visualizeTraj(traj_list{3,1},alpha);


    %       visualizeTraj(traj_list{4,1},alpha);

end

save('mmd_results_test_error.mat','cost_list_all_alpha','alpha_list','traj_list_all_alpha','test_x0_list');
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
