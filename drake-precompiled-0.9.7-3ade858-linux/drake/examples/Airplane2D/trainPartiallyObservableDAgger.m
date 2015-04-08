function [controller,data] = trainPartiallyObservableDAgger(x0_list,n_mmd_itern,alpha_list,train_obs_list)
    x0=x0_list(:,1);
    
        dt = 0.001;

    n_alpha = size(alpha_list,2);
    n_obs = size(train_obs_list,2);
    tf_list = zeros( n_obs, n_alpha );
    x=[];y=[];

    for obs_idx=1:size(train_obs_list,2)
        obs = train_obs_list(obs_idx);
        alpha_for_obs_val = alpha_list(obs_idx,:);
       % load('./InitTraining/partially_observable_initial_mmd_traj_alpha=1.356525e+01,1.387324e+01,1.424192e+01,x0=[3.900000e+00,0,0,0].mat');
        init_fname = sprintf( './InitTraining/partially_observable_initial_mmd_traj_obs_val=%d,x0=[%d,%d,%d,%d].mat',obs,x0(1),x0(2),x0(3),x0(4) )
        load(init_fname)
        
        for idx=1:numel(xtraj_list)
            xtraj = rungeKattaSimulation([3.9;0;0;0],utraj,0.001,1,PlanePlant(alpha_for_obs_val(idx)),false); 
            t = xtraj.getBreaks(); tf=t(end);
            tf_list(obs_idx,idx) = tf;
            t=0:tf/21:tf;
            [new_x,new_y] = turnTrajToData(xtraj,utraj,t,obs);
            x=[new_x(:,1) x]; y =[new_y(:,1) y];
        end
    end
    load('RF_seed')
    rng(RF_seed);
    controller = TreeBagger(50,x',y','Method','regression');


    fprintf('initial controller trained\n')

    
    % set parameters
    train_list = [x0_list; train_obs_list];
    data = {}
    for MMD_iteration = 1:n_mmd_itern
            x = []; y=[]; train_idx = 1;
            for idx=1:size(train_list,2)
                x0=train_list(1:4,idx);
                obs = train_list(5,idx);
                alpha_for_obs_val = alpha_list(idx,:);

                for alpha_idx = 1:1
                    alpha = alpha_list(idx,alpha_idx);
                    d_list =[];

                    tf = tf_list(idx);
                    N  = numel(0:dt:tf);

                    x1=zeros(4,N); x1(:,1) = x0; % state simulation
                    p = PlanePlant(alpha);

                    for k=1:N-1
                        current_state = [x1(:,k);obs];
                        dist_to_goal = norm(x1(1:2,k)-[5; 9]);
                        if dist_to_goal<=0.5
                            break
                        end

                        
                        xf = [5;9;0;0];
                        tic
                        plan_time = norm(xf(1:2)-current_state(1:2))/alpha;


                        traj_fname = sprintf( './IntermediateTrainData/partially_observable_intermediate_dagg_traj_obs_val=%d,x0=[%d,%d,%d,%d].mat',obs,...
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

%                                 if new_y(1) == 0
%                                     keyboard
%                                 end

                            x_to_attach=[new_x(:,1) x_to_attach]; y_to_attach =[new_y(:,1) y_to_attach];
                        end

                        data{k,1} = x_to_attach(:,1)';
                        data{k,2} = y_to_attach(:,1)';
                        x = [x; x_to_attach(:,1)'];
                        y = [y; y_to_attach(:,1)'];

                        control = controller.predict(current_state');

                        % advance the dynamics
                        xdot = p.dynamics(0,x1(:,k),control);
                        xnew = x1(:,k) + xdot*dt;
                        x1(:,k+1)=xnew;
                        fprintf('Completed=%0.1f percent of alpha value = %0.2d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
                    end
                    train_idx = train_idx + 1;
                end
            end  
            rng(RF_seed);
            controller = TreeBagger(50,x,y,'Method','regression');

    end   
end


