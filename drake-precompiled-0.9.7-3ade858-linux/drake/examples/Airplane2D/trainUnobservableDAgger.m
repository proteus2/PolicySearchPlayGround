function [controller,data] = trainDAgger(x0_list,n_mmd_itern,alpha_list)
    
    % for all alpha values, get initial trajectories
    train_list = [x0_list;alpha_list];
    dt = 0.001;    
    x0=x0_list(:,1);
    init_fname = sprintf( './InitTraining/unobservable_initial_mmd_traj_alpha=%d,%d,%d,x0=[%d,%d,%d,%d].mat',alpha_list(1),alpha_list(2),alpha_list(3),x0(1),x0(2),x0(3),x0(4) )

    if ~exist(init_fname,'file')              
        [utraj,xtraj_list,traj_list,F]=getRobustTrajectory(x0_list(:,1),alpha_list,false);
        save(init_fname, 'xtraj_list','utraj');
    else
        load(init_fname)
    end

    x=[];y=[];
    tf_list = zeros(1,10);
    for idx=1:numel(xtraj_list)
        xtraj = rungeKattaSimulation([3.9;0;0;0],utraj,0.001,1,PlanePlant(alpha_list(idx)),false); %xtraj_list{idx,1};
        t = xtraj.getBreaks(); tf=t(end);
        tf_list(idx) = tf;
        t=0:tf/21:tf;
        [new_x,new_y] = turnTrajToData(xtraj,utraj,t);
        x=[new_x x]; y =[new_y y];
    end
    load('RF_seed');
    rng(RF_seed);
    controller = TreeBagger(50,x',y','Method','regression');
    
    
    % set parameters
    %beta = 0.90; gamma = 1;
    data = {}
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
                    current_state = [x1(:,k)];
                    dist_to_goal = norm(x1(1:2,k)-[5; 9]);
                    if dist_to_goal<=0.5
                        break
                    end

                    xf = [5;9;0;0];
                    if mod(k,100) == 0
                        tic
                        plan_time = norm(xf(1:2)-current_state(1:2))/alpha;
                        
                        
                        [utraj,xtraj_list,F] = getRobustTrajectory(x1(:,k),alpha_list,false,[5;9;0;0],plan_time);
                        t = xtraj.getBreaks();

                        x_to_attach=[]; y_to_attach=[];
                        for xtraj_idx=1:numel(xtraj_list)
                            xtraj = rungeKattaSimulation(current_state,utraj,0.001,1,PlanePlant(alpha_list(idx)),false); 
                            t = xtraj.getBreaks();
                            tf=t(end);
                            [new_x,new_y] = turnTrajToData(xtraj,utraj,t);

                            if new_y(1) == 0
                                keyboard
                            end

                            x_to_attach=[new_x x_to_attach]; y_to_attach =[new_y y_to_attach];
                        end
                        
                        data{k,1} = x_to_attach';
                        data{k,2} = y_to_attach';
                        x = [x; x_to_attach'];
                        y = [y; y_to_attach'];
                    end

                    control = controller.predict(current_state');

                    % advance the dynamics
                    xdot = p.dynamics(0,x1(:,k),control);
                    xnew = x1(:,k) + xdot*dt;
                    x1(:,k+1)=xnew;
                    fprintf('Completed=%0.1f percent of alpha value = %0.2d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
                end
                train_idx = train_idx + 1;
            end  
            rng(RF_seed);
            controller = TreeBagger(50,x,y,'Method','regression');

    end   
end


