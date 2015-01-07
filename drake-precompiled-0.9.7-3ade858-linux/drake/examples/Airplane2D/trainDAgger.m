function [controller, dagger_data] = trainDAgger(x0,tf,p,traj_list)
   
    % get initial state and action trajectory
    [x,y] = aggregateDataFromCell(traj_list);
    n_init_data = size(traj_list,1);
    
    % train initial Random Forest
    controller = TreeBagger(50,x,y,'Method','regression');
    
    % gather DAgger data
    dt=0.01; t=0:dt:tf; N = size(t,2);
    x1=zeros(4,N); x1(:,1) = x0; 
    n_dagg_itern = 5;
    dagger_data = traj_list;
    N
    for idx=n_init_data+1:n_init_data+n_dagg_itern;
        idx
        xtraj = zeros(4,N); xtraj(:,1) = x0; utraj = zeros(1,N);
        for k=1:N-1
            k
            [u_traj_from_curr_loc,~,~] = getTrajectory(x1(:,k));
            control = controller.predict(x1(:,k)');
            xdot = p.dynamics(0,x1(:,k),control);
            xnew = x1(:,k) + xdot*dt;
            x1(:,k+1)=xnew;
            
            xtraj(:,k+1) = xnew;
            utraj(:,k) = u_traj_from_curr_loc.eval(0); 
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

