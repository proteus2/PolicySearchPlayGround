function [traj_list,cost_list] = EvaluateControllers(ctrl_list,x0,tf,alpha)
    
    n_ctrls = size(ctrl_list,1);
    p = PlanePlant(alpha);
    dt = 0.001;
    traj_list = cell(0,2);
    cost_list = zeros(n_ctrls,2);
    for idx = 1:n_ctrls
        ctrl = ctrl_list{idx,1};
        [xtraj,utraj]=rungeKattaSimulation(x0,ctrl,dt,tf,p,true);  
        [tot_cost,avg_cost] = evaluateTrajCost(xtraj,utraj,field,t);
        traj_list{idx,1} = xtraj; traj_list{idx,2} = utraj;
        cost_list(idx,1) = tot_cost; cost_list(idx,2) = avg_cost;
    end
    
end