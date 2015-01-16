function [utraj,xtraj,F]=getRecoveryTrajectory(x0,alpha,visualize,ref_traj)
    if nargin < 2
        p = PlanePlant();
    else
        p = PlanePlant(alpha);
    end
        
    if ~exist('ref_traj','var')
        load('init_traj_train_data.mat');
        ref_traj = traj_list{1,1}; ref_traj = ref_traj.eval(ref_traj.getBreaks);
    end
   % x0 = [3.9; 0; 0; 0]; 
    
   % x0=[0;0;0;0];
    
    tf0 = .2;

    N = 21;
    prog = DircolRecoveryTrajectoryOptimization(p,N,[0 3]);
    
    prog = addStateConstraint(prog,ConstantConstraint(x0),1);
%     prog = addStateConstraint(prog,ConstantConstraint(xf0),N);

    % add obstacles
    disp('Adding obstacles...');
    field = ObstacleField();
    field = field.GenerateRandomObstacles();
    prog = field.AddConstraints(prog);
    prog = addRunningCost(prog,@(dt,x,u)cost(dt,x,u,field));
    prog = addFinalCost(prog,@finalCost);
    if visualize
        prog = addTrajectoryDisplayFunction(prog,@(dt,x,u)plotDircolTraj(dt,x,u,[1 2]));
        figure(25); clf;  hold on;
        v = PlaneVisualizer(p,field);
        v.draw(0,x0);
        drawnow
    end
 
    prog = setSolverOptions(prog,'snopt','MajorOptimalityTolerance',1e-6);
    prog = setSolverOptions(prog,'snopt', 'majoriterationslimit', 50);

    
    info=11;
    
    disp_msg = strcat('Solving for x,y=', num2str(x0(1)),',',num2str(x0(2)));
    disp(disp_msg);
    max_num_retries = 5;
    n_retries = 0;
    if exist('uinit','var')
        initial_guess.u = uinit;
    else
        initial_guess.u = PPTrajectory(foh([0,tf0],[0.01,0.01]+rand(1,2)));
        initial_guess.u = setOutputFrame(initial_guess.u,getInputFrame(p));
    end
    F=Inf;
    
    xf0 = bsxfun(@minus,x0,ref_traj);
    [~,xf0] = min(sum(xf0.^2)); xf0 = ref_traj(:,xf0);
    
    if exist('xinit','var')
        x_initial_guess = xinit;
    else 
        x_initial_guess = PPTrajectory(foh([0,tf0],[x0,xf0]));
    end
    
    traj_list = cell(0,2);
    F_list =[];
    while (info==11 || info == 13 || info ==42 || info ==41||info==3 || F>-10) && (n_retries <=max_num_retries)
        
         if n_retries == 0
            initial_guess.x = x_initial_guess;
         else
            initial_guess.x = PPTrajectory(foh([0,tf0],[x0,xf0]+[rand(4,1) zeros(4,1)] ));
            initial_guess.u = PPTrajectory(foh([0,tf0],[0.01,0.01]+rand(1,2)));
            initial_guess.u = setOutputFrame(initial_guess.u,getInputFrame(p));
        end
        tic
        [xtraj,utraj,~,F,info]=solveTraj(prog,tf0,initial_guess);
        info
        toc
        n_retries = n_retries+1
        F
        traj_list{n_retries,1} = xtraj; traj_list{n_retries,2} = utraj;
        F_list = [F_list; F];
    end
    
    if n_retries == max_num_retries+1
        [~,min_idx] = min(F_list);
        xtraj = traj_list{min_idx,1}; utraj = traj_list{min_idx,2};
    end
    
%     visualizeTraj(xtraj);
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
