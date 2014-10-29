function cost=AcrobotControllerWrapper(x)
    p = AcrobotPlant;
    % initialize the u, initial state, and time steps
    x0 = [pi 0 0 0];
    u0 = 0;
    T= 10;
    h = 100;
    dt = T/h;
    
    for t=1:10
        %simulate the dynamics for ten seconds
        
        % compute the cost to go
        
    end
    
    % compute the total cost incurred
    cost=;
end