function [utraj,xtraj,traj_list,F]=getRobustTrajectory(x0,alpha,visualize,xf,tf,xinit,uinit,F_limit)

    if ~exist('xf','var')
        xf = [5; 9; 0; 0];
    end
    if ~exist('tf','var')
        tf0 = 0.5;
    else
        tf0=tf;
    end

    N = 21;
    
    %% setup dir col programs
    
    % for all alpha values,
    %   generate non linear programs
    % create one maste non linear program
    % for all alpha values,
    %   add decision variables from each program
    %   add constraints - make sure tau_i has dynamics_i constraint
    %   add constraints tau_1=...=tau_n
    
    n_alpha = numel(alpha);
    prog_list = cell(n_alpha,1);
    for alpha_idx = 1:n_alpha
        p = PlanePlant(alpha(alpha_idx));
        prog = DircolTrajectoryOptimization(p,N,[0 3]);
        prog = addStateConstraint(prog,ConstantConstraint(x0),1);
        const = BoundingBoxConstraint(xf-[0.01;0.01;0;0],xf+[0.01;0.01;0;0]); %make the xf constraint lenient
        prog = addStateConstraint(prog,const,N);
        field = ObstacleField();
        field = field.GenerateRandomObstacles();
        prog = field.AddConstraints(prog);
        prog = addRunningCost(prog,@(dt,x,u)cost(dt,x,u,field));
        prog = addFinalCost(prog,@finalCost);
        prog_list{alpha_idx} = prog;
    end
    
    master_prog = RobustDircolTrajectoryOptimization(prog_list,alpha);
        
   
    if visualize
        prog = addTrajectoryDisplayFunction(prog,@(dt,x,u)plotDircolTraj(dt,x,u,[1 2]));
        figure(25); clf;  hold on;
        v = PlaneVisualizer(p,field);
        v.draw(0,x0);
        drawnow
    end
 
    master_prog = setSolverOptions(master_prog,'snopt','MajorOptimalityTolerance',1e-6);
    master_prog = setSolverOptions(master_prog,'snopt', 'majoriterationslimit', 30);

    
    info=11;
    
    disp_msg = strcat('Solving for x,y=', num2str(x0(1)),',',num2str(x0(2)));
    disp(disp_msg);
    max_num_retries = 3;
    max_n_trajs_saved = 2;
    n_retries = 0;
    
    % create a list of initial guess
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
    end

    if ~exist('F_limit','var')
        F_limit = -Inf;
    end
    
    traj_list = cell(0,2);
    F_list =[];
    n_trajs_saved = 0;
   	while (info~=1 && info~=4 && info~=5) && (n_retries <=max_num_retries || n_trajs_saved<max_n_trajs_saved)
         if n_retries == 0
            initial_guess.x = x_initial_guess;
         else
            if x0(2) <2 && xf(2) >8 
                seed = rand(1);
                if x0(1)>=8 && x0(1)<10
                    randx = x0(1) - 2*seed;
                elseif x0(1) <=8 && x0(1)>7
                    randx= x0(1) -1*seed;
                else
                    randx = x0(1) +1*seed;
                end
                randy = (x0(2)+3)*seed+7*(1-seed);
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
        end
        
        [utraj_list,xtraj_list,~,F,info]=solveTraj(master_prog,tf0,initial_guess);
        info
        
        n_retries = n_retries+1
        F
        if ~(info==11 || info == 13 || info ==42 ||info==3)
           n_trajs_saved = n_trajs_saved + 1;
           traj_list{n_retries,1} = xtraj_list;
           traj_list{n_retries,2} = utraj_list;
           F_list(n_retries)=F;
        end
    end
    
    if (info==1 || info==4 || info==5)
        xtraj = traj_list{1,1};
        utraj = utraj_list;
        return
    else
        F_list(F_list==0) = Inf;
        if n_retries>= max_num_retries+1
            [~,min_idx] = min(F_list);
            min_idx=min_idx(1);
            xtraj = traj_list{min_idx,1}; utraj = traj_list{min_idx,2};
        end
    end
    min_idx
    
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
