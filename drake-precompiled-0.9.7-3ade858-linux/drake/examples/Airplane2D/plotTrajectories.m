% TODO: Fix this later to map from traj_list indicies to x0 location
function plotTrajectories(controller,dt,traj_list)
    close all;
    n=size(traj_list,1);
    figure;
    for x=0:n-1
        x0 = [x; 9; 0; 0];  

        xtraj = traj_list{x+1,1};
        tf = xtraj.getBreaks; tf=tf(end);
        t = 0:dt:tf;
        xtraj = xtraj.eval(t);
 %       figure; scatter(xtraj(1,:),xtraj(2,:),'r');

        p = PlanePlant();
        tic
        x1 = rungeKattaSimulation(x0,controller,tf,p);
        toc
        t=0:dt:tf;
        traj_exed = x1.eval(t);
 %       hold on;scatter(traj_exed(1,:),traj_exed(2,:),'b'); 
        
        subplot(2,5,x+1);
        scatter(xtraj(1,:),xtraj(2,:),'r'); 
        hold on; scatter(traj_exed(1,:),traj_exed(2,:),'b');
        title_str = sprintf('x0 = [%d,9,0,0]',x);
        title(title_str);
    end
    legend('controller','trajOpt');
    savefig('traj_results_supervised')
end
