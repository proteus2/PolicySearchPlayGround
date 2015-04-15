function plotTrajectory(xtraj_list,exed)
    field = ObstacleField();
    field = field.GenerateRandomObstacles();    
    figure(25); clf;  hold on;
    p=PlanePlant();
    v = PlaneVisualizer(p,field);
    v.draw(0,[3.9;0;0;0]);
    
    for idx=1:numel(xtraj_list)
        x = xtraj_list{idx}.eval(xtraj_list{idx}.getBreaks());
        hold on; scatter(x(1,:),x(2,:))
    end
end