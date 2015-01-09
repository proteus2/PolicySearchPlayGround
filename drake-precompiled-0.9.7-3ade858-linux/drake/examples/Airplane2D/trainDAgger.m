function [controller, dagger_data] = trainDAgger(x0,tf,p,traj_list,n_dagg_itern,alpha)   
    % get initial state and action trajectory
    if exist('alpha','var')
        x = traj_list{1,1}; 
        alpha_to_attach = ones(1,size(x,2))*alpha;
        x = [x;alpha_to_attach]';
    else
        x = traj_list{1,1}';
    end
    y = traj_list{1,2}';
    
    % train initial Random Forest
    controller = TreeBagger(50,x,y,'Method','regression');
    
    % gather DAgger data
    dt=0.01; t=0:dt:tf; N = size(t,2);
    x1=zeros(4,N); x1(:,1) = x0; 
    dagger_data = traj_list;
    
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
        dagger_data{idx,1} = xtraj;
        dagger_data{idx,2} = utraj;
        
        % train using the aggregated dataset
        [x,y] = aggregateDataFromCell(dagger_data);
        controller = TreeBagger(50,x,y,'Method','regression');
    end  
end

