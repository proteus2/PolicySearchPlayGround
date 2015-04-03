function [traj_list,cost_list] = EvaluateControllers(ctrl_list,x0,tf,alpha,obs)
    
    n_ctrls = size(ctrl_list,1);
    p = PlanePlant(alpha);
    dt = 0.001;
    t=0:dt:tf;
    traj_list = cell(0,2);
    cost_list = zeros(n_ctrls,2);
    
    field = ObstacleField();
    field = field.GenerateRandomObstacles(); 
    for idx = 1:n_ctrls
        ctrl = ctrl_list{idx,1};
        tic
        if strcmp(class(ctrl),'MMDController') 
            if size(ctrl.data_sets{1},1) == 4
                    [xtraj,utraj,t]=rungeKattaSimulation(x0,ctrl,dt,tf,p,false);  
            else
                    if ~exist('obs','var')
                        [xtraj,utraj,t]=rungeKattaSimulation(x0,ctrl,dt,tf,p,true);  
                    else
                        [xtraj,utraj,t]=rungeKattaSimulation(x0,ctrl,dt,tf,p,false,Inf,obs); 
                    end
            end
        elseif strcmp(class(ctrl),'TreeBagger') 
            if size(ctrl.X,2) == 4
                [xtraj,utraj,t]=rungeKattaSimulation(x0,ctrl,dt,tf,p,false);  
            else
                [xtraj,utraj,t]=rungeKattaSimulation(x0,ctrl,dt,tf,p,true);  
            end
        else
            [xtraj,utraj,t]=rungeKattaSimulation(x0,ctrl,dt,tf,p,true);  
        end
        toc
        [tot_cost,avg_cost] = evaluateTrajCost(xtraj,utraj,field,t);
        traj_list{idx,1} = xtraj; traj_list{idx,2} = utraj;
        cost_list(idx,1) = tot_cost; cost_list(idx,2) = avg_cost;
    end
    
end
