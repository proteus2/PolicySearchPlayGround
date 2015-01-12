function [controller, mmd_data] = trainMMDwithAlphaTakeAllDataFromTrajOpt(x0,tf,alpha_list,init_train_file)
    getInitTrain = true;
    if nargin == 4
        load(init_train_file);
        getInitTrain = false;
    end
    
    if getInitTrain
        traj_list = cell(1,2);
        [utraj,xtraj] = getTrajectory(x0);
        tf = traj_list{1,1}.getBreaks; tf = tf(end);
        t=0:0.001:tf;
        traj_list{1,1} = xtraj.eval(t);
        traj_list{1,2} = utraj.eval(t);
        save('traj_list','traj_list');
    end
    
    
    % set parameters
    dt=0.01; t=0:dt:tf; N = size(t,2);
    n_mmd_itern = 5;
    beta = 0.839105708705388; 
    %beta = 100;
    gamma = 0.2;

    
    % set initial training data and train it
    controller = MMDController();
    traj_list{1,1} = [traj_list{1,1}; ones(1,size(traj_list{1,1},2))*10]; % append the alpha value
    controller = setNewController(controller,traj_list{1,1},traj_list{1,2});
    trajopt = traj_list{1,1}; trajopt = trajopt(1:2,:);
    
    % loop through alpha values
    for alpha=alpha_list
        p = PlanePlant(alpha);
        figure; scatter(trajopt(1,:),trajopt(2,:));
        title(sprintf('alpha = %d',alpha));
        
        for MMD_iteration = 2: n_mmd_itern
            x1=zeros(4,N); x1(:,1) = x0; % state simulation
            x = []; y=[];                % data to be fed to MMD
            
            for k=1:N-1
                current_state = [x1(:,k);alpha];
                [d,min_idx] = checkDiscrepancy(controller,current_state);
                hold on; scatter(x1(1,k),x1(2,k),'r');
                fprintf('Completed=%0.1f percent of alpha value = %d and MMD iteration of %d\n', k/(N-1)*100, alpha, MMD_iteration);
                if d > beta
                    [u_traj_from_curr_loc,x_traj_from_curr_loc,~] = getTrajectory(x1(:,k));
                    action_diff = u_traj_from_curr_loc.eval(0) - controller.predict(current_state,min_idx);
                    if norm(action_diff,1) > gamma
                        control = u_traj_from_curr_loc.eval(0);
                        time_steps= x_traj_from_curr_loc.getBreaks();
                        new_x = x_traj_from_curr_loc.eval(time_steps);
                        new_x = [new_x; ones(1,size(time_steps,2))*alpha];
                        new_y = u_traj_from_curr_loc.eval(time_steps);
                        x = [x new_x]; 
                        y = [y new_y];
                    else
                        control = controller.predict(current_state);
                    end
                else
                    control = controller.predict(current_state,min_idx);
                end
                xdot = p.dynamics(0,x1(:,k),control);
                xnew = x1(:,k) + xdot*dt;
                x1(:,k+1)=xnew;
            end

            if isempty(y)
                break
            else
                controller = setNewController(controller,x,y);
            end
        end
        
    end
    
    
    keyboard
    
end

