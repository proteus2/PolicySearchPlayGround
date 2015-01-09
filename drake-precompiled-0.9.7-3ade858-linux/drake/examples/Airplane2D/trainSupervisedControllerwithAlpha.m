varyAlphaGatherData = true;
if varyAlphaGatherData 
    traj_list = cell(N,2);
    alpha_vals = zeros(N,1);
    train_alpha_list = [5,7,12,14,15,18,20,22,24];
    N = size(train_alpha_list,2);
    for idx=1:N
        alpha = train_alpha_list(idx);
        x0 = [3.9;0;0;0];
        [utraj,xtraj] = getTrajectory(x0,alpha);
        traj_list{idx,1} = xtraj;
        traj_list{idx,2} = utraj;
    end
    [x,y] = aggregateDataFromCell(traj_list); 
    controller = TreeBagger(50,x,y,'Method','regression');
    data = traj_list;
    save('vary_alpha_supervised_results','controller','data','train_alpha_list');
end

