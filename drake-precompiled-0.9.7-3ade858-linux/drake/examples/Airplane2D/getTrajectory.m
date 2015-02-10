function [utraj,xtraj,F]=getTrajectory(x0,alpha,visualize,xf,tf,xinit,uinit,F_limit)
    if nargin < 2
        p = PlanePlant();
    else
        p = PlanePlant(alpha);
    end
        

   % x0 = [3.9; 0; 0; 0]; 
    
   % x0=[0;0;0;0];
   
    if ~exist('xf','var')
        xf = [5; 9; 0; 0];
    end
    if ~exist('tf','var')
        tf0 = 0.5;
    else
        tf0=tf;
    end

    N = 21;
    prog = DircolTrajectoryOptimization(p,N,[0 3]);

    prog = addStateConstraint(prog,ConstantConstraint(x0),1);
    
    const = BoundingBoxConstraint(xf-[0.01;0.01;0;0],xf+[0.01;0.01;0;0]);
%     prog = addStateConstraint(prog,ConstantConstraint(xf),N);
    prog = addStateConstraint(prog,const,N);
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
    prog = setSolverOptions(prog,'snopt', 'majoriterationslimit', 30);

    
    info=11;
    
    disp_msg = strcat('Solving for x,y=', num2str(x0(1)),',',num2str(x0(2)));
    disp(disp_msg);
    max_num_retries = 5;
    n_retries = 0;
    if exist('uinit','var')
        initial_guess.u = uinit;
    else
        initial_guess.u = PPTrajectory(foh([0,tf0],[0,0]));
        initial_guess.u = setOutputFrame(initial_guess.u,getInputFrame(p));
    end
    F=Inf;
    
    if exist('xinit','var')
        x_initial_guess = xinit;
    else 
        x_initial_guess = PPTrajectory(foh([0,tf0],[x0,xf]+[zeros(4,1) zeros(4,1)] ));
%                         delta_x = 1*cos(x0(3));
%                 delta_y = 1*sin(x0(3));
%                 x_initial_guess = PPTrajectory(foh([0,tf0/2,tf0],[x0,[x0(1)-delta_x;x0(2)+delta_y;x0(3);x0(4)],xf]+[zeros(4,1) rand(4,1) zeros(4,1)] ));

    end

    if ~exist('F_limit','var')
        F_limit = -Inf;
    end
    
    traj_list = cell(0,2);
    F_list =[];
    
    while (info==11 || info == 13 || info ==42 || info ==41||info==3 || F>F_limit) && (n_retries <=max_num_retries) ...
            && info ~= 1 && info~=4 && info~=5 
        
         if n_retries == 0
            initial_guess.x = x_initial_guess;
         else
%             if exist('xinit','var') && info ~= 32
%                 t = xinit.getBreaks();
%                 xinit = xinit.eval(t);initial_guess.x
%                 uinit = uinit.eval(t);
%                 
%                 xinit = xinit+rand(4,N);
%                 uinit = uinit+rand(1,N);
%                 
%                 xinit = PPTrajectory(foh(t,xinit));
%                 uinit = PPTrajectory(foh(t,uinit));
%                 
%                 initial_guess.x = xinit;
%                 initial_guess.u = uinit;
%             else
            
            if x0(2) <2 && xf(2) >8 
                seed = rand(1);
                randx= -1*seed+10*(1-seed);
                randy = 5.1*seed+7*(1-seed);
                initial_guess.x = PPTrajectory(foh([0,tf0/2,tf0],[x0,[randx;randy;0;0],xf]+[zeros(4,1) rand(4,1) zeros(4,1)] ));
                initial_guess.u = PPTrajectory(foh([0,tf0],[0.01,0.01]+rand(1,2)));
                initial_guess.u = setOutputFrame(initial_guess.u,getInputFrame(p));
            else
               initial_guess.u = PPTrajectory(foh([0,tf0],[0,0]));
                initial_guess.u = setOutputFrame(initial_guess.u,getInputFrame(p));     
                magnitude =norm(x0(1:2)-xf(1:2))/(2);
                delta_x = abs(magnitude*sin(x0(3)));
                delta_y = abs(magnitude*cos(x0(3)));
                
                theta= x0(3);
                while theta < 0
                    theta = theta + 2*pi;
                end
                if theta > pi
                    sign_theta = 1;
                else
                    sign_theta = -1;
                end
                
                percent_add = rand(1,1);
                percent_add = 2*percent_add + (1-percent_add)*0.5;
                delta_x = percent_add*delta_x;
                delta_y =percent_add*delta_y;
                
                
                percent_tf0 = 0.5*tf0;
                tf0_add = rand(1);
                if tf0_add >0.5
                    percent_tf0 = percent_tf0*1;
                else 
                    percent_tf0 = percent_tf0*-1;
                end
                tf0 = tf0 +percent_tf0;
                x_mid = [x0(1)+sign_theta*delta_x; x0(2)+delta_y; x0(3); x0(4)];
                initial_guess.x = PPTrajectory(foh([0,tf0/2,tf0],[x0,x_mid,xf]));

            end
%             end
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
        min_idx=min_idx(1);
        xtraj = traj_list{min_idx,1}; utraj = traj_list{min_idx,2};
    end
    
    
%     visualizeTraj(xtraj);
end
    
    
    

      function [g,dg] = cost(dt,x,u,field)
        R = 0.0001;
        % minimize the max obstacle constraint
        [c,dc] = field.obstacleConstraint(x);
        [c,i]=max(c);
        dc = 2*dc(i,:);
        
        g = 2*c + u'*R*u;
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
