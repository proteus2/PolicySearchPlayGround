function [xtraj] = rungeKattaSimulation(x0,u,tf,p)
    dt=0.001;
    t=0:dt:tf;
    N = size(t,2);
    x1=zeros(4,N);
    x1(:,1) = x0;
    for k=1:N-1
        if strcmp(class(u),'TreeBagger')
            control = u.predict(x1(:,k)');
        else
            control = u.eval(t(k));
        end
        xdot = p.dynamics(0,x1(:,k),control);
        xnew = x1(:,k) + xdot*dt;
        x1(:,k+1)=xnew;
    end
    x1 = PPTrajectory(foh(t,x1));
    xtraj = x1.setOutputFrame(p.getStateFrame);
end