% Implementation of iLQG. 

% Variable names conform to the notations used in Todorov ICDC 2005

function [u_bar] = iLQG()
    % Inputs: plant, initial position x0 and initial u traj u0, length of time step, and number of
    % node points N.
    % Output: u trajectory
    step_cost_fun = @(x,u) costfun(x,u);
    
    plant = PlanarRigidBodyManipulator('Acrobot.urdf');
    n=4;m=1;N=10;
    F = eye(n,m); % noise model matrix
    xinit = [0;0;0;0];
    x0 = zeros(n,N); % state trajectory
    x0(:,1) = xinit;
    u0 = zeros(m,N); % control trajectory
    cvg_crit = 100;
    
    dt = 10/N; % 10 seconds over 50 node points; 
    while cvg_crit > 0.001
        cvg_crit
        % initialize ubar and xbar by applying ubar to the system dynamics
        for k=1:N-1
            xdot = plant.dynamics(0,x0(:,k),u0(k));
            xnew = x0(:,k) + xdot*dt;
            q = xnew(1:2,:);
            qd = xnew(3:4,:);
            q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
            q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));
            
            x0(:,k+1)=[q;qd];
        end
        
      

        %% Compute linearized dynamics and quadratized costs
        % linearize the dynamics at the node points, and get A_k and B_k
        % compute c_{i,k} by looking at F^{i}
        % compute qk, qqk, rk, Qk, Rk
        % initialize sK=qK, SK=QK, ssK = qqk
        A = cell(N,1); B = cell(N,1);    q = cell(N,1);     qq = cell(N,1); r = cell(N,1); R = cell(N,1);
        for k=1:N
            [A{k},B{k}] = linearize(plant,0,x0(:,k),u0(:,k));
            x_cost_fun=@(x)costfun(x,u0(:,k));
            [q{k},qq{k},Q{k}]=fin_diff(x_cost_fun,x0(:,k));
            Q{k} = reshape(Q{k},size(Q{k},2),size(Q{k},3)); % I have a feeling that I should transpose this. I will leave it for now.
            q{k} = q{k}';
            qq{k} = qq{k}';

            u_cost_fun=@(u)costfun(x0(:,k),u);
            [~,r{k},~] = fin_diff(u_cost_fun,u0(:,k));
            R{k} = 0;
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
        alpha = 1;
        for k=fliplr(1:N-1)
            % Equation (3)
            g{k} = r{k} + B{k}'*ss{k+1} + 0; % my Cik is zero
            G{k} = B{k}'*S{k+1}*A{k};
            H{k} = R{k} + B{k}'*S{k+1}*B{k} + 0;

            L{k} = -inv(H{k})*G{k};
            I{k} = -inv(H{k})*g{k};

            % Equation (4)
            S{k} = Q{k} + A{k}'*S{k+1}*A{k} + L{k}'*H{k}*L{k} + L{k}'*G{k} + G{k}'*L{k};
            s{k} = q{k} + s{k+1} + 0 + 1/2*I{k}'*H{k}*I{k} + I{k}'*g{k};

            ss{k} = qq{k} + A{k}'*ss{k+1} + L{k}'*H{k}*I{k} + L{k}'*g{k} + G{k}'*I{k};

            % Compute the linear control law du_k = I_k + L_k*dx_k
            % I_k = -inv(H)*g, L_= -inv(H)*G
            % control trajectory, u0 = u0 + alpha*delta_u_k, where alpha is the
            % line search parameter
        end
        
        
        delta_x = zeros(n,N);
        delta_u = zeros(m,N-1); % u delta

        u = zeros(m,N-1);
        delta_u(:,1) = I{1} + L{1}*delta_x(:,1);
        u(:,1) = u0(:,1) + delta_u(:,1);
        alpha = 0.1;
        for k=2:N-1
            % forward pass - delta x at he first step is always zero.
            delta_x(:,k) = (A{k}'*delta_x(:,k-1) + B{k}*delta_u(:,k-1));
            
            q = delta_x(1:2,k);
            qd = delta_x(3:4,k);
            q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
            q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));
            delta_x(:,k) = [q;qd];
          
            
            delta_u(:,k) = I{k} + L{k}*delta_x(:,k); % this is wrong. I should have delta x, not x0, the trajectory;
            u(:,k) = u0(:,k) + delta_u(:,k);
            u(:,k) = max(min(u(:,k),20),-20);
        end
        u = [u zeros(m,1)] 
        cvg_crit = sum(abs(u-u0));
        u0=u;
    end
       
end

function deriv = fin_diff_u(fun,x,u)
    h = 0.00001; 
    y=fun(x,u);
    state_dim = size(u,1);
    deriv = zeros(state_dim,1);
    
    for idx=1:state_dim
        uh = u; uh(idx)= uh(idx)+h;
        yh = fun(x,uh);
        deriv(idx) = (yh - y) / h;
    end
    
end

function deriv = fin_diff_x(fun,x,u)
    h = 0.00001; 
    y=fun(x,u);
    state_dim = size(x,1);
    deriv = zeros(state_dim,1);
    
    for idx=1:state_dim
        xh = x; xh(idx)= xh(idx)+h;
        yh = fun(xh,u);
        deriv(idx) = (yh - y) / h;
    end
    
end

function c = costfun(x,u) 
    x_goal = [pi 0 0 0]';
    Q = eye(4,4);
    c  = repmat(diag( bsxfun(@minus,x_goal,x)'*Q*bsxfun(@minus,x_goal,x) )',1,size(u,2));    % replicate the same amount for different u's. For the future, implement u dependent cost function and fix this.
end
