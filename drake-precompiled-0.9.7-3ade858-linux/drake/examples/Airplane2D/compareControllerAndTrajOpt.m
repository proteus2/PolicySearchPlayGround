function [x_ctrller,xtraj,trajopt_cost,ctrller_cost]=compareControllerAndTrajOpt(x0,controller,dt,p,varyAlpha,previously_solved)    
    ctrller_cost = zeros(1,2); trajopt_cost = zeros(1,2);
    field = ObstacleField();
    field = field.GenerateRandomObstacles();
    
    if ~exist('previously_solved','var')
        % solve trajectory from the given x0
        [utraj,~] = getTrajectory(x0,p.v);
    else
        utraj = previously_solved;
    end
    
    tf = utraj.getBreaks; tf=tf(end);
    t = 0:dt:tf;
    xtraj = rungeKattaSimulation(x0,utraj,dt,tf,p,varyAlpha);
    [tot_cost,avg_cost] = evaluateTrajCost(xtraj,utraj,field,t);
    trajopt_cost(1,1)=tot_cost; trajopt_cost(1,2)=avg_cost; 
    xtraj_ = xtraj.eval(t);
    
    % use controller starting from given x0
    tic
    [x_ctrller,u_ctrller] = rungeKattaSimulation(x0,controller,dt,tf,p,varyAlpha);
    [tot_cost,avg_cost] = evaluateTrajCost(x_ctrller,u_ctrller,field,t);
    toc
    ctrller_cost(1,1) = tot_cost; ctrller_cost(1,2) = avg_cost;
    x_ctrller_ = x_ctrller.eval(t);

    
    figure;scatter(xtraj_(1,:),xtraj_(2,:),'r'); 
    hold on; scatter(x_ctrller_(1,:),x_ctrller_(2,:),'b');
    
    legend('trajOpt','controller','Location','southeast');
end
