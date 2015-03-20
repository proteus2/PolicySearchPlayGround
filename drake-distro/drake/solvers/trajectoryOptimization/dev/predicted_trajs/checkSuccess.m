function score = checkSuccess(xtraj)
    xf = xtraj.eval(xtraj.tspan(end)); xf = xf(1:2,1);
    xg = [0;0.5;0.1];
    goal_threshold = 0.70;

    if (norm(xf-xg)<goal_threshold) 
        score = true;
    else
        score = false;
    end
end