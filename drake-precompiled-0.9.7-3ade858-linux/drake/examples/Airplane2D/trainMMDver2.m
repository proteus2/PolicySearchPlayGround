function [controller,mmd_data] = trainMMDver2(x0,n_mmd_itern,alpha_list)
    controller = MMDController();
    dt = 0.01;    
    
    % for all alpha values, get initial trajectories
    ref_traj_list = cell(numel(alpha_list,2),1);
    tf_list = zeros(numel(alpha_list,2),1);
    
    for idx=1:numel(alpha_list)
        alpha = alpha_list(idx);
        init_fname = sprintf('initial_mmd_traj_alpha=%d.mat',alpha);
        if ~exist(init_fname,'file')
            [utraj,xtraj,~] = getTrajectory(x0,alpha,false);
            save(init_fname, 'xtraj','utraj');
        else
            load(init_fname);
            if exist('u_traj_from_curr_loc','var')
                xtraj = x_traj_from_curr_loc;
                utraj = u_traj_from_curr_loc;
            end
        end
        tf = xtraj.getBreaks(); tf=tf(end);
        tf_list(idx) = tf;
        t = xtraj.getBreaks();
        [x,y] = turnTrajToData(xtraj,utraj,t,alpha);
        controller = setNewController(controller,x,y);
        
        % get reference trajectory
        ref_traj_list{idx,1} = x(1:4,:); 
    end
    
    
    % set parameters
    beta = 0.86;
    for MMD_iteration = 1:n_mmd_itern
            x = []; y=[];     
            
            for alpha_idx=1:numel(alpha_list)
                d_list =[];
                alpha = alpha_list(alpha_idx);
                
                tf = tf_list(1);
                N  = numel(0:dt:tf);
                x1=zeros(4,N); x1(:,1) = x0; % state simulation
                p = PlanePlant(alpha);

                for k=1:N-1
                    current_state = [x1(:,k);alpha];
                    [d,min_idx] = checkDiscrepancy(controller,current_state); 
                    d_list=[d_list d];
                    
                    dist_to_goal = norm(x1(1:2,k)-[5; 9]);
                    if dist_to_goal<=0.4
                        break
                    end

                    % Check if the encountered state lies far from datasets
                    if d > beta
                        x = [x current_state];
                        % get the reference trajectory for this alpha value
                        %ref_traj = ref_traj_list{alpha_idx,1};
                        %[u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getRecoveryTrajectory(x1(:,k),alpha,false,ref_traj);

%                         [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getTrajectory(x1(:,k),alpha,false);
%                         %save(sprintf('traj%d',controller.n_mmd_itern),'x_traj_from_curr_loc','u_traj_from_curr_loc','F');
% 
%                         temp_tf = x_traj_from_curr_loc.getBreaks; temp_tf = temp_tf(end);
%                         t=0:0.01:temp_tf;
%                         [x_to_attach,y_to_attach] = turnTrajToData(x_traj_from_curr_loc,u_traj_from_curr_loc,t,alpha);
%                         
%                         %trim data points that are repeated
%                         x_to_attach = unique(x_to_attach','rows')';
%                         y_to_attach = unique(y_to_attach','rows')';
% 
%                         x = [x x_to_attach]; 
%                         y = [y y_to_attach];
%                         action_diff = abs(u_traj_from_curr_loc.eval(0) - controller.predict(current_state))
%                         controller = setNewController(controller,x_to_attach,y_to_attach);
%                         %control = controller.predict(current_state);
%                         control = u_traj_from_curr_loc.eval(0);
%                         action_diff = abs(u_traj_from_curr_loc.eval(0) - controller.predict(current_state)) 
                        
                    end
                        control = controller.predict(current_state);
                    
                    % advance the dynamics
                    xdot = p.dynamics(0,x1(:,k),control);
                    xnew = x1(:,k) + xdot*dt;
                    x1(:,k+1)=xnew;
                    fprintf('Completed=%0.1f percent of alpha value = %0.2d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
                end
            end
            
            for mistake_idx=1:size(x,2)
                mistake_idx
                [d,min_idx] = checkDiscrepancy(controller,x(:,mistake_idx)); 
                if d > beta
                    [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getTrajectory(x(1:4,mistake_idx),alpha,false);
                    t=x_traj_from_curr_loc.getBreaks();
                    [x_to_attach,y_to_attach] = turnTrajToData(x_traj_from_curr_loc,u_traj_from_curr_loc,t,alpha);
                    controller = setNewController(controller,x_to_attach,y_to_attach);                    
                end
            end
                
            if isempty(x)
                break
            end
    end   
    mmd_data = controller.data_sets_unnormalized;    
end

