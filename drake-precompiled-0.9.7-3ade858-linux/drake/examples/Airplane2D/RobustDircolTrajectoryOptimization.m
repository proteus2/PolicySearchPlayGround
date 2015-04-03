classdef RobustDircolTrajectoryOptimization < NonlinearProgram
  % Given a set of alpha samples (parameter models) and the list of
  % programs, produce the trajectory that is good for average alpha value.

  properties (SetAccess = protected)
        N;
        prog_list;
        n_samples;
        h_inds;
        x_inds;
        u_inds;
        plant_list;
  end

  methods
    function obj = RobustDircolTrajectoryOptimization(prog_list,alpha_list)
        obj = obj@NonlinearProgram(0);
        obj.prog_list = prog_list;
        obj.n_samples = size(prog_list,1);
        
        num_vars = 0;
        num_lcon = 0;
        num_shared_data = 0;

        % Adding decision variables, nonlinear constraints, and costs for
        % each sample
        % prog_idx.e.: J(\tau) = \sum_{prog_idx=1}^{n_alpha}J(\tau_i;alpha_i) 
        %                   s.t. xdot = f(x,u;alpha_i) \forall alpha_i
        obj.plant_list = cell(obj.n_samples,1);
        for prog_idx=1:obj.n_samples
            obj.plant_list{prog_idx} = PlanePlant(alpha_list(prog_idx));
            x_name = strcat('sample_',num2str(prog_idx),'_',prog_list{prog_idx}.x_name);
            obj = obj.addDecisionVariable(prog_list{prog_idx}.num_vars,x_name);
            
            
            for j = 1:length(prog_list{prog_idx}.shared_data_functions)
                shared_data_xind = prog_list{prog_idx}.shared_data_xind_cell{j};
                for k = 1:length(shared_data_xind)
                  shared_data_xind{k} = shared_data_xind{k}+num_vars;
                end
                obj = obj.addSharedDataFunction(prog_list{prog_idx}.shared_data_functions{j},shared_data_xind);
            end  
          
            for con_idx=1:numel(prog_list{prog_idx}.nlcon)
                obj = obj.addNonlinearConstraint(... 
                                prog_list{prog_idx}.nlcon{con_idx},...
                                cellfun(@(x) x + num_vars, prog_list{prog_idx}.nlcon_xind{con_idx}, ...
                                'UniformOutput', false),...
                                prog_list{prog_idx}.nlcon_dataind{con_idx}+num_shared_data);
            end
            
            for cost_idx = 1:numel(prog_list{prog_idx}.cost)
                obj = obj.addCost(prog_list{prog_idx}.cost{cost_idx}, cellfun(@(x) x + num_vars, ...
                                 prog_list{prog_idx}.cost_xind_cell{cost_idx}, 'UniformOutput', false),...
                                 prog_list{prog_idx}.cost_dataind{cost_idx}+num_shared_data);
            end

            num_vars = num_vars + prog_list{prog_idx}.num_vars;
            num_lcon = num_lcon + size(prog_list{prog_idx}.Ain, 1) + size(prog_list{prog_idx}.Aeq, 1);
            num_shared_data = num_shared_data+length(prog_list{prog_idx}.shared_data_functions);
        end
        
        % setting up the linear constraints
        A = zeros(num_lcon, num_vars);
        lb = -inf(num_lcon, 1);
        ub = inf(num_lcon, 1);
        x_lb = -inf(num_vars, 1);
        x_ub = inf(num_vars, 1);
        nq = size(prog_list{1}.x_inds,1); % same as dimension of states
        nu = size(prog_list{1}.u_inds,1);
        nh = size(prog_list{1}.h_inds,1);
        obj.N = prog_list{1}.N;
        
        % contraints for having trajectories to be equal across
        % different samples. Only constrains h,q, and v.
        A_tau = zeros((nh+(nq+nu)*obj.N)*(obj.n_samples-1),num_vars);
        b_tau = zeros((nh+(nq+nu)*obj.N)*(obj.n_samples-1),1);

        % Combining linear constraints, including all tau's being equal.
        num_vars = 0;
        num_lcon = 0;
        obj.h_inds = [];
        obj.x_inds = [];
        obj.u_inds = [];
        for prog_idx=1:obj.n_samples
            vars_range = num_vars + 1 : num_vars + prog_list{prog_idx}.num_vars;
            lcon_range = num_lcon + 1 : num_lcon + size(prog_list{prog_idx}.Ain, 1) + size(prog_list{prog_idx}.Aeq,1);
            A(lcon_range,vars_range) = [prog_list{prog_idx}.Ain; prog_list{prog_idx}.Aeq];
            lb(lcon_range,1) = [-inf*ones(size(prog_list{prog_idx}.bin)); prog_list{prog_idx}.beq];
            ub(lcon_range,1) = [prog_list{prog_idx}.bin; prog_list{prog_idx}.beq];

            x_lb(vars_range,1) = prog_list{prog_idx}.x_lb;
            x_ub(vars_range,1) = prog_list{prog_idx}.x_ub;

            %extract indicies of hinds, xinds, and uinds. save them.
            obj.h_inds = [obj.h_inds; prog_list{prog_idx}.h_inds(:)+(prog_idx-1)*prog_list{1}.num_vars];
            obj.x_inds = [obj.x_inds; prog_list{prog_idx}.x_inds(:)+(prog_idx-1)*prog_list{1}.num_vars];
            obj.u_inds = [obj.u_inds; prog_list{prog_idx}.u_inds(:)+(prog_idx-1)*prog_list{1}.num_vars];

            if prog_idx > 1
                % get hqv_index of prog_idx-1th sample to index into num_vars
                 num_vars_per_sample = nh + (nq+nu)* obj.N;                                          % number of decision variables per sample                              
