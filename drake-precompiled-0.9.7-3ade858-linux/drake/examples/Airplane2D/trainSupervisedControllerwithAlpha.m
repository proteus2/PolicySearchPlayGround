varyAlphaGatherData = true;
if varyAlphaGatherData 
    train_alpha_list = [5,7];
    N = size(train_alpha_list,2);
    traj_list = cell(N,2);
    alpha_vals = zeros(N,1);
    n_supp_itern = 2;
    
    
%     x0 = [3.9;0;0;0];
%     if ~exist('vary_alpha_supervised_train_traj.mat','file')
%         idx3 = 1;
%         for alpha_idx=1:N
%             alpha = train_alpha_list(alpha_idx);
%             for idx2=1:n_supp_itern
%                 [utraj,xtraj] = getTrajectory(x0,alpha,false);
%                 traj_list{alpha_idx,1,idx2} = xtraj;
%                 traj_list{alpha_idx,2,idx2} = utraj;
%                 save('vary_alpha_supervised_train_traj','traj_list','alpha');
%             end
%         end
%     end
%     
%     load('vary_alpha_supervised_train_traj');
%     x=[];y=[];
%     for alpha_idx=1:size(train_alpha_list,2)
%         alpha = train_alpha_list(alpha_idx);
%         for idx2=1:n_supp_itern
%             xtraj=traj_list{alpha_idx,1,idx2}.eval( traj_list{alpha_idx,1,idx2}.getBreaks() );
%             x = [x [xtraj;alpha*ones(1,size(xtraj,2))]];
% 
%             utraj = traj_list{alpha_idx,2,idx2}.eval( traj_list{alpha_idx,2,idx2}.getBreaks() );
%             y = [y utraj];
%         end
%     end

    x=[];y=[];
    for idx=1:numel(train_alpha_list)
        alpha = alpha_list(idx);
        init_fname = sprintf('initial_mmd_traj_alpha=%d.mat',alpha);
        if ~exist(init_fname,'file')
            [utraj,xtraj,~] = getTrajectory(x0,alpha,false);
            save(init_fname, 'xtraj','utraj');
        else
            load(init_fname);
            if exist('u_traj_from_curr_loc','var') && ~exist('utraj','var');
                xtraj = x_traj_from_curr_loc;
                utraj = u_traj_from_curr_loc;
            end
        end
        tf = xtraj.getBreaks(); tf=tf(end);
        tf_list(idx) = tf;
        t = xtraj.getBreaks();
        [x_temp,y_temp] = turnTrajToData(xtraj,utraj,t,alpha);
        x=[x x_temp]; y=[y y_temp];
    end
    
    x = x';y=y';
    load('RF_seed');
    rng(RF_seed);
    controller = TreeBagger(50,x,y,'Method','regression');
    save('vary_alpha_supervised_results_alpha=5,7,24,iter=5','controller','traj_list','train_alpha_list');
end



