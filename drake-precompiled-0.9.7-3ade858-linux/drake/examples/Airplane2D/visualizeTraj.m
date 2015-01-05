function visualizeTraj(x_traj)
    p = PlanePlant();

    x0 = x_traj.eval(0);
    
    % add obstacles
    disp('Adding obstacles...');
    field = ObstacleField();
    field = field.GenerateRandomObstacles();    
    
    figure(25); clf;  hold on;
    v = PlaneVisualizer(p,field);
    v.draw(0,x0);
    drawnow
    x_traj = x_traj.setOutputFrame(p.getStateFrame);
    v.playback(x_traj);
end