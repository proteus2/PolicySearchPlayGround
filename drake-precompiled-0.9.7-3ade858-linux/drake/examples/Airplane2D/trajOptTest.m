function [utraj,xtraj,field]=trajOptTest()
    p = PlanePlant();

    x0 = [3.9; 0; 0; 0]; 
    
   % x0=[0;0;0;0];
    xf = [5; 9; 0; 0];
    tf0 = .7;

    N = 21;
    prog = DircolTrajectoryOptimization(p,N,[0.2 3]);

    prog = addStateConstraint(prog,ConstantConstraint(x0),1);
    prog = addStateConstraint(prog,ConstantConstraint(xf),N);

    % add obstacles
    disp('Adding obstacles...');
    field = ObstacleField();
    field = field.GenerateRandomObstacles();
    prog = field.AddConstraints(prog);

    prog = addRunningCost(prog,@(dt,x,u)cost(dt,x,u,field));
    prog = addFinalCost(prog,@finalCost);

    prog = addTrajectoryDisplayFunction(prog,@(dt,x,u)plotDircolTraj(dt,x,u,[1 2]));


    figure(25); clf;  hold on;
    v = PlaneVisualizer(p,field);
    v.draw(0,x0);
    drawnow

    prog = setSolverOptions(prog,'snopt','MajorOptimalityTolerance',1e-2);
    prog = setSolverOptions(prog,'snopt', 'majoriterationslimit', 20);
    
    
    info=11;
    while (info==11 || info == 13 || info ==42 || info ==41)
        if info ==41
            initial_guess.x = PPTrajectory(foh([0,tf0],[x0,xf]+[rand(4,1)*randi(10,4,1) zeros(4,1)] ));
        else
            initial_guess.x = PPTrajectory(foh([0,tf0],[x0,xf]+[rand(4,1) zeros(4,1)] ));
        end
        tic
        [xtraj,utraj,~,~,info]=solveTraj(prog,tf0,initial_guess);
        info
        toc
    end
    
    v.playback(xtraj);
    
    % potential alpha=velocity, mass, initial and final goal states
    tf = xtraj.getBreaks; tf=tf(end);
    x1 = rungeKattaSimulation(x0,utraj,tf,p);
    v.playback(x1) % dont play it yet...    
end
    
    
    

      function [g,dg] = cost(dt,x,u,field)
        R = 0.0001;
        
        % minimize the max obstacle constraint
        [c,dc] = field.obstacleConstraint(x);
        [c,i]=max(c);
        dc = dc(i,:);
        
        g = c + u'*R*u;
        %g = sum((R*u).*u,1);
        dg = [0,dc,2*u'*R];
        
        %dg = zeros(1, 1 + size(x,1) + size(u,1));
      end
      
      function [h,dh] = finalCost(t,x)
        h = t;
        dh = [1,zeros(1,size(x,1))];
      end

      function [J,dJ]=plotDircolTraj(t,x,u,plotdims)
        figure(25);
        h=plot(x(plotdims(1),:),x(plotdims(2),:),'r.-');
        axis([-2 2 -1 10]); axis equal;
        drawnow;
        delete(h);
        J=0;
        dJ=[0*t(:);0*x(:);0*u(:)]';
      end