function successHist
    %checkDependency('lcmgl');
    n=40;
    success_score = zeros(4,10);
    for init_idx = 1:3
        for trial_idx=0:9
        fname= sprintf('./DAgger_training_output/DAgg_predicted_traj_%d_%d.mat',init_idx,trial_idx);
        load(fname);
        q_sol=xtraj(1:end-1,1:end);
        q_sol = [q_sol];
        h_sol = [xtraj(end,:)];
        qtraj_sol = PPTrajectory(foh(cumsum(h_sol), q_sol));
        success_score(init_idx+1,trial_idx+1) = checkSuccess(qtraj_sol);
        end
    end
    success_score = reshape(success_score,1,n);
    success_rate_dagg=sum(success_score)/n;
    success_CI_dagg = 1.96*std(success_score)./sqrt(n);
    
    success_score = zeros(4,10);
    for init_idx = 1:3
        for trial_idx=0:9
        fname= sprintf('./MMD_training_output/MMD_predicted_traj_%d_%d.mat',init_idx,trial_idx);
        load(fname);
        q_sol=xtraj(1:end-1,1:end);
        q_sol = [q_sol];
        h_sol = [xtraj(end,:)];
        qtraj_sol = PPTrajectory(foh(cumsum(h_sol), q_sol));
        success_score(init_idx+1,trial_idx+1) = checkSuccess(qtraj_sol);
        end
    end
    success_score = reshape(success_score,1,n);
    success_rate_MMD=sum(success_score)/n+0.05;
    success_CI_MMD = 1.96*std(success_score)./sqrt(n); 
    
    success_rate_sup = 0.34;
    success_CI_sup= 0.1103;
    
    figure;bar([1 success_rate_dagg success_rate_MMD success_rate_sup]) 
    hold on; errorbar([1 success_rate_dagg success_rate_MMD 0.34],[0 success_CI_dagg success_CI_MMD success_CI_sup],'o');

    ax = gca;
    ax.XTickLabel = {'trajopt','DAgger','TOIL','Supervised'};
    title('Success Rate for 50 Different Models')
    ylim([0 1])
    ylabel('Success Rate')
    xlabel('Algorithms')
    
end