function score = checkSuccess(xtraj)
    xg = [0;0.5;0.1];
    goal_threshold = 0.3;    

    % obj and hand trajectories
    obj_pose_traj = xtraj(1:3,:);
    hand_pose_traj = xtraj(7:9,:);
    xf = obj_pose_traj(1:3,end);
    
    % contact violation
    contact_threshold =0.3;
    contact_idx = find(sqrt(sum((hand_pose_traj-obj_pose_traj).^2))<contact_threshold,1); % find when the contact happened
    
    % maximum distance from obj's initial position to the all the obj
    % positions upto t = contact_idx
    dists = max(sum(bsxfun(@minus,obj_pose_traj(:,1),obj_pose_traj(:,1:contact_idx)).^2)); 
    
    % check if obj moved before hand touched it
    physics_threshold = 0.001;
    if dists > physics_threshold
        dynamics_violated=true;
    else
        dynamics_violated=false;
    end

    if (norm(xf-xg)<goal_threshold) && (~dynamics_violated)
        score = true;
    else
        score = false;
    end
end