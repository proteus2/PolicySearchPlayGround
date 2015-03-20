classdef ComplementarityStaticContactConstraint 
  % enforces the constraint
  % force_normal(i)*norm(contact_pos_tangential(i)-contact_pos_tangential(i+1)) = 0
  % By 
  % norm(contact_pos_tangential(i)-contact_pos_tangential(i+1))^2 <= gamma1^2
  % -ncp_tol <= force_normal*gamma1 <= ncp_tol
  % gamma1 >= 0
  
  properties(SetAccess = protected)
    rb_wrench  % A RigidBodyWrench object
    nlcon
  end
  
  properties(Access = protected)
    A_force
    A_torque
    nq
    num_pts
    num_pt_F
    num_lambda
    lambda_idx
    q1_idx
    q2_idx
    gamma1_idx
  end
  
  methods
    function obj = ComplementarityStaticContactConstraint(rb_wrench,ncp_tol)
      if(nargin<2)
        ncp_tol = 0;
      end
      if(~isa(rb_wrench,'RigidBodyContactWrench'))
        error('Drake:ComplementarityStaticContactConstraint:InvalidArguments','Argument rb_wrench should be a RigidBodyContactWrench object');
      end
      if(~isa(rb_wrench,'LinearFrictionConeWrench') && ~isa(rb_wrench,'FrictionConeWrench') && ~isa(rb_wrench,'CylinderFrictionConeWrench'))
        error('Drake:ComplementarityStaticContactConstraint: only support LinearFrictionConeWrench or FrictionConeWrench or CylinderFrictionConeWrench');
      end
      obj.nq = rb_wrench.robot.getNumPositions();
      obj.num_lambda = rb_wrench.num_pt_F*rb_wrench.num_pts;
      obj.num_pt_F = rb_wrench.num_pt_F;
      obj.rb_wrench = rb_wrench;
      obj.A_force = obj.rb_wrench.force();
      obj.A_torque = obj.rb_wrench.torque();
      obj.num_pts = obj.rb_wrench.num_pts;
      obj.q1_idx = (1:obj.nq)';
      obj.q2_idx = obj.nq+(1:obj.nq)';
      obj.lambda_idx = 2*obj.nq+(1:obj.num_lambda)';
      obj.gamma1_idx = 2*obj.nq+obj.num_lambda+(1:obj.num_pts)';     
      
      nlcon_name = cell(2*rb_wrench.num_pts,1);
      for i = 1:obj.num_pts
        nlcon_name{i} = sprintf('norm(%s_pt%d_contact_pos_tangential)^2 <= gamma1^2',obj.rb_wrench.body_name,i);
        nlcon_name{i+obj.num_pts} = sprintf('%s_pt%d_force x gamma1=0',obj.rb_wrench.body_name,i);
      end
      nlcon_lb = [-inf(obj.num_pts,1);-ncp_tol*ones(obj.num_pts,1)];
      nlcon_ub = [zeros(obj.num_pts,1);ncp_tol*ones(obj.num_pts,1)];
      obj.nlcon = FunctionHandleConstraint(nlcon_lb,nlcon_ub,2*obj.nq+obj.num_lambda+obj.num_pts,@(~,~,lambda,gamma,kinsol1,kinsol2) nlconEval(obj,kinsol1,kinsol2,lambda,gamma),1);
      obj.nlcon = obj.nlcon.setName(nlcon_name);
      iCfun1 = [reshape(bsxfun(@times,(1:obj.num_pts)',ones(1,2*obj.nq)),[],1);(1:obj.num_pts)'];
      jCvar1 = [reshape(bsxfun(@times,ones(obj.num_pts,1),[obj.q1_idx' obj.q2_idx']),[],1);obj.gamma1_idx];
      [iCfun2,jCvar2] = find(ones(obj.num_pts,obj.nlcon.xdim));
      iCfun2 = obj.num_pts+iCfun2;
      obj.nlcon = setSparseStructure(obj.nlcon,[iCfun1;iCfun2(:)],[jCvar1;jCvar2(:)]);
    end
    
    function [nlcon,slack_bcon,num_slack,slack_name] = generateConstraint(obj)
      num_slack = obj.num_pts;
      slack_name = cell(num_slack,1);
      for i = 1:num_slack
        slack_name{i} = sprintf('%s_ComplementarityStaticContact_slack%d',obj.rb_wrench.body_name,i);
      end
      nlcon = obj.nlcon;
      slack_bcon = BoundingBoxConstraint(zeros(num_slack,1),inf(num_slack,1));
    end
    
    function [c,dc] = nlconEval(obj,kinsol1,kinsol2,lambda,gamma)
      gamma1 = gamma(1:obj.num_pts);
      [pos_diff,dpos_diff_dq] = tangentialDisplacement(obj.rb_wrench,kinsol1,kinsol2);
      c1 = sum(pos_diff.*pos_diff,1)'-gamma1.^2;
      dc1dq = 2*sparse(reshape(bsxfun(@times,ones(3,1),1:obj.num_pts),[],1),(1:3*obj.num_pts)',pos_diff(:),obj.num_pts,3*obj.num_pts)*dpos_diff_dq;
      dc1dgamma1 = -2*diag(gamma1);
      num_vars = 2*obj.nq+obj.num_lambda+obj.num_pts;
      dc1 = zeros(obj.num_pts,num_vars);
      dc1(:,[obj.q1_idx' obj.q2_idx']) = dc1dq;
      dc1(:,obj.gamma1_idx) = dc1dgamma1;
      
      [normal_dir,dnormal_dir] = normalDirection(obj.rb_wrench,kinsol2);
      force = reshape(obj.A_force*lambda(:),3,obj.num_pts);
      normal_force = sum(normal_dir.*force,1)';
      dnormal_force_dq2 = sparse(reshape(bsxfun(@times,ones(3,1),1:obj.num_pts),[],1),(1:3*obj.num_pts)',force(:),obj.num_pts,3*obj.num_pts)*dnormal_dir;
      dnormal_force_dlambda = sparse(reshape(bsxfun(@times,ones(3,1),1:obj.num_pts),[],1),(1:3*obj.num_pts)',normal_dir(:),obj.num_pts,3*obj.num_pts)*obj.A_force;
      force_scaler = obj.rb_wrench.robot.getMass*norm(obj.rb_wrench.robot.getGravity);
      c2 = gamma1.*normal_force/force_scaler;
      dc2 = zeros(obj.num_pts,num_vars);
      dc2(:,obj.q2_idx) = diag(gamma1)/force_scaler*dnormal_force_dq2;
      dc2(:,obj.lambda_idx) = diag(gamma1)/force_scaler*dnormal_force_dlambda;
      dc2(:,obj.gamma1_idx) = diag(normal_force)/force_scaler;
      c = [c1;c2];
      dc = [dc1;dc2];
    end
  end
  
    
end