varyAlphaGatherData = true;
if varyAlphaGatherData 
    train_alpha_list = [5,7,12,14,15,18,20,22,24];
    N = size(train_alpha_list,2);
    traj_list = cell(N,2);
    alpha_vals = zeros(N,1);
    n_supp_itern = 4;
    
    
    data = cell(0,2);
    x0 = [3.9;0;0;0];
    idx3 = 1;
    for idx=1:N
        alpha = train_alpha_list(idx);
        for idx2=1:n_supp_itern
            [utraj,xtraj] = getTrajectory(x0,alpha);
            traj_list{idx3,1} = xtraj;
            traj_list{idx3,2} = utraj;
            
            data{idx3,1} = xtraj.eval(xtraj.getBreaks);
            numbpts = size(data{idx3,1},2);
            data{idx3,1} = [data{idx3,1}; ones(1,numbpts)*alpha];
            data{idx3,2} = utraj.eval(xtraj.getBreaks);
            idx3 = idx3+1;
        end
    end
    x = cell2mat(data(:,1)'); x = x';
    y = cell2mat(data(:,2)');
    
    controller = TreeBagger(50,x,y,'Method','regression');
    save('vary_alpha_supervised_results2','controller','data','traj_list','train_alpha_list');
end



