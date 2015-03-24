function score = checkSuccess(xtraj)
    xf = xtraj.eval(xtraj.tspan(end)); xf = xf(1:3,1);
    xg = [0;0.5;0.1];
    goal_threshold = 0.70;
    
    
    t = xtraj.getBreaks();
    xtraj_vals = xtraj.eval(t);
    obj_pose_traj = xtraj_vals(1:3,:);
    hand_pose_traj = xtraj_vals(7:9,:);
    
    contact_threshold =0.25;
    contact_idx = find(sqrt(sum((hand_pose_traj-obj_pose_traj).^2))<contact_threshold,1);
    
    dists = max(sum(bsxfun(@minus,obj_pose_traj(:,1),obj_pose_traj(:,1:contact_idx)).^2));
    % check if obj moved before hand touched it
    if dists > 0.18
        dynamics_violated=true;
    else
        dynamics_violated=false;
    end
    

    if (norm(xf-xg)<goal_threshold) &&(~dynamics_violated)
        score = true;
    else
        score = false;
    end
end