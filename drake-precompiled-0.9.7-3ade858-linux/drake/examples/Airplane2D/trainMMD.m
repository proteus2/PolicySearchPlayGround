function [controller,mmd_data] = trainMMD(x0_list,n_mmd_itern,alpha_list,aggregate)
    load('RF_seed');
    if aggregate
        controller = MMDAggregateController(RF_seed);
    else
        controller = MMDController(RF_seed);
    end
    dt = 0.001;    
    
    % for all alpha values, get initial trajectories
    ref_traj_list = cell(numel(alpha_list,2),1);
    tf_list = zeros(numel(alpha_list,2)+size(x0_list,2),1);

    
    train_list = [x0_list;alpha_list];

    train_idx = 1;
  %  for x0_idx=1:size(x0_list,2)
  %     for idx=1:numel(alpha_list)
    for idx=1:size(train_list,2)
           alpha = train_list(5,idx);
            x0=train_list(1:4,x0_idx);
             init_fname = sprintf('./InitTraining/initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4))
            if ~exist(init_fname,'file')
                [utraj,xtraj,~] = getTrajectory(x0,alpha,true);
                save(init_fname, 'xtraj','utraj');
            else
                load(init_fname);
                if exist('u_traj_from_curr_loc','var') && ~exist('utraj','var');
                    xtraj = x_traj_from_curr_loc;
                    utraj = u_traj_from_curr_loc;
                end
            end
            
            tf = xtraj.getBreaks(); tf=tf(end);
            tf_list(train_idx) = tf;
%            if train_idx == 1
                t = xtraj.getBreaks();
                [x,y] = turnTrajToData(xtraj,utraj,t,alpha);
                controller = setNewController(controller,x,y);
%            end
%             ref_traj_list{x0_idx,1} = x(1:4,:); 
            train_idx = train_idx + 1;
        end
%      
    % set parameters
    %beta = 0.90; gamma = 1;
    for MMD_iteration = 1:n_mmd_itern
            x = []; y=[]; train_idx = 1;
    	for idx=1:size(train_list,2)
           alpha = train_list(5,idx);
            x0=train_list(1:4,x0_idx);
                    
                    d_list =[];

                    tf = tf_list(train_idx);
                    N  = numel(0:dt:tf);
                   
                    x1=zeros(4,N); x1(:,1) = x0; % state simulation
                    p = PlanePlant(alpha);

                    for k=1:N-1
                        current_state = [x1(:,k);alpha];
                        [d,min_idx,emptyCandidates] = checkDiscrepancy(controller,current_state); 
                        d_list=[d_list d];

                        dist_to_goal = norm(x1(1:2,k)-[5; 9]);
                        if dist_to_goal<=0.5
                            break
                        end

                        % Check if the encountered state lies far from datasets
                         if emptyCandidates && (norm(x1(1:2,k)-[5;9])>1.5)
%                         if d > controller.max_d && (norm(x1(1:2,k)-[5;9])>1.5)
                            d,current_state
                            x = [x current_state];
                           [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getTrajectory(x1(:,k),alpha,false);
                             t = x_traj_from_curr_loc.getBreaks();
                             [x_to_attach,y_to_attach] = turnTrajToData(x_traj_from_curr_loc,u_traj_from_curr_loc,t,alpha);
                              controller = setNewController(controller,x_to_attach,y_to_attach);    
                              control = controller.predict(current_state);
                        else
                            control = controller.predict(current_state,min_idx);
                        end

                        % advance the dynamics
                        xdot = p.dynamics(0,x1(:,k),control);
                        xnew = x1(:,k) + xdot*dt;
                        x1(:,k+1)=xnew;
%                         fprintf('Completed=%0.1f percent of alpha value = %0.2d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
                    end
                    train_idx = train_idx + 1;
            end   
            if isempty(x)
                break
            else 
%                 for mistake_idx=1:size(x,2)
%                     (mistake_idx/size(x,2))*100
%                     [min_d,min_idx,emptyCandidates] = checkDiscrepancy(controller,x(:,mistake_idx)); 
%                     if emptyCandidates
%                         
%                         %TODO: Fix the ref traj to accommodate changes in
%                         %alpha later
%                         [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getTrajectory(x(1:4,mistake_idx),alpha,false);
% 
% %                         [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getRecoveryTrajectory(x(1:4,mistake_idx),alpha,false,ref_traj);
%                         t=x_traj_from_curr_loc.getBreaks();
%                         [x_to_attach,y_to_attach] = turnTrajToData(x_traj_from_curr_loc,u_traj_from_curr_loc,t,alpha);
%                         controller = setNewController(controller,x_to_attach,y_to_attach);                    
%                     end
%                 end
%                 controller = setNewController(controller,x,y);
            end
    end   
    mmd_data = controller.data_sets_unnormalized;    
end


