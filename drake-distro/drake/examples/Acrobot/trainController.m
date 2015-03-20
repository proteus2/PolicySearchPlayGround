function controller = trainController()
    fname='traj_list_snopt';
    load(fname);
    x=[];y=[];
    for idx=1:1
        xtraj = traj_list{idx,2};
        xtraj = xtraj.eval(0:0.3:6);
        utraj = traj_list{idx,1};
        utraj = utraj.eval(0:0.3:6);
        
        x = [x xtraj];
        y = [y utraj];
    end
    x=x';y=y';
    controller = TreeBagger(50,x,y,'Method','regression');
    
    p = AcrobotPlant;
    v = AcrobotVisualizer(p);   
    t =0:0.3:6;
    N = size(t,2);
    dt = 0.3;
    
    agg_x = x; agg_y = y;
    
    for m=1:5
        x1=zeros(4,N);
        for k=1:N-1
            control =  max(min(controller.predict(x1(:,k)'),20),-20);
            if k==1 
                control 
            end
            [true_control,~] =  swingUpTrajectory(p,x1(:,k));
            agg_x = [agg_x; x1(:,k)']; agg_y = [agg_y; true_control(1).eval(0)];

            xdot = p.dynamics(0,x1(:,k),control);
            xnew = x1(:,k) + xdot*dt;
            q = xnew(1:2,:);
            qd = xnew(3:4,:);
            q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
            q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));

            x1(:,k+1)=[q;qd];
        end
        controller = TreeBagger(50,agg_x,agg_y,'Method','regression');
    end
        
    
    for k=1:N-1
        control =  max(min(controller.predict(x1(:,k)'),20),-20);
        control
        xdot = p.dynamics(0,x1(:,k),control);
        xnew = x1(:,k) + xdot*dt;
        q = xnew(1:2,:);
        qd = xnew(3:4,:);
        q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
        q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));

        x1(:,k+1)=[q;qd];
    end


    xtraj = PPTrajectory(foh(t,x1));
    xtraj = xtraj.setOutputFrame(p.getStateFrame);
    v.playback(xtraj) % dont play it yet...    
end