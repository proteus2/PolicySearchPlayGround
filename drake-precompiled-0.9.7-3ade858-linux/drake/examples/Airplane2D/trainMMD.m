function [controller,mmd_data] = trainMMD(x0,tf,p,init_traj_train_data,n_mmd_itern,alpha,controller)
    if exist('alpha','var')
        x = init_traj_train_data{1,1}; 
        alpha_to_attach = ones(1,size(x,2))*10;
        x = [x;alpha_to_attach];
    end
    y = init_traj_train_data{1,2};

    % set initial training data and train it
    if ~exist('controller','var')
    	controller = MMDController();
	controller = setNewController(controller,x,y);
    end
    % set parameters
    dt=0.01; t=0:dt:tf; N = size(t,2);
    beta = 0.3300;
    gamma = 0.5;
    d_list =[];
    for MMD_iteration = 2:n_mmd_itern
        x1=zeros(4,N); x1(:,1) = x0; % state simulation
        x = []; y=[];                % data to be fed to MMD

        for k=1:N-1
            current_state = [x1(:,k);alpha];
            [d,min_idx] = checkDiscrepancy(controller,current_state); 
            d_list=[d_list d];
            % Check if the encountered state lies far from datasets
            if d > beta
                [u_traj_from_curr_loc,x_traj_from_curr_loc,~] = getTrajectory(x1(:,k),alpha);
                action_diff = u_traj_from_curr_loc.eval(0) - controller.predict(current_state,min_idx);
                if norm(action_diff,1) > gamma
                    control = u_traj_from_curr_loc.eval(0);
                    temp_tf = x_traj_from_curr_loc.getBreaks;temp_tf = temp_tf(end);
                    t=x_traj_from_curr_loc.getBreaks;

                    x_to_attach = x_traj_from_curr_loc.eval(t);
                    alpha_to_attach = ones(1,size(t,2))*alpha; 
                    x_to_attach = [x_to_attach; alpha_to_attach];
                    x = [x x_to_attach]; 
                    y = [y u_traj_from_curr_loc.eval(t)];
                    controller = setNewController(controller,x,y);
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
%         else
%             controller = setNewController(controller,x,y);
        end
    end
        
    mmd_data = controller.data_sets_unnormalized;    
end

