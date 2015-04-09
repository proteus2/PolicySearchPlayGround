obs = 0.0634;
alpha_for_obs_val = [10,11];
[utraj,xtraj_list,traj_list,F]=getRobustTrajectory([3.9;0;0;0],alpha_for_obs_val,false);

for idx=1:numel(alpha_for_obs_val)
    xtraj = rungeKattaSimulation([3.9;0;0;0],utraj,0.001,1,PlanePlant(alpha_for_obs_val(idx)),false); 
    checkSuccess(xtraj)
end
