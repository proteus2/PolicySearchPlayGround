classdef CheatedDircolTrajectoryOptimization < DircolTrajectoryOptimization
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

  end
  
  methods
    function obj = CheatedDircolTrajectoryOptimization(plant,N,duration,varargin)
      obj = obj@DircolTrajectoryOptimization(plant,N,duration,varargin{:});
      
      nH = N-1;
      nX = obj.plant.getNumStates();
      nU = obj.plant.getNumInputs();
      
      % add xhat xg distance nonlinear constraint
      n_vars = nX*21;
      x_inds{1} = reshape(obj.x_inds(:,:),n_vars,1);
      cnstr = FunctionHandleConstraint(zeros(1,1),zeros(1,1),n_vars,@obj.subgoal_con_fcn);
      cnstr = setName(cnstr,'x_subgoal');
      obj = obj.addConstraint(cnstr,x_inds{1});
    end
    
   function [f,df] = subgoal_con_fcn(obj,x_inds)
        f = prod_sum_to_sg(obj,x_inds);
        df = zeros(size(x_inds,1),1);
        
        % compute numerical derivative
        h = 0.0000000000001;
        for idx=1:size(x_inds,1)
            x_plus_h = x_inds;
            x_plus_h(idx)=x_plus_h(idx)+h;
            df(idx) = (prod_sum_to_sg(obj,x_plus_h)-f)/h;
        end
    end
   
   function f = prod_sum_to_sg(obj,x)
        x_sg = [3.7;4.5;0;0];
        x = reshape(x,4,21);
        dists = bsxfun(@minus,x_sg,x).^2;
        dists = sum(dists,1);
        f = 1/2*prod(dists);
   end
    
  end
end