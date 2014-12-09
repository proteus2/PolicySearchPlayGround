% Implementation of iLQG. 

% Variable names conform to the notations used in Todorov ICDC 2005

function [x0,u0] = iLQG_BK(xinit,time,N)
    % Inputs: plant, initial position x0 and initial u traj u0, length of time step, and number of
    % node points N.
    % Output: u trajectory
   % step_cost_fun = @(x,u) costfun(x,u);
    
    plant = PlanarRigidBodyManipulator('Acrobot.urdf');
    n=4;m=1;
    F = eye(n,m); % noise model matrix
    x0 = zeros(n,N); % state trajectory
    x0(:,1) = xinit;
    u0 = zeros(m,N)+20; % control trajectory
 %   u0(1,1:end/2) = 20;
   % u0(1,end/2+1:end)=-20;
    cvg_crit = 100;
    
    dt = time/N; 
    n_iter = 1;
    while cvg_crit > 10
        % initialize ubar and xbar by applying ubar to the system dynamics
%         for k=1:N-1
%             xdot = plant.dynamics(0,x0(:,k),u0(k));
%             xnew = x0(:,k) + xdot*dt;
%             q = xnew(1:2,:);
%             qd = xnew(3:4,:);
%             q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
%             q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));
%             
%             x0(:,k+1)=[q;qd];
%         end      
        x0 = roll_out(plant,xinit,u0,dt);

        %% Compute linearized dynamics and quadratized costs
        % linearize $the dynamics at the node points, and get A_k and B_k
        % compute c_{i,k} by looking at F^{i}
        % compute qk, qqk, rk, Qk, Rk
        % initialize sK=qK, SK=QK, ssK = qqk
        A = cell(N,1); B = cell(N,1);    
        q = cell(N,1); qq = cell(N,1); Q = cell(N,1); 
        r = cell(N,1); R = cell(N,1);
        for k=1:N
            [A{k},B{k}] = linearize(plant,0,x0(:,k),u0(:,k));
            A{k} = eye(size(A{k})) + A{k}*dt; B{k}=B{k}*dt;
            
            % Gradient is wrong for qq. It should return
            % 1/2*(Q+Q')*delta_x(:,k), but it is currently returning
            % 1/2*(Q+Q')*x0(:,k)
            x_cost_fun=@(x)costfun(x,u0(:,k));
%             [q{k},qq{k},Q{k}]=fin_diff(x_cost_fun,x0(:,k),2^-17);
%             Q{k} = dt*reshape(Q{k},size(Q{k},2),size(Q{k},3)); % I have a feeling that I should transpose this. I will leave it for now because Q's are symmetric.
%             q{k} = dt*q{k}';
%             qq{k} = dt*qq{k}';
            
            [q{k},qq{k},Q{k}] = fin_diff_state(x_cost_fun,x0(:,k));
            Q{k} = dt*Q{k};
            q{k} = dt*q{k};
            qq{k} = dt*qq{k};
            
            %xh = repmat(x0(:,k),1,4) + eye(4,4)*2^-17;
            %diffn = bsxfun(@minus,x_cost_fun(x0(:,k)),x_cost_fun(xh))./-2^-17;
            %qq{k}=diffn';
            %qq{k}
            
            u_cost_fun=@(u)costfun(x0(:,k),u);
            [~,r{k},R{k}] = fin_diff_control(u_cost_fun,u0(:,k));
            %[~,r{k},~] = fin_diff(u_cost_fun,u0(:,k));
            r{k}=dt*r{k};
            R{k} =dt*R{k};
            %R{k} = 0;
        end
        
        %% Compute the value function at each node, backward pass.
        % compute g, G, and H using equation (3)
        % compute Sk ssk, sk using equation (4)
        % initialize sK=qK, SK=QK, ssK = qqk
        s = cell(N,1); S = cell(N,1); ss = cell(N,1); H = cell(N-1,1); 
        g = cell(N-1,1); G = cell(N-1,1); L = cell(N-1,1); I = cell(N-1,1);

        S{end} = Q{end};
        s{end} = q{end};
        ss{end} = qq{end};

        for k=fliplr(1:N-1)
            % Equation (3)
            g{k} = r{k} + B{k}'*ss{k+1} + 0; % my Cik is zero
            G{k} = B{k}'*S{k+1}*A{k};
            H{k} = R{k} + B{k}'*S{k+1}*B{k} + 0;

            L{k} = -1/(H{k})*G{k};
            I{k} = -1/(H{k})*g{k};

            % Equation (4)
            S{k} = Q{k} + A{k}'*S{k+1}*A{k} + L{k}'*H{k}*L{k} + L{k}'*G{k} + G{k}'*L{k};
            %Q{k} + A{k}'*S{k+1}*A{k} - G{k}'*inv(H{k})*G{k}
            
            ss{k} = qq{k} + A{k}'*ss{k+1} + L{k}'*H{k}*I{k} + L{k}'*g{k} + G{k}'*I{k};
            %qq{k} + A{k}'*ss{k+1} - G{k}'*inv(H{k})*g{k}
            
            s{k} = q{k} + s{k+1} + 0 + 1/2*I{k}'*H{k}*I{k} + I{k}'*g{k}  ;  
            %q{k} + s{k+1} - 1/2*g{k}'*inv(H{k})*g{k}
        end
        
        
        %% Forward pass
        curr_cost = Inf; 
        prev_cost = Inf;
        % perform line search
        alpha_list = [1.1.^-((0:100).^2) 0];
        %alpha_list = 1/n_iter;
        %alpha_list = [alpha_list 0];
        for alpha = alpha_list
            delta_x = zeros(n,N);
            delta_u = zeros(m,N-1); % u delta

            u = zeros(m,N-1);
            delta_u(:,1) = alpha*I{1} + L{1}*delta_x(:,1);
            u(:,1) = max(min(u0(:,1) + delta_u(:,1),20),-20);
            for k=2:N-1
                % forward pass - delta x at he first step is always zero.
                delta_x(:,k) = A{k-1}*delta_x(:,k-1) + B{k-1}*delta_u(:,k-1);

%                 q = delta_x(1:2,k);
%                 qd = delta_x(3:4,k);
%                 q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
%                 q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));
%                 delta_x(:,k) = [q;qd];

                delta_u(:,k) = alpha*(I{k}) + L{k}*delta_x(:,k); 
                u(:,k) = u0(:,k) + delta_u(:,k);
                u(:,k) = max(min(u(:,k),20),-20);
            end
            [curr_cost,tape]= eval_traj(plant,xinit,u,dt);
            if curr_cost < prev_cost
                prev_cost=curr_cost
                best_u=u;
                alpha
            end
            
        end
        
        u = [best_u 0];%[u zeros(m,1)] ;
        cvg_crit = sum(abs(u-u0))
        u0=u;
        n_iter = n_iter +1;
        %prev_cost = curr_cost
        %alpha
    end
    
    x0 = roll_out(plant,xinit,u0,dt);
end

function x_traj = roll_out(plant,x0,u,dt)
    N=size(u,2);
    x_traj = zeros(size(x0,1),N);
    x_traj(:,1)=x0;
    
    for k=1:N-1
        xdot = plant.dynamics(0,x_traj(:,k),u(k));
        xnew = x_traj(:,k) + xdot*dt;
        q = xnew(1:2,:);
        qd = xnew(3:4,:);
        q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
        q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));
        x_traj(:,k+1)=[q;qd];
    end      
 
end

function [cost,tape] = eval_traj(p,x0,u,dt)
    u=[u 0];
    tape = roll_out(p,x0,u,dt);    
    cost = costfun(tape,u); %cost(end);
    cost = mean(cost);
end

function c = costfun(x,u) 
    x_goal = [pi 0 0 0]';
    Q = eye(4,4);
    Q(1,1) = 10;
    Q(2,2) = 10;
    R = 10;
    
    xerr = bsxfun(@minus,x_goal,x);
    xerr(1,:) = mod(xerr(1,:)+pi,2*pi)-pi;
    xerr(2,:) = mod(xerr(2,:)+pi,2*pi)-pi;
    
    state_cost = diag( xerr'*Q*xerr )';
    control_cost = u.*R.*u;
    state_cost = repmat(state_cost,1,size(u,2));
    control_cost = repmat(control_cost,1,size(x,2));
    
    c = (state_cost+control_cost);
    %c  = 1/2*repmat(diag( xerr'*Q*xerr )',1,size(u,2));    % replicate the same amount for different u's. For the future, implement u dependent cost function and fix this.
end
