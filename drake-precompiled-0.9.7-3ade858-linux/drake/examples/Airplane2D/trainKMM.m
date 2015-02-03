function [controller] = trainKMM(x0_list,n_mmd_itern,alpha_list)
    load('RF_seed');
    controller = KMMController(RF_seed);
    dt = 0.001;        
    n_kmm_limit = 10;
    gamma = 0.0025;
    for MMD_iteration = 1:n_mmd_itern
            n_kmm_calls = 0;
            for x0_idx=1:size(x0_list,2)
                x0 = x0_list(:,x0_idx);
                for alpha_idx=1:numel(alpha_list) 
                    %% 1) get the reference trajectory
                    alpha = alpha_list(alpha_idx);
                    init_fname = sprintf('./InitTraining/initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4))
%                     if ~exist(init_fname,'file')
                        [utraj,xtraj,~] = getTrajectoryForKMM(x0,alpha,true);
%                         save(init_fname, 'xtraj','utraj');
%                     else
%                         load(init_fname);
%                     end
                    
                    xtraj_ref = xtraj; utraj_ref = utraj;
                    tf = xtraj_ref.getBreaks(); tf=tf(end); t = xtraj_ref.getBreaks();
                    [x,y] = turnTrajToData(xtraj_ref,utraj_ref,t,alpha);
                    if alpha_idx == 1 && x0_idx == 1
                        controller = setNewController(controller,x,y,ones(21,1)); % if first alpha, train
                    end
                    
                    %% 2) Execute the current trajectory
                    p = PlanePlant(alpha);
                    [xtraj_exed,~] = rungeKattaSimulation(x0,controller,dt,tf,p,true);
                     drawTrajectories({xtraj_ref.eval(xtraj_ref.getBreaks());xtraj_exed.eval(xtraj_exed.getBreaks())},x0);

                    % 3) while MMD between the exe'd traj and the ref trajectory is not small,
                    n_kmm = 0;
                    while (computeMMD(xtraj_ref.eval(xtraj_ref.getBreaks()),xtraj_exed.eval(xtraj_exed.getBreaks())) > gamma) ...
                            && n_kmm<=n_kmm_limit
                        % KMM the output of the trajectory optimization
                        train_x = xtraj_ref.eval(xtraj_ref.getBreaks());
                        test_x = xtraj_exed.eval(xtraj_exed.getBreaks());
                        sprintf('KMM...')
                        kmm_weights = KMM(train_x,test_x,100);
                        
                        % train a new policy on the D union KMM'ed output
                         [x,y] = turnTrajToData(xtraj_ref,utraj_ref,t,alpha);
                        controller = setNewController(controller,x,y,kmm_weights);
                        
                        % execute the policy
                        [xtraj_exed,~] = rungeKattaSimulation(x0,controller,dt,tf,p,true);
                         drawTrajectories({xtraj_ref.eval(xtraj_ref.getBreaks());xtraj_exed.eval(xtraj_exed.getBreaks())},x0);
                        n_kmm = n_kmm + 1;
                        n_kmm_calls = n_kmm_calls + 1;
                    end
                end
            end
            if n_kmm_calls == 0
                break
            end
    end   
end


