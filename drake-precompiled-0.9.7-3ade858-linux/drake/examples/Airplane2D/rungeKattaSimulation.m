function [xtraj,utraj] = rungeKattaSimulation(x0,u,dt,tf,p,varyAlpha)
    t=0:dt:tf;
    N = size(t,2);
    x1=zeros(4,N); u1=zeros(1,N);
    x1(:,1) = x0;
    alpha = p.v;
    for k=1:N-1  
        if varyAlpha
            curr_state = [x1(:,k);alpha];
        else
            curr_state = x1(:,k);
        end
        if strcmp(class(u),'TreeBagger')
            control = u.predict(curr_state');
        elseif strcmp(class(u),'MMDController') ||strcmp(class(u),'MMDAggregateController')
            control = u.predict(curr_state);
        elseif strcmp(class(u),'network')
            control = u(curr_state);
        else
            control = u.eval(t(k));
        end
        u1(:,k) = control;
        xdot = p.dynamics(0,x1(:,k),control);
        xnew = x1(:,k) + xdot*dt;
        x1(:,k+1)=xnew;
    end
    x1 = PPTrajectory(foh(t,x1));
    u1 = PPTrajectory(foh(t,u1));
    xtraj = x1.setOutputFrame(p.getStateFrame);
    utraj = u1.setOutputFrame(p.getInputFrame);    
end