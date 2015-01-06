% TODO: Fix this later to map from traj_list indicies to x0 location
function plotTrajectories(controller,dt,traj_list)
    
    close all;
    
    % for evaluateTrajCost
    field = ObstacleField();
    field = field.GenerateRandomObstacles();
    
    n=size(traj_list,1);
    figure;
    ctrl_cost_list = zeros(n,2); trajopt_cost_list = zeros(n,2);
    p = PlanePlant();

    for x=0:n-1
        x0 = [x; 9; 0; 0];  

        xtraj = traj_list{x+1,1};
        tf = xtraj.getBreaks; tf=tf(end);
        t = 0:dt:tf;
        utraj = traj_list{x+1,2};
        % evaluate trajopt's costs
        [tot_cost,avg_cost] = evaluateTrajCost(xtraj,utraj,field,t);
        trajopt_cost_list(x+1,1)=tot_cost; trajopt_cost_list(x+1,2)=avg_cost; 
        
        %make xtraj into matrix form
        xtraj = xtraj.eval(t);

        tic
        [x1,u1] = rungeKattaSimulation(x0,controller,tf,p);
        % evaluate controlller cost statring from x0
        [tot_cost,avg_cost] = evaluateTrajCost(x1,u1,field,t);
        ctrl_cost_list(x+1,1) = tot_cost; ctrl_cost_list(x+1,2) = avg_cost;
        toc
        t=0:dt:tf;
        traj_exed = x1.eval(t);
        
        subplot(2,5,x+1);
        scatter(xtraj(1,:),xtraj(2,:),'r'); 
        hold on; scatter(traj_exed(1,:),traj_exed(2,:),'b');
        title_str = sprintf('x0 = [%d,9,0,0]',x);
        title(title_str);
    end
    legend('controller','trajOpt');
    savefig('traj_results_supervised')
    save('cost_list','ctrl_cost_list','trajopt_cost_list');
end
