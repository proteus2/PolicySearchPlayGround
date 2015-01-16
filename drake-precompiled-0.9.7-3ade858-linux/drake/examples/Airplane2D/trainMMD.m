function [controller,mmd_data] = trainMMD(x0,tf,p,init_traj_train_data,n_mmd_itern,alpha)
%     if exist('alpha','var')
%         x = init_traj_train_data{1,1}; 
%         alpha_to_attach = ones(1,size(x,2))*10;
%         x = [x;alpha_to_attach];
%     end
%     y = init_traj_train_data{1,2};
% 
%     % set initial training data and train it
%     if ~exist('controller','var')
%     	controller = MMDController();
% 	controller = setNewController(controller,x,y);
%     end
    
    init_fname = sprintf('initial_mmd_traj_alpha=%d.mat',alpha);
    if ~exist(init_fname,'file')
        controller = MMDController();
        [u_traj_from_curr_loc,x_traj_from_curr_loc,~] = getTrajectory(x0,alpha,false);
                t=0:0.001:tf;

        x_to_attach = x_traj_from_curr_loc.eval(t);
        alpha_to_attach = ones(1,size(t,2))*alpha; 
        x = [x_to_attach; alpha_to_attach];
        y = [u_traj_from_curr_loc.eval(t)];
        controller = setNewController(controller,x,y);
        save(init_fname, 'x_traj_from_curr_loc','u_traj_from_curr_loc','x','y');
    else
        load(init_fname);
        controller = MMDController();
        t=0:0.01:tf;
        x_to_attach = x_traj_from_curr_loc.eval(t);
        alpha_to_attach = ones(1,size(t,2))*alpha; 
        x = [x_to_attach; alpha_to_attach];
        y = [u_traj_from_curr_loc.eval(t)];
        controller = setNewController(controller,x,y);
    end
    
                    
    % set parameters
    dt=0.01; t=0:dt:tf; N = size(t,2);
    beta = 0.9891;0.96;500;0.85;500;0.78;0.7883;  0.729774137364830;%0.3300;
    gamma = 0;%3; %we want this because we only want to sample from where the controller makes mistakes
    d_list =[];
    for MMD_iteration = 2:n_mmd_itern
        x1=zeros(4,N); x1(:,1) = x0; % state simulation
        x = []; y=[];                % data to be fed to MMD

        for k=1:N-1
            current_state = [x1(:,k);alpha];
            [d,min_idx] = checkDiscrepancy(controller,current_state); 
            d_list=[d_list d];
            d,min_idx
            dist_to_goal = norm(x1(1:2,k)-[5; 9]);
            if dist_to_goal<=0.2494
                % got to the goal
                break
            end

            % Check if the encountered state lies far from datasets
            if d > beta
                d,x1(:,k)
                ref_traj = controller.data_sets_unnormalized{1,1}; ref_traj = ref_traj(1:4,:);
                
                [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getRecoveryTrajectory(x1(:,k),alpha,false,ref_traj);
                save(sprintf('traj%d',controller.n_mmd_itern),'x_traj_from_curr_loc','u_traj_from_curr_loc','F');
                action_diff = u_traj_from_curr_loc.eval(0) - controller.predict(current_state,min_idx); 
                action_diff
                if norm(action_diff,1) > gamma
                    %control = u_traj_from_curr_loc.eval(0);
                    
                    temp_tf = x_traj_from_curr_loc.getBreaks;temp_tf = temp_tf(end);
                    t=x_traj_from_curr_loc.getBreaks;
                    t=0:0.01:tf;
                    x_to_attach = x_traj_from_curr_loc.eval(t);
                    alpha_to_attach = ones(1,size(t,2))*alpha; 
                    x_to_attach = [x_to_attach; alpha_to_attach];
                    
                    %trim data points that are repeated
                    x_to_attach = unique(x_to_attach','rows')';
                    y_to_attach = u_traj_from_curr_loc.eval(t);
                    y_to_attach = unique(y_to_attach','rows')';
%                     dist_to_goal=sum(bsxfun(@minus,[5;9],x_to_attach(1:2,:)).^2);
%                     x_to_attach(:,dist_to_goal<=0+eps) = [];
%                     y_to_attach = u_traj_from_curr_loc.eval(t);
%                     y_to_attach(:,dist_to_goal<=0+eps) = [];
                    
                    x = [x x_to_attach]; 
                    y = [y y_to_attach];
                    controller = setNewController(controller,x_to_attach,y_to_attach);
                    control = controller.predict(current_state);
                else
                    control = controller.predict(current_state);
                end
            else
                control = controller.predict(current_state,min_idx);
            end
            xdot = p.dynamics(0,x1(:,k),control);
            xnew = x1(:,k) + xdot*dt;
            x1(:,k+1)=xnew;
            fprintf('Completed=%0.1f percent of alpha value = %0.2d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
        end

        if isempty(y)
            break
%          else
%             controller = setNewController(controller,x,y);
        end
    end
        
    mmd_data = controller.data_sets_unnormalized;    
end

