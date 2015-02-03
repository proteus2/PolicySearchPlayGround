function drawTrajectories(traj_list,x0)

    p=PlanePlant();
    field = ObstacleField();
    field = field.GenerateRandomObstacles();    
    figure(25); clf;  hold on;
    v = PlaneVisualizer(p,field);
    v.draw(0,[4;0;0;0]);
    
    for idx=1:size(traj_list,1)
        traj = traj_list{idx};
        hold on; scatter(traj(1,:),traj(2,:));
    end
end