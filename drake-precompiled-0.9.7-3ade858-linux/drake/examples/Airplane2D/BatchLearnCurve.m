% Compare controllers
clear all;
close all;

n_x0=50;
x0_rand = rand(1,n_x0);
x0_x = 2*x0_rand + (1-x0_rand)*4;
x0_rand = rand(1,n_x0);
x0_y = 0*x0_rand + (1-x0_rand)*1;

trainTest = false;

if ~exist('./test_alpha_list.mat','file')
    test_alpha_list = 5*x0_rand + (1-x0_rand)*30;
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
x0_list = test_x0_list;
alpha_list = test_alpha_list;

% train_file={'supervised_controller.mat','mmd_results_alpha_0.001_all_vals_norepmat.mat','dagg_results_alpha_0.001.mat'};
train_file = {'dagg_results_alpha_0.001.mat'};
n_controllers = size(train_file,2);
x0_alpha_list  = [x0_list; alpha_list];

max_n_data = 33;
for ctrl_idx=1:n_controllers
    load(train_file{ctrl_idx});
    
    cost_list_all_alpha={};
    traj_list_all_alpha={};
    traj_opt_list_all_alpha = {};
    
    switch class(controller)
        case 'MMDController'
            data_set = controller.data_sets_unnormalized;
            controller_name = 'MMDController';
        otherwise
            data_set = data;
            controller_name = 'TreeBagger';
    end
      
    ctrl_list = {};
    ctrl_train_idx=1;
    for trainIdx = 30:min(33,size(data_set,1))
        ctrl_list{ctrl_train_idx,1} = trainOnSelectedData(1:trainIdx,data_set,controller_name);
        ctrl_train_idx = ctrl_train_idx + 1;
    end

    for idx=1:10%size(x0_alpha_list,2)
            x0 = x0_alpha_list(1:4,idx);
            alpha = x0_alpha_list(5,idx);

            fprintf('Will be completing=%0.1f percent, Learning Curve\n', idx/size(x0_alpha_list,2) *100);
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
                if trainTest
                    optimal_u = utraj;
                    optimal_x = xtraj;
                end
                u{1,1} = optimal_u;
                tf=optimal_u.getBreaks; tf=tf(end);
                [traj_list_opt,traj_opt_cost]=EvaluateControllers(u,x0,tf,alpha);
                traj_opt_cost
    %             if ~trainTest
    %                 save(optimaltraj_fname,'optimal_u','optimal_x','alpha','traj_list_opt','traj_opt_cost');
    %             end
            end

            apprxtraj_fname = './data_for_plots/test/';
            fname = train_file;
                fname = strcat(fname,'_learning_curve');
            apprxtraj_fname = strcat(apprxtraj_fname,fname);

            apprxtraj_fname =strcat(apprxtraj_fname,sprintf('_alpha=%d,x0=[%0.2f,%0.2f,%0.2f,%0.2f]',alpha,x0(1),x0(2),x0(3),x0(4)),'.mat');

            tf = optimal_u.getBreaks; tf=tf(end);
            tf=tf+2;
            [traj_list,cost_list]=EvaluateControllers(ctrl_list,x0,tf,alpha);

            cost_list_all_alpha{idx,1} = traj_opt_cost;
            cost_list_all_alpha{idx,2} = cost_list(:,:);
            traj_list_all_alpha{idx,1} = traj_list;
            traj_opt_list_all_alpha{idx,1} = traj_list_opt;
    end
    save_file_ctrller_name = strcat('learn_curve_',train_file{ctrl_idx});
    save(save_file_ctrller_name,'cost_list_all_alpha','alpha_list','traj_list_all_alpha','test_x0_list','traj_opt_list_all_alpha');
end
