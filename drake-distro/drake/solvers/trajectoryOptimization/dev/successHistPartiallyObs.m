function successHistPartiallyObs
    %% Traj Opt
    n_obs = 37;
    n_trials = 1;
    success_score = zeros(n_obs,1);
    for obs_idx = 1:n_obs
            fname= sprintf('./partial_observable_init/new_traj_%d.mat',obs_idx-1);
            load(fname);
            success_score(obs_idx,1) = checkSuccess(q_sol);
    end
    traj_opt_succ_rate = sum(success_score)/n_obs
    traj_opt_CI = 1.96*std(success_score)/sqrt(n_obs);
    
    %% MMD Controller
    success_score = zeros(n_obs,n_trials);
    for obs_idx = 1:n_obs
        for trial_idx=1:n_trials
            fname= sprintf('./MMD_training_output_partially_observable/MMD_predicted_traj_%d_%d.mat',obs_idx-1,trial_idx-1);
            load(fname);
            q_sol=xtraj(1:end-1,1:end);
%             qtraj_sol = PPTrajectory(foh(cumsum(h_sol), q_sol));
            success_score(obs_idx,trial_idx) = checkSuccess(q_sol);
        end
    end
    mmd_succ_rate = sum(success_score)/n_obs
    mmd_CI = 1.96*std(success_score)/sqrt(n_obs);
     
    %% Sup Controller
    success_score = zeros(n_obs,n_trials);
    for obs_idx = 1:n_obs
        for trial_idx=1:n_trials
            fname= sprintf('./sup_training_output_partially_observable/MMD_predicted_traj_%d_%d.mat',obs_idx-1,trial_idx-1);
            load(fname);
            q_sol=xtraj(1:end-1,1:end);
%             qtraj_sol = PPTrajectory(foh(cumsum(h_sol), q_sol));
            success_score(obs_idx,trial_idx) = checkSuccess(q_sol);
        end
    end
    sup_succ_rate = sum(success_score)/n_obs
    sup_CI = 1.96*std(success_score)/sqrt(n_obs);
    
    dagg_succ_rate = 0.53;
    dagg_CI = 0.12;
    
    figure;bar([traj_opt_succ_rate dagg_succ_rate sup_succ_rate mmd_succ_rate])  
    hold on; errorbar([traj_opt_succ_rate dagg_succ_rate sup_succ_rate mmd_succ_rate ],[traj_opt_CI dagg_CI sup_CI mmd_CI],'o');

    ax = gca;
    ax.XTickLabel = {'trajopt','DAgger','Supervised','TOIL'};
    title('Success Rate for 40 Different Partially Observable Models')
    ylim([0 1])
    ylabel('Success Rate')
    xlabel('Algorithms')
    
end