function score = checkSuccess(xtraj)
    xf = xtraj.eval(xtraj.tspan(end)); xf = xf(1:2,1);
    xg = [5;9];
    % goal_threshold = Inf; % Partially observable
    goal_threshold =1.1;
    
    field = ObstacleField();
    field = field.GenerateRandomObstacles();
    t = xtraj.tspan();
    t = 0:t(end)/21:t(end);
    
    x_evaled = xtraj.eval(t);
    collision  = false;
    for idx = 1:size(x_evaled,2)
        x = x_evaled(:,idx);
        [c,~] = field.obstacleConstraint(x);
        [c,~]=max(c);
        if c > 0
            collision = true;
        end
    end
    if (norm(xf-xg)<goal_threshold)% && ~collision
        score = true;
    else
        score = false;
    end
end