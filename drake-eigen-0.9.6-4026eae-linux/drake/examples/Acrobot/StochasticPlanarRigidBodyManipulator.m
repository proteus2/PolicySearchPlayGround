classdef StochasticPlanarRigidBodyManipulator < PlanarRigidBodyManipulator
    
properties
end

methods
    
    function obj = StochasticPlanarRigidBodyManipulator(urdf_filename,options)
        if (nargin<2), options = struct(); end

        obj = obj@PlanarRigidBodyManipulator(urdf_filename,options);
    end
    
     function [xdot,dxdot] = dynamics(obj,t,x,u)
    % Provides the DrakeSystem interface to the manipulatorDynamics.

      q = x(1:obj.num_positions);
      v = x(obj.num_positions+1:end);
    
      if (nargout>1)
        if (obj.num_xcon>0)
          % by naming this 'MATLAB:TooManyOutputs', geval will catch the
          % error and use TaylorVarInstead
          error('MATLAB:TooManyOutputs','User gradients for constrained dynamics not implemented yet.');
        end
        
        % Note: the next line assumes that user gradients are implemented.
        % If it fails, then it will raise the same exception that I would
        % want to raise for this method, stating that not all outputs were
        % assigned.  (since I can't write dxdot anymore)
        [H,C,B,dH,dC,dB] = obj.manipulatorDynamics(q,v);
        Hinv = inv(H);
        
        if (obj.num_u>0) 
          vdot = Hinv*(B*u-C); 
          dtau = matGradMult(dB,u) - dC;
          dvdot = [zeros(obj.num_positions,1),...
            -Hinv*matGradMult(dH(:,1:obj.num_positions),vdot) + Hinv*dtau(:,1:obj.num_positions),...
            +Hinv*dtau(:,1+obj.num_positions:end), Hinv*B];
        else
          vdot = -Hinv*C; 
          dvdot = [zeros(obj.num_velocities,1),...
            Hinv*(-matGradMult(dH(:,1:obj.num_positions),vdot) - dC(:,1:obj.num_positions)),...
            Hinv*(-dC(:,obj.num_positions+1:end))];
        end
        
        [VqInv,dVqInv] = vToqdot(obj,q);
        xdot = [VqInv*v;vdot];
        dxdot = [...
          zeros(obj.num_positions,1), matGradMult(dVqInv, v), VqInv, zeros(obj.num_positions,obj.num_u);
          dvdot];
      else
        [H,C,B] = manipulatorDynamics(obj,q,v);
        Hinv = inv(H);
        if (obj.num_u>0) tau=B*u - C; else tau=-C; end
        tau = tau + computeConstraintForce(obj,q,v,H,tau,Hinv);
      
        vdot = Hinv*tau;
        % note that I used to do this (instead of calling inv(H)):
        %   vdot = H\tau
        % but I already have and use Hinv, so use it again here
        
        xdot = [vToqdot(obj,q)*v; vdot];
      end      
      
    end
end
end

