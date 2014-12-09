classdef AcrobotController < DrakeSystem
  properties
    policy
    p
  end
  methods
    function obj = AcrobotController(plant,policyParam)
      obj = obj@DrakeSystem(0,0,4,1,true,true);
      obj.p = plant;
      if (nargin == 2)
        obj.policy = policyParam;
      end
      obj = obj.setInputFrame(plant.getStateFrame);
      obj = obj.setOutputFrame(plant.getInputFrame);
    end
    
    function u = output(obj,t,~,x)
        u=-20;
        return;
      q = x(1:2);
      qd = x(3:4);
      
      % unwrap angles q(1) to [0,2pi] and q(2) to [-pi,pi]
      q(1) = q(1) - 2*pi*floor(q(1)/(2*pi));
      q(2) = q(2) - 2*pi*floor((q(2) + pi)/(2*pi));

      %%%% put your controler here %%%%
      % You might find some of the following functions useful
%       [H,C,B] = obj.p.manipulatorDynamics(q,qd);
%       com_position = obj.p.getCOM(q);
%       mass = obj.p.getMass();
%       gravity = obj.p.gravity;
      % Recall that the kinetic energy for a manpulator given by .5*qd'*H*qd
      
      
%       For the first question      
       k =  [-615.2989 -249.8877 -266.0147 -124.0688];
       S =   1.0e+04 * [8.2704    3.5671    3.5701    1.7737;
    3.5671    1.5464    1.5410    0.7659;
    3.5701    1.5410    1.5424    0.7663;
    1.7737    0.7659    0.7663    0.3808];
    
    x0 = [pi 0 0 0]';
    xbar = [q;qd] - x0;
    uLQR = -k*(xbar);
    if ~isempty(obj.policy)
        u = obj.policy*[q;qd];
    else
        u = uLQR;
    end
    u = uLQR;
%     costToGo = xbar'*S*xbar;
%    u=uLQR;
%     if costToGo < Inf
%         u = uLQR;
%     else
%         k2=6;
%         k3=3;
%         invH = inv(H);
%         a2 = invH(1,2);
%         a3 = invH(2,2);
% 
%         up = (-k2*q(2) - k3*qd(2) + a2*C(1) + a3*C(2))/a3;
% 
%         Ek = 0.5*qd'*H*qd;
%         Ep = -mass*gravity(3)*com_position(2);
%         totE = Ek+Ep;
% 
%         uprightCOM = obj.p.getCOM([pi 0 0 0]'); 
%         uprightCOM = uprightCOM(2);
%         Ed = -mass*gravity(3)*uprightCOM;
% 
%         k1 = 10;
%         ue = k1*(Ed - totE)*qd(2);
% 
%         u = ue + up;
%     end
    %%%% end of your controller %%%%   
    
    
    % leave this line below, it limits the control input to [-20,20]
    u = max(min(u,20),-20);
    % This is the end of the functionar all
    
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
