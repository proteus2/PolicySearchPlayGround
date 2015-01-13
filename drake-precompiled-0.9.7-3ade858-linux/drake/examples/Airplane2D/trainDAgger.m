function [controller, dagger_data] = trainDAgger(x0,tf_list,init_traj_train_data,n_dagg_itern,train_alpha_list)   
    % get initial state and action trajectory
    if exist('train_alpha_list','var')
        x = init_traj_train_data{1,1}; 
        alpha_to_attach = ones(1,size(x,2))*10;
        x = [x;alpha_to_attach]';
    else
        x = init_traj_train_data{1,1}';
    end
    y = init_traj_train_data{1,2}';
    
    % train initial Random Forest
    controller = TreeBagger(50,x,y,'Method','regression');

    % gather DAgger data
    dagger_data = init_traj_train_data;
    n_dagg_itern = 5;
    n=1; n_alpha=size(train_alpha_list,2);

    for idx_alpha=1:n_alpha
        alpha=train_alpha_list(idx_alpha);
        p = PlanePlant(alpha);
        dt=0.01; t=0:dt:tf_list(idx_alpha); N = size(t,2);
        x1=zeros(4,N); x1(:,1) = x0; 
        for idx=2:n_dagg_itern;
            xtraj = zeros(4,N); xtraj(:,1) = x0; utraj = zeros(1,N);

            for k=1:N-1
    %              if exists('alpha','var')
                  curr_state = [x1(:,k);alpha];
    %             else
    %                 curr_state = x1(:,k);
    %              end

                [u_traj_from_curr_loc,~,~] = getTrajectory(x1(:,k));
                control = controller.predict(curr_state');
                xdot = p.dynamics(0,x1(:,k),control);
                xnew = x1(:,k) + xdot*dt;
                x1(:,k+1)=xnew;

                xtraj(:,k+1) = xnew;
                utraj(:,k) = u_traj_from_curr_loc.eval(0); 
                fprintf('Completed=%0.1f percent of alpha value = %0.2d and dagger iteration of %d\n', k/(N-1)*100, alpha, idx);
            end
            xtraj = PPTrajectory(foh(t,xtraj));
            utraj = PPTrajectory(foh(t,utraj));

            % aggregate data 
            dagger_data{n+1,1} = xtraj;
            dagger_data{n+1,2} = utraj;
            n=n+1;

            % train using the aggregated dataset
            [x,y] = aggregateDataFromCell(dagger_data,alpha);
            controller = TreeBagger(50,x,y,'Method','regression');
        end  
        save('vary_alpha_dagger_results','controller','dagger_data','alpha');
    end
    save('vary_alpha_dagger_results','controller','dagger_data','train_alpha_list');
end