%                 node_range = num_vars_per_sample * (prog_idx-2) + (1:num_vars_per_sample);      % node_range = index into the ith sample's decision variables
%                 hxu_index = [prog_list{prog_idx-1}.h_inds(:); ...                                  % get the h, q, and v indicies for prog_idx-1th sample
%                              prog_list{prog_idx-1}.x_inds(:); ...    
%                              prog_list{prog_idx-1}.u_inds(:)];                                      
%                 hxu_index = (prog_idx-2)*prog_list{1}.num_vars + hxu_index;                     % account for offset. NOTE: if each planner has diff number of num_vars, this would not work
%                 A_tau(node_range, hxu_index) = eye(num_vars_per_sample);                         
                
                % setting u's across different trajectories are the same
                node_range = num_vars_per_sample*(prog_idx-2) + prog_list{prog_idx}.u_inds(:);
                u_idx = prog_list{prog_idx}.u_inds(:);
                u_idx = (prog_idx-2)*num_vars_per_sample + u_idx;
                A_tau(node_range, u_idx) = eye(nu*obj.N);                         


                % get hqv_index of ith sampel to index into num_vars
%                 hxu_index = [prog_list{prog_idx}.h_inds(:); ...
%                              prog_list{prog_idx}.x_inds(:); ...
%                              prog_list{prog_idx}.u_inds(:)];
%                 hxu_index = (prog_idx-1)*prog_list{1}.num_vars + hxu_index;                           
%                 A_tau(node_range, hxu_index) = -eye(num_vars_per_sample);       
                u_idx = prog_list{prog_idx}.u_inds(:);
                u_idx = (prog_idx-1)*num_vars_per_sample + u_idx;
                A_tau(node_range, u_idx) = -eye(nu*obj.N);        
                
                % setting h's across different trajectories are the same
                node_range = num_vars_per_sample*(prog_idx-2) + prog_list{prog_idx}.h_inds(:);
%                 h_idx = prog_list{prog_idx}.h_inds(:);
%                 h_idx = (prog_idx-2)*num_vars_per_sample + h_idx;
%                 A_tau(node_range, h_idx) = eye(nh);          
%                 
%                 h_idx = prog_list{prog_idx}.h_inds(:);
%                 h_idx = (prog_idx-1)*num_vars_per_sample + h_idx;
%                 A_tau(node_range, h_idx) = -eye(nh);

                %figure; imagesc(A_tau)
            end
            
            num_vars = num_vars + prog_list{prog_idx}.num_vars;
            num_lcon = num_lcon + size(prog_list{prog_idx}.Ain,1) + size(prog_list{prog_idx}.Aeq,1);
        end
        
        % Readds all the linear constraints of the sub-problems as one big
        % linear constraint
        obj = obj.addLinearConstraint(LinearConstraint(lb, ub, A));

        % The lower and upper bounds of x given to us by the each planner
        obj = obj.addBoundingBoxConstraint(BoundingBoxConstraint(x_lb,x_ub));

        % Constrains all the trajectories to have the same trajectory
        obj = obj.addLinearConstraint(LinearConstraint(b_tau,b_tau,A_tau));

    end
    
    function [utraj,xtraj_list,z,F,info,infeasible_constraint_name] = solveTraj(obj,t_init,traj_init)
        % Solve the nonlinear program and return resulting trajectory
        % @param t_init initial timespan for solution.  can be a vector of
        % length obj.N specifying the times of each segment, or a scalar
        % indicating the final time.
        % @param traj_init (optional) a structure containing Trajectory
        % objects specifying the initial guess for the system inputs
        %    traj_init.u , traj_init.x, ...
        % @default small random numbers

        if nargin<3, traj_init = struct(); end
        z0 = obj.getInitialVars(t_init,traj_init);
        [z,F,info,infeasible_constraint_name] = obj.solve(z0);
%         xtraj = reconstructStateTrajectory(obj,z);
        if nargout>1, utraj = reconstructInputTrajectory(obj,z); end
        xtraj_list = reconstructStateTrajectory(obj,z);
    end
    
    function [utraj] = reconstructInputTrajectory(obj,z)
      % Interpolate between knot points to reconstruct a trajectory using
      % the hermite spline
      t = [0; cumsum(z(obj.h_inds(1:20)))];
      u = reshape(z(obj.u_inds(1:21)),[],obj.N);
      utraj = PPTrajectory(foh(t,u));
    end
    
    function z0 = getInitialVars(obj,t_init,traj_init)
    % evaluates the initial trajectories at the sampled times and
    % constructs the nominal z0. Overwrite to implement in a different
    % manner
    
      if isscalar(t_init)
        t_init = linspace(0,t_init,obj.N);
      elseif length(t_init) ~= obj.N
        error('The initial sample times must have the same length as property N')
      end
      z0 = zeros(obj.num_vars,1);
      
      h_init = diff(t_init)';
      h_init = repmat(h_init,obj.n_samples,1);
      z0(obj.h_inds) = h_init;

      if nargin<3, traj_init = struct(); end

      nU = 1;
      
      % set traj_init.u to all the obj.u_inds
      if isfield(traj_init,'u')
        uinit = traj_init.u.eval(t_init)';
      else
        uinit = 0.01*randn(nU,obj.N)';
      end
      uinit = repmat(uinit,obj.n_samples,1);
      z0(obj.u_inds) = uinit;

      % set traj_init.u to all the obj.u_inds
      if isfield(traj_init,'x')
        xinit = traj_init.x.eval(t_init);
        xinit = repmat(xinit(:),obj.n_samples,1);
        z0(obj.x_inds) = xinit;
      end
    end
    
     function xtraj_list = reconstructStateTrajectory(obj,z)
      % Interpolate between knot points to reconstruct a trajectory using
      % the hermite spline
      t = [0; cumsum(z(obj.h_inds(1:obj.N-1)))];
      u = reshape(z(obj.u_inds),[],obj.N);
      x = reshape(z(obj.x_inds),[],obj.N);
      
      idx2=1;
      for idx=1:obj.n_samples
          plant = obj.plant_list{idx};
          xdot = zeros(4,obj.N);
          for i=1:obj.N,
            xdot(:,i) = plant.dynamics(t(i),x(idx2:idx2+3,i),u(:,i));
          end
          xtraj = PPTrajectory(pchipDeriv(t,x(idx2:idx2+3,:),xdot));
          xtraj = xtraj.setOutputFrame(plant.getStateFrame);
          xtraj_list{idx} = xtraj;
          idx2=idx2+4;
      end
    end

  end

end
