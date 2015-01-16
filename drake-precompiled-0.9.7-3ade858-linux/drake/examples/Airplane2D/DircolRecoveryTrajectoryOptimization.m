classdef DircolRecoveryTrajectoryOptimization < DircolTrajectoryOptimization
  % Direct colocation approach
  % Over each interval, f(x(k),u(k)) and f(x(k+1),u(k+1)) are evaluated to
  % determine d/dt x(k) and d/dt x(k+1). A cubic spline is fit over the
  % interval x and d/dt x at the end points.
  % x(k+.5) and d/dt x(k+.5) are determined based on this spline.
  % Then, the dynamics constraint is:
  % d/dt x(k+.5) = f(x(k+.5),.5*u(k) + .5*u(k+1))
  %
  %  integrated cost is: .5*h(1)*g(x(1),u(1)) + .5*h(N-1)*g(x(N),u(N)) +
  %                   sum((.5*h(i)+.5*h(i-1))*g(x(i),u(i))
  %  more simply stated, integrated as a zoh with half of each time
  %  interval on either side of the knot point
  % this might be the wrong thing for the cost function...
  properties
      xhat_inds;
      xhat_x0_dist_inds;
      xhat_xg_dist_inds;
      xg_xhat;
  end
  
  methods
    function obj = DircolRecoveryTrajectoryOptimization(plant,N,duration,varargin)
      obj = obj@DircolTrajectoryOptimization(plant,N,duration,varargin{:});
      
      nH = N-1;
      nX = obj.plant.getNumStates();
      nU = obj.plant.getNumInputs();
      
      obj.xhat_x0_dist_inds = reshape(nH + nX*N + nU*N + 1,1,1);
      obj.xhat_xg_dist_inds = reshape(nH + nX*N + nU*N + 1 + 1,1,1);
      
      new_name{1} = 'xhat_x0_dist_inds';
      new_name{2} = 'xhat_xg_dist_inds';

      obj = obj.addDecisionVariable(2,new_name);
      obj = obj.addConstraint(BoundingBoxConstraint(0,inf),obj.xhat_x0_dist_inds);
      obj = obj.addConstraint(BoundingBoxConstraint(0,inf),obj.xhat_xg_dist_inds);
            
      % add xhat xg distance nonlinear constraint
      n_vars = nX + 1;
      dist_inds{1} = {obj.x_inds(:,end);obj.xhat_xg_dist_inds};
      cnstr = FunctionHandleConstraint(ones(1,1)*-Inf,zeros(1,1),n_vars,@obj.xhat_xg_dist_fcn);
      obj = obj.addConstraint(cnstr,dist_inds{1});
      
      % add xhat x0 distance nonlinear constraint
      n_vars = nX + nX + 1;
      dist_inds{1} = {obj.x_inds(:,end);obj.x_inds(:,1);obj.xhat_x0_dist_inds};
      cnstr = FunctionHandleConstraint(ones(1,1)*-Inf,zeros(1,1),n_vars,@obj.xhat_x0_dist_fcn);
      obj = obj.addConstraint(cnstr,dist_inds{1});
      
      % add xhat to be on reference traj constraint - postponed
        
      % add distances to the cost
%       dist_cost_x0 =  FunctionHandleObjective(2*nX,@(xhat,x0) obj.distance_cost_fcn_x0(xhat,x0));
      dist_cost_x0 =  FunctionHandleObjective( 1, @(xhat_x0_dist) obj.distance_cost_fcn_x0(xhat_x0_dist) );
      obj = obj.addCost(dist_cost_x0,{obj.xhat_x0_dist_inds});
%       
%       dist_cost_xg =  FunctionHandleObjective(nX,@(xhat) obj.distance_cost_fcn_xg(xhat));
      dist_cost_xg =  FunctionHandleObjective( 1, @(xhat_xg_dist) obj.distance_cost_fcn_xg(xhat_xg_dist) );
      obj = obj.addCost(dist_cost_xg,{obj.xhat_xg_dist_inds});
    end
    
%     function [f,df] = distance_cost_fcn_x0(obj,xhat,x0)
%         f = 1/2*(xhat-x0)'*eye(4)*(xhat-x0) ;
%         df = [(eye(4,4))*(xhat-x0); eye(4,4)*(xhat-x0)*-1]';
%     end
% 
%    function [f,df] = distance_cost_fcn_xg(obj,xhat)
%         xg = [5;9;0;0];
%         f = 1/2*(xhat-xg)'*eye(4)*(xhat-xg);
%         df = [(eye(4,4))*(xhat-xg);]';
%    end
    
    
   function [f,df] = distance_cost_fcn_x0(obj,xhat_x0_dist)
          f = xhat_x0_dist;
        df =1;
       end
    
   function [f,df] = distance_cost_fcn_xg(obj,xhat_xg_dist)
        f = xhat_xg_dist;
        df =1;
   end
   
   function [f,df] = xhat_xg_dist_fcn(obj,xhat,xhat_xg_dist)
        xg = [5;9;0;0];
        f = 1/2*(xhat-xg)'*eye(4)*(xhat-xg) - xhat_xg_dist;
        df = [(eye(4,4))*(xhat-xg); 1]';
   end
    
   function [f,df] = xhat_x0_dist_fcn(obj,xhat,x0,xhat_x0_dist)
        f = 1/2*(xhat-x0)'*eye(4)*(xhat-x0) - xhat_x0_dist;
        df = [(eye(4,4))*(xhat-x0); eye(4,4)*(xhat-x0)*-1; 1]';
   end
    
    
   
  end
end