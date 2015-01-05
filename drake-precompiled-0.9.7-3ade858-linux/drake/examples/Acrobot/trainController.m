function controller = trainController()
    fname='traj_list_snopt';
    dt = 0.1;
    t =0:dt:6;
    
    load(fname);
    x=[];y=[];
    for idx=1:1
        xtraj = traj_list{idx,2};
        xtraj = xtraj.eval(t);
        utraj = traj_list{idx,1};
        utraj = utraj.eval(t);
        
        x = [x xtraj];
        y = [y utraj];
    end
    x=x';y=y';
    controller = TreeBagger(50,x,y,'Method','regression');
    
    p = AcrobotPlant;
    v = AcrobotVisualizer(p); 

    
    
    agg_x = x; agg_y = y;
    
    dt = 0.1;
    t =0:dt:6;
    N = size(t,2);
    for m=1:3
        x1=zeros(4,N);
        for k=1:N-1
            control =  max(min(controller.predict(x1(:,k)'),20),-20);
            if k==1 
                control 
            end
            [true_control,temp] =  swingUpTrajectory(p,x1(:,k));
            agg_x = [agg_x; x1(:,k)']; agg_y = [agg_y; true_control(1).eval(0)];

            xdot = p.dynamics(0,x1(:,k),control);
            xnew = x1(:,k) + xdot*dt;
%             
%             xdot2 = p.dynamics(0,x1(:,k),true_control(1).eval(0));
%             xnew2 = x1(:,k) + xdot2*dt
%             
%             xnew3 = temp.eval(t(k+1))
            
            q = xnew(1:2,:);
            qd = xnew(3:4,:);
            q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
            q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));

            x1(:,k+1)=[q;qd];
        end
        controller = TreeBagger(50,agg_x,agg_y,'Method','regression');
    end
    
    controller = TreeBagger(50,agg_x,agg_y,'Method','regression');

    dt = 0.01;
    t =0:dt:6;
    N = size(t,2);
    x1=zeros(4,N);

    for k=1:N-1
        control =  max(min(controller.predict(x1(:,k)'),20),-20)
    
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