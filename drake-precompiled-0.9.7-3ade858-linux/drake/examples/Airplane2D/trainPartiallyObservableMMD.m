function [controller,mmd_data] = trainPartiallyObservableMMD(x0_list,n_mmd_itern,alpha_list,train_obs_list,aggregate)
    %% getting initial set of trajectories
    % for observations o_1...o_m,
        % sample alpha_1,...,alpha_n from P(alpha|o)
        % tau^{o_i} = getRobustTrajectory(x0_list(:,1),alpha_list,false)
    
    load('RF_seed');
    if aggregate
        controller = MMDAggregateController(RF_seed);
    else
        controller = MMDController(RF_seed);
    end
    dt = 0.001;
    x0=x0_list(:,1);
    
    ntrajs=0;
    successes=0;
    n_alpha = size(alpha_list,2);
    n_obs = size(train_obs_list,2);
    tf_list = zeros( n_obs, n_alpha );
    for obs_idx=1:5%size(train_obs_list,2)
        obs = train_obs_list(obs_idx);
        alpha_for_obs_val = alpha_list(obs_idx,:);
        init_fname = sprintf( './InitTraining/partially_observable_initial_mmd_traj_obs_val=%d,x0=[%d,%d,%d,%d].mat',obs,x0(1),x0(2),x0(3),x0(4) )
        if ~exist(init_fname,'file')              
            [utraj,xtraj_list,traj_list,F]=getRobustTrajectory(x0_list(:,1),alpha_for_obs_val,false);
            save(init_fname, 'xtraj_list','utraj');
        else
            load(init_fname)
        end       
        for idx=1:numel(alpha_for_obs_val)
            xtraj = rungeKattaSimulation([3.9;0;0;0],utraj,0.001,1,PlanePlant(alpha_for_obs_val(idx)),false); 
            successes = successes+ checkSuccess(xtraj);
   
            ntrajs = ntrajs+1;
        end

        x=[];y=[];
        for idx=1:numel(alpha_for_obs_val)
            xtraj = rungeKattaSimulation([3.9;0;0;0],utraj,0.001,1,PlanePlant(alpha_for_obs_val(idx)),false); 
            t = xtraj.getBreaks(); tf=t(end);
            tf_list(obs_idx,idx) = tf;
            t=0:tf/21:tf;
            [new_x,new_y] = turnTrajToData(xtraj,utraj,t,obs);
            x=[new_x x]; y =[new_y y];
        end

        controller = setNewController(controller,x,y);
    end
     save('rmv_me_testing_init_mmd_data','tf_list','controller');
%    load('rmv_me_testing_init_mmd_data');
    
    
    
    %% Learning
    train_list = [x0_list;train_obs_list];
    executedCtrls =[];
    for MMD_iteration = 1:n_mmd_itern
            % allow n_mmd_itern times to train
            x = []; y=[]; 
            
            for obs_idx=1:5%size(train_obs_list,2)
                    % for all the observation values,
                    
                    x0=train_list(1:4,obs_idx);
                    obs = train_list(5,obs_idx);
                    alpha_for_obs_val = alpha_list(obs_idx,:); % gets all sampeld alpha values for this observation

                    for alpha_idx = 1:numel(alpha_for_obs_val)% - train only on the first alpha value
                        % train on the sampled alpha values
                        tf = tf_list(obs_idx,alpha_idx);
                        alpha = alpha_list(obs_idx,alpha_idx);
                            
                        N  = numel(0:dt:tf);
                        x1=zeros(4,N); x1(:,1) = x0; % state simulation
                        p = PlanePlant(alpha);
                        for k=1:N-1
                            current_state = [x1(:,k);obs];
                            [d,min_idx,emptyCandidates,candidates,d_return] = checkDiscrepancy(controller,current_state); 
                            min_idx
                            executedCtrls=[executedCtrls min_idx];
                            dist_to_goal = norm(x1(1:2,k)-[5; 9]);
                            if dist_to_goal<=0.7
                                break
                            end

                            % Check if the encountered state lies far from datasets
                             if (emptyCandidates) && (norm(x1(1:2,k)-[5;9])>1.5)
                                d,current_state,d_return
                                x = [x; current_state];
                                xf = [5;9;0;0];
                                plan_time = norm(xf(1:2)-current_state(1:2))/alpha;
                                traj_fname = sprintf( './IntermediateTrainData/partially_observable_intermediate_mmd_traj_obs_val=%d,x0=[%d,%d,%d,%d].mat',obs,...
                                                        current_state(1),current_state(2),current_state(3),current_state(4) )
                                if ~exist(traj_fname,'file')              
                                    [utraj,xtraj_list,F] = getRobustTrajectory(x1(:,k),alpha_for_obs_val,false,[5;9;0;0],plan_time);
                                    save(traj_fname, 'xtraj_list','utraj');
                                else
                                    load(traj_fname)
                                end       
                                x_to_attach=[]; y_to_attach=[];
                                for xtraj_idx=1:numel(xtraj_list)
                                    xtraj = rungeKattaSimulation(current_state,utraj,0.001,1,p,true,obs); 
                                    t = xtraj.getBreaks();
                                    tf=t(end);
                                    [new_x,new_y] = turnTrajToData(xtraj,utraj,t,obs);

%                                     if new_y(1) == 0
%                                         keyboard
%                                     end

                                    x_to_attach=[new_x x_to_attach]; y_to_attach =[new_y y_to_attach];
                                end

                                controller = setNewController(controller,x_to_attach,y_to_attach);    
                                control = controller.predict(current_state);
                            else
                                control = controller.predict(current_state,min_idx);
                             end
                            y = [y control];
                            % advance the dynamics
                            xdot = p.dynamics(0,x1(:,k),control);
                            xnew = x1(:,k) + xdot*dt;
                            x1(:,k+1)=xnew;
                            fprintf('Completed=%0.1f percent of alpha value = %0.2d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
                        end
                    end
            end   
            
            if isempty(x)
                break
            end
    end   
    mmd_data = controller.data_sets_unnormalized;    
end


