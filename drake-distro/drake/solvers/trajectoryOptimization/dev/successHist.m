function successHist
    checkDependency('lcmgl');
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
end