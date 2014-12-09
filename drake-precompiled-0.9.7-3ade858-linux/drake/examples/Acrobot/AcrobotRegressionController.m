classdef AcrobotRegressionController < DrakeSystem
  properties
    policy
    p
  end
  methods
    function obj = AcrobotRegressionController(plant,pi)
      obj = obj@DrakeSystem(0,0,4,1,true,true);
      obj.p = plant;
      obj.policy = pi;
      obj = obj.setInputFrame(plant.getStateFrame);
      obj = obj.setOutputFrame(plant.getInputFrame);
    end
    
    function u = output(obj,t,~,x)
        q = x(1:2);
        qd = x(3:4);

        % unwrap angles q(1) to [0,2pi] and q(2) to [-pi,pi]
        q(1) = q(1) - 2*pi*floor(q(1)/(2*pi));
        q(2) = q(2) - 2*pi*floor((q(2) + pi)/(2*pi));
        x= [q;qd];
        
        u = obj.policy.predict(x');
    
        % leave this line below, it limits the control input to [-20,20]
        u = max(min(u,20),-20);    
    end
  end
  
  methods (Static)
    function [t,x,x_grade,cost_incurred]=run( policyParam )
      plant = PlanarRigidBodyManipulator('Acrobot.urdf');
      
      if (nargin < 1)
        controller = AcrobotController(plant);
      else
        controller = AcrobotController(plant,policyParam);
      end
      
      v = plant.constructVisualizer;
      sys_closedloop = feedback(plant,controller);
      
%      x0 = [0.1*(rand(4,1) - 1)]; % start near the downward position
%     x0 = [pi - .1*randn;0;0;0];  % start near the upright position
      x0 = [0 0 0 0]';
      xtraj=simulate(sys_closedloop,[0 10],x0);
      v.axis = [-4 4 -4 4];
      playback(v,xtraj);
      
      
      t = xtraj.pp.breaks;
      x = xtraj.eval(t);
      t_grade = linspace(3,4,98);
      x_grade = [xtraj.eval(0) xtraj.eval(t_grade) xtraj.eval(10)];
      x_grade = x_grade';
      
      x_cost = x;
      x_cost(1,:) = x_cost(1,:) - 2*pi*floor(x_cost(1,:)/(2*pi));
      x_cost(2,:) = x_cost(2,:) - 2*pi*floor(x_cost(2,:)/(2*pi));
      xbar = bsxfun(@minus,x_cost,[pi 0 0 0]');
      cost_incurred = sum(diag(xbar'*xbar)) / size(x,2);
    end
  end
end
