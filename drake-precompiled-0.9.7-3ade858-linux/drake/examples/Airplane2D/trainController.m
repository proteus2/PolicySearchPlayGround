N = 10;
traj_list = cell(N,2);

for idx=0:N
    x0 = [idx;9;0;0];
    [utraj,xtraj] = getTrajectory(x0);
    traj_list{idx,1} = xtraj;
    traj_list{idx,2} = utraj;
end


save('traj_list','traj_list');