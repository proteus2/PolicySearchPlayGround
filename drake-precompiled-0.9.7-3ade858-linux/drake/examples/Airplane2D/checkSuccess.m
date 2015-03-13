function score = checkSuccess(xtraj)
    xf = xtraj.eval(xtraj.tspan(end)); xf = xf(1:2,1);
    xg = [5;9];
    goal_threshold = 0.70;
    
    field = ObstacleField();
    field = field.GenerateRandomObstacles();
    t = xtraj.tspan();
    
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
    
    
    
    if (norm(xf-xg)<goal_threshold) && ~collision
        score = true;
    else
        score = false;
    end
end