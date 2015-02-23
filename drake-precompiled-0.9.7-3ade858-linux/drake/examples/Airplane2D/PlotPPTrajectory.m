function PlotPPTrajectory(xtraj_list)
    field = ObstacleField();
    field = field.GenerateRandomObstacles();    
    figure(25); clf;  hold on;
    p=PlanePlant();
    v = PlaneVisualizer(p,field);
        v.draw(0,[4;0;0;0]);
        colours = ['y';'m';'c';'r';'g';'b'];
    plots=[];
    for idx=1:size(xtraj_list,2)
        xtraj = xtraj_list{1,idx};
        ref_traj = xtraj.eval(xtraj.getBreaks());
        hold on; 
        plots=[plots scatter(ref_traj(1,:),ref_traj(2,:),colours(idx))];
    end
    legend(plots,'mmd','supervised');
end