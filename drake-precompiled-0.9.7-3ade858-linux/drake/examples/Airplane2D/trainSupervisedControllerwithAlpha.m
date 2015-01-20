varyAlphaGatherData = true;
if varyAlphaGatherData 
    train_alpha_list = [5];
    N = size(train_alpha_list,2);
    traj_list = cell(N,2);
    alpha_vals = zeros(N,1);
    n_supp_itern = 5;
    
    
    x0 = [3.9;0;0;0];
    if ~exist('vary_alpha_supervised_traj_list.mat','file')
        idx3 = 1;
        for idx=1:N
            alpha = train_alpha_list(idx);
            for idx2=1:n_supp_itern
                [utraj,xtraj] = getTrajectory(x0,alpha,false);
                traj_list{idx3,1} = xtraj;
                traj_list{idx3,2} = utraj;
                idx3=idx3+1;
                save('vary_alpha_supervised_traj_list_test','traj_list','alpha');
            end
        end
    end
    
    load('vary_alpha_supervised_traj_list');
    x=[];y=[];
    for idx=1:size(train_alpha_list,2)
        alpha = train_alpha_list(idx);
        for idx2=1:n_supp_itern
            xtraj=traj_list{idx,1}.eval( traj_list{idx2+(idx-1)*n_supp_itern,1}.getBreaks() );
            x = [x [xtraj;alpha*ones(1,size(xtraj,2))]];

            utraj = traj_list{idx,2}.eval( traj_list{idx2+(idx-1)*n_supp_itern,1}.getBreaks() );
            y = [y utraj];
        end
    end
    
    x = x';y=y';
    controller = TreeBagger(50,x,y,'Method','regression');
    save('vary_alpha_supervised_results_alpha=5,iter=5','controller','traj_list','train_alpha_list');
end



