function [controller, mmd_data] = trainMMD(x0,tf,traj_list,p)
   
    dt=0.001; t=0:dt:tf; N = size(t,2);
    x1=zeros(4,N); x1(:,1) = x0; 
    
    % get initial state and action trajectory
    assert(size(traj_list,1) == 1);
    n_mmd_itern = 10;
    controller = MMDController(t);
    controller = setNewController(controller,traj_list{1,1},traj_list{1,2});
    
    % parameters for MMD
    alpha = 2.7977; 
    gamma = 0.1;
    
    for idx=2:n_mmd_itern;
        xtraj = zeros(4,N); xtraj(:,1) = x0; utraj = zeros(1,N);
        for k=1:N-1
            d = checkDiscrepancy(controller,x1(:,k));
            k
            if d > alpha
                d
                [u_traj_from_curr_loc,~,~] = getTrajectory(x1(:,k));
                action_diff = u_traj_from_curr_loc.eval(0) - controller.predict(x1(:,k));
                if norm(action_diff,1) > gamma
                    control = u_traj_from_curr_loc.eval(0);
                else
                    control = controller.predict(x1(:,k));
                end
                
            else
                control = controller.predict(x1(:,k));
            end
            xdot = p.dynamics(0,x1(:,k),control);
            xnew = x1(:,k) + xdot*dt;
            x1(:,k+1)=xnew;
            
            xtraj(:,k+1) = xnew;
            utraj(:,k) = control; 
        end
        xtraj = PPTrajectory(foh(t,xtraj));
        utraj = PPTrajectory(foh(t,utraj));
        
        controller = setNewController(controller,xtraj,utraj);
    end
    mmd_data = controller.data_sets;
    
end

