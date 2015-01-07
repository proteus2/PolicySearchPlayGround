function [controller, mmd_data] = trainMMD(x0,tf,traj_list,p)
   
    dt=0.01; t=0:dt:tf; N = size(t,2);
    x1=zeros(4,N); x1(:,1) = x0; 
    
    % get initial state and action trajectory
    assert(size(traj_list,1) == 1);
    n_mmd_itern = 5;
    controller = MMDController();
    controller = setNewController(controller,traj_list{1,1},traj_list{1,2});
    temp= traj_list{1,1};
    % parameters for MMD
    alpha = 0.839105708705388; 
    gamma = 0.2;
    figure; scatter(temp(1,:),temp(2,:),'b')
    dp_list=[];
    for idx=2:n_mmd_itern;
        xtraj = zeros(4,N); xtraj(:,1) = x0; utraj = zeros(1,N);
        xtraj = []; utraj=[];
        for k=1:N-1
            [d,min_idx] = checkDiscrepancy(controller,x1(:,k));
            dp_list =[dp_list d];
            hold on; scatter(x1(1,k),x1(2,k),'r');
            disp(sprintf('Completed=%0.2f percent', k/(N-1)*100));
            if d > alpha
                d
                [u_traj_from_curr_loc,~,~] = getTrajectory(x1(:,k));
                action_diff = u_traj_from_curr_loc.eval(0) - controller.predict(x1(:,k),min_idx);
                k
                x1(:,k)
                if norm(action_diff,1) > gamma
                    control = u_traj_from_curr_loc.eval(0);
                    xtraj = [xtraj x1(:,k)]; utraj = [utraj control];
                else
                    control = controller.predict(x1(:,k));
                end
                
            else
                control = controller.predict(x1(:,k),min_idx);
            end
            xdot = p.dynamics(0,x1(:,k),control);
            xnew = x1(:,k) + xdot*dt;
            x1(:,k+1)=xnew;
        end
        %xtraj = PPTrajectory(foh(t,xtraj));
        %utraj = PPTrajectory(foh(t,utraj));
        if isempty(utraj)
            break
        else
            controller = setNewController(controller,xtraj,utraj);
        end
    end
    mmd_data = controller.data_sets;
    
end

