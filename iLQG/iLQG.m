% Implementation of iLQG. 

% Variable names conform to the notations used in Todorov ICDC 2005

function [u_bar] = iLQG()
    % Inputs: plant, initial position x0 and initial u traj u0, length of time step, and number of
    % node points N.
    % Output: u trajectory
    step_cost_fun = @(x,u) costfun(x,u);
    plant = PlanarRigidBodyManipulator('Acrobot.urdf');
    n=4;m=1;N=50;
    xinit = [0;0;0;0];
    x0 = zeros(n,N);
    x0(:,1) = xinit;
    u0 = zeros(m,N);

    % initialize ubar and xbar by applying ubar to the system dynamics
    for k=2:N
        x0(:,k) = plant.dynamics(0,x0(:,k),u0(k));
    end
    
    %% Compute linearized dynamics and quadratized costs
    % linearize the dynamics at the node points, and get A_k and B_k
    % compute c_{i,k} by looking at F^{i}
    % compute qk, qqk, rk, Qk, Rk
    % initialize sK=qK, SK=QK, ssK = qqk
    A = cell(N,1); B = cell(N,1);    q = cell(N,1);     qq = cell(N,1);
    for k=1:N
        [A{k},B{k}] = linearize(plant,0,x0(:,k),u0(:,k));
        x_cost_fun=@(x)costfun(x,u(:,k));
        [q{k},qq{k},Q{k}]=fin_diff(x_cost_fun,x0(:,k));
        
        u_cost_fun=@(u)costfun(x(:,k),u);
        [~,r{k},R{k}] = fin_diff(u_cost_fun,u(:,k));
    end
    
    %% Compute the value function at each node, backwards
    % compute g, G, and H using equation (3)
    % compute Sk ssk, sk using equation (4)
    % initialize sK=qK, SK=QK, ssK = qqk
    
    %% Compute the linear control law du_k = I_k + L_k*dx_k
    % I_k = -inv(H)*g, L_= -inv(H)*G
    
    %% Apply the du_k to to the linearized system
    % obtain u_hat_k = u_bar_k + du_k
    % if norm(u_hat_k - u_bar_k) < eps, then break
    % else, u_bar_k = =u_hat_k
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
    c  = diag( bsxfun(@minus,x_goal,x)'*Q*bsxfun(@minus,x_goal,x) )';
end
