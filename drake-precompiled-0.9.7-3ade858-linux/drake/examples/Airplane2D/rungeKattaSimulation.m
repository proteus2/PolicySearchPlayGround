function [xtraj,utraj,t] = rungeKattaSimulation(x0,u,dt,tf,p,varyAlpha)
    t=0:dt:tf;
    N = size(t,2);
    x1=zeros(4,N); u1=zeros(1,N);
    x1(:,1) = x0;
    alpha = p.v;
    exed =[];
    for k=1:N-1  
        if varyAlpha
            curr_state = [x1(:,k);alpha];
        else
            curr_state = x1(:,k);
        end
        if strcmp(class(u),'TreeBagger')
            control = u.predict(curr_state');
        elseif strcmp(class(u),'MMDController') ||strcmp(class(u),'MMDAggregateController') ||strcmp(class(u),'KMMController')
            [control,idx] = u.predict(curr_state);
            exed = [exed idx];
        elseif strcmp(class(u),'BoostedKMMController')
            control = u.predict([curr_state;x0]);
        elseif strcmp(class(u),'network')
            control = u(curr_state);
        else
            control = u.eval(t(k));
        end
        u1(:,k) = control;
        xdot = p.dynamics(0,x1(:,k),control);
        xnew = x1(:,k) + xdot*dt;
        x1(:,k+1)=xnew;
        if( x1(2,k+1) > 9) || (norm(x1(1:2,k+1)-[5;9]) <0.7)
            break
        end
    end

    x1(:,k+2:end)=[];
    u1(:,k+2:end)=[];
    
    t=0:dt:(size(x1,2)-1)*dt;
    x1 = PPTrajectory(foh(t,x1));
    u1 = PPTrajectory(foh(t,u1));
    xtraj = x1.setOutputFrame(p.getStateFrame);
    utraj = u1.setOutputFrame(p.getInputFrame);    
end