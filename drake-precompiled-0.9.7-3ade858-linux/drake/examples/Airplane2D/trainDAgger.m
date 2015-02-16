function [controller,mmd_data] = trainDAgger(x0_list,n_mmd_itern,alpha_list)
    dt = 0.001;    
    
    % for all alpha values, get initial trajectories
    ref_traj_list = cell(numel(alpha_list,2),1);
    tf_list = zeros(numel(alpha_list,2)+size(x0_list,2),1);

    
    train_list = [x0_list;alpha_list];
    x_list=[];
    y_list=[];
    for idx=1:size(train_list,2)
        if idx ==26
            continue
        end
           alpha = train_list(5,idx);
            x0=train_list(1:4,idx);
             init_fname = sprintf('./InitTraining/initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4))
            if ~exist(init_fname,'file')
                [utraj,xtraj,traj_list] = getTrajectory(x0,alpha,false);
                save(init_fname, 'xtraj','utraj');
            else
                load(init_fname);
                if exist('u_traj_from_curr_loc','var') && ~exist('utraj','var');
                    xtraj = x_traj_from_curr_loc;
                    utraj = u_traj_from_curr_loc;
                elseif exist('optimal_x','var')
                    xtraj = optimal_x;
                    utraj = optimal_u;
                end
            end
            tf = xtraj.getBreaks(); tf=tf(end);
            tf_list(idx) = tf;
            %idx
            %visualizeTraj(xtraj,alpha);
                t = xtraj.getBreaks();
                [x,y] = turnTrajToData(xtraj,utraj,t,alpha);
                x_list=[x_list;x'];
                y_list=[y_list;y'];
    end
      
    load('RF_seed');
    controller = TreeBagger(50,x_list,y_list,'Method','regression');
    
    % set parameters
    %beta = 0.90; gamma = 1;
    for MMD_iteration = 1:n_mmd_itern
            x = []; y=[]; train_idx = 1;
            for idx=1:size(train_list,2)
               alpha = train_list(5,idx);
                x0=train_list(1:4,idx);
                    
                    d_list =[];

                    tf = tf_list(idx);
                    N  = numel(0:dt:tf);
                   
                    x1=zeros(4,N); x1(:,1) = x0; % state simulation
                    p = PlanePlant(alpha);

                    for k=1:N-1
                        current_state = [x1(:,k);alpha];
                        dist_to_goal = norm(x1(1:2,k)-[5; 9]);
                        if dist_to_goal<=0.5
                            break
                        end
                        
                        
                        if mod(k,50) == 0
                            plan_time = norm(xf(1:2)-current_state(1:2))/alpha;
                            [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getTrajectory(x1(:,k),alpha,false,[5;9;0;0],plan_time);
                            t = x_traj_from_curr_loc.getBreaks();
                            [x_to_attach,y_to_attach] = turnTrajToData(x_traj_from_curr_loc,u_traj_from_curr_loc,t,alpha);

                            while y_to_attach(1) == 0
                                plan_time = norm(xf(1:2)-current_state(1:2))/alpha+rand(1,1)*2;
                                [u_traj_from_curr_loc,x_traj_from_curr_loc,F] = getTrajectory(x1(:,k),alpha,false,[5;9;0;0],plan_time);
                                 t = x_traj_from_curr_loc.getBreaks();
                                 [x_to_attach,y_to_attach] = turnTrajToData(x_traj_from_curr_loc,u_traj_from_curr_loc,t,alpha);
                            end
                            x = [x x_to_attach'];
                            y = [y y_to_attach'];
                        end
                        
                        control = controller.predict(current_state);
                        
                        % advance the dynamics
                        xdot = p.dynamics(0,x1(:,k),control);
                        xnew = x1(:,k) + xdot*dt;
                        x1(:,k+1)=xnew;
                        fprintf('Completed=%0.1f percent of alpha value = %0.2d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
                    end
                    train_idx = train_idx + 1;
            end  
            controller = TreeBagger(50,x,y,'Method','regression');

    end   
    mmd_data = controller.data_sets_unnormalized;    
end


