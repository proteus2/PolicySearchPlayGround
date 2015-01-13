varyAlphaGatherData = true;
if varyAlphaGatherData 
    train_alpha_list = [5,7,12,14,15,18,20,22,24];
    N = size(train_alpha_list,2);
    traj_list = cell(N,2);
    alpha_vals = zeros(N,1);
    n_supp_itern = 1;
    
    
    data = cell(0,2);
    load('official_init_train_traj');  
    init_traj_train_data = traj_list;
    data{1,1}=traj_list{1,1}; data{1,2}=traj_list{1,2};
    
    x0 = [3.9;0;0;0];
    idx3 = 1;
    for idx=1:N
        alpha = train_alpha_list(idx);
        for idx2=1:n_supp_itern
            [utraj,xtraj] = getTrajectory(x0,alpha);
            traj_list{idx3,1} = xtraj;
            traj_list{idx3,2} = utraj;
        end
    end
     
    x=[];y=[];
    for idx=1:size(train_alpha_list,2)
        alpha = train_alpha_list(idx);
        xtraj=traj_list{idx,1}.eval(traj_list{idx,1}.getBreaks);
        x = [x [xtraj;alpha*ones(1,size(xtraj,2))]];
        
        utraj = traj_list{idx,2}.eval(traj_list{idx,1}.getBreaks);
        y = [y utraj];
    end
    x=[x [data{1,1}; ones(1,size(data{1,1},2))*10]]; y=[y data{1,2}];
    x = x';y=y';
    controller = TreeBagger(50,x,y,'Method','regression');
    save('vary_alpha_supervised_results4','controller','data','traj_list','train_alpha_list');
end



