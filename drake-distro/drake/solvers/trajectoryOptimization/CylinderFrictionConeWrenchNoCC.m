classdef CylinderFrictionConeWrenchNoCC < RigidBodyContactWrench
  % given the axis of the cylinder, the axis of the friction cone is always perpendular to the cylinder axis
    % Implement the slack variable version of nonlinear function
  % force >= 0 (nlcon)
  % distance - gamma = 0 (nlcon)
  % <force,gamma> = 0 (nlcon)
  % gamma >= 0 (bcon)
  properties(SetAccess = protected)
    cylinder_idx
    finger_idx
    finger_pt
    cylinder_axis_dir % In the cylinder body frame
    cylinder_axis_origin % In the cylinder body frame
    cylinder_radius
    mu
    force_normalization_factor
  end
  
  methods
    function obj = CylinderFrictionConeWrenchNoCC(robot,cylinder_idx,finger_idx,finger_pt,cylinder_axis_dir,cylinder_axis_origin,cylinder_radius,mu,force_normalization_factor,ncp_tol)
      obj = obj@RigidBodyContactWrench(robot,finger_idx,finger_pt);
      if(~isnumeric(cylinder_idx) || numel(cylinder_idx) ~= 1)
        error();
      end
      obj.cylinder_idx = cylinder_idx;
      obj.finger_idx = finger_idx;
      obj.finger_pt = finger_pt;
      obj.cylinder_axis_dir = cylinder_axis_dir./norm(cylinder_axis_dir);
      obj.cylinder_axis_origin = cylinder_axis_origin;
      obj.cylinder_radius = cylinder_radius;
      obj.mu = mu;
      obj.slack_name = cell(obj.num_pts,0);
      if(nargin <9)
        force_normalization_factor = obj.robot.getMass*norm(obj.robot.gravity);
      end
      if(nargin <10)
        ncp_tol = 1e-4;
      end
      obj.force_normalization_factor = force_normalization_factor;
      obj.num_pt_F = 3;
      obj.F_lb = -inf(3,1);
      obj.F_ub = inf(3,1);
      obj.wrench_cnstr_lb = 0;
      obj.wrench_cnstr_ub = inf;
      nq = obj.robot.getNumPositions;
     
      obj.wrench_cnstr_name = {sprintf('hand_%s_contact_force_in_friction_cone',obj.robot.getBody(obj.finger_idx).linkname)};
      obj.num_wrench_constraint = 1;
      obj.num_wrench_constraint = obj.num_wrench_constraint;%
      
%       obj.num_slack = obj.num_pts;
%       for i = 1:obj.num_slack
%         obj.slack_name{i} = sprintf('hand_%s_friction_cone_complementarity_slack%d',obj.body_name,i);
%       end
%       obj.slack_lb = zeros(obj.num_pts,1);
%       obj.slack_ub = inf(obj.num_pts,1);

      wrench_sparse_pattern = ones(obj.num_wrench_constraint,nq+obj.num_pt_F);
      % non-zero indicies of
      [obj.wrench_iCfun,obj.wrench_jCvar] = find(wrench_sparse_pattern); 
      
      obj.wrench_cnstr_ub = [obj.wrench_cnstr_ub];
      obj.wrench_cnstr_lb = [obj.wrench_cnstr_lb];
      
%       comp_name = cell(2*obj.num_pts,1);
%       for i = 1:obj.num_pts
%         comp_name{i} = sprintf('hand_%s_pt%d_contact_distance-gamma=0',obj.body_name,i);
%         comp_name{obj.num_pts+i} = sprintf('hand_<%s_pt%d_normal_force,gamma>=0',obj.body_name,i);
%       end
      obj.wrench_cnstr_name = [obj.wrench_cnstr_name];
      obj.complementarity_flag = false; %TODO: Turn this on to get the complementarity constraint
      obj.contact_force_type = RigidBodyContactWrench.CylinderFrictionConeType;
    end
    
    function [c,dc] = evalWrenchConstraint(obj,kinsol,F,slack)
      % first compute the direction normal to the cylinder axis
      [finger_pt_pos,dfinger_pt_pos] = forwardKin(obj.robot,kinsol,obj.finger_idx,obj.finger_pt);
      
      [cylinder_origin_pose,dcylinder_origin_pose] = forwardKin(obj.robot,kinsol,obj.cylinder_idx,obj.cylinder_axis_origin,2);
      cylinder_origin_pos = cylinder_origin_pose(1:3);
      dcylinder_origin_pos = dcylinder_origin_pose(1:3,:);
      [R_cylinder,dR_cylinder_dquat] = quat2rotmat(cylinder_origin_pose(4:7));
      dR_cylinder_dq = dR_cylinder_dquat*dcylinder_origin_pose(4:7,:);
      cylinder_axis = R_cylinder*obj.cylinder_axis_dir;
      dcylinder_axis_dq = matGradMult(dR_cylinder_dq,obj.cylinder_axis_dir);
      finger_pt_diff = finger_pt_pos-cylinder_origin_pos;
      dfinger_pt_diff = dfinger_pt_pos-dcylinder_origin_pos;
      axis_projection = finger_pt_diff'*cylinder_axis;
      daxis_projection = finger_pt_diff'*dcylinder_axis_dq+cylinder_axis'*dfinger_pt_diff;
      normal = finger_pt_diff-axis_projection*cylinder_axis;
      dnormal = dfinger_pt_diff-axis_projection*dcylinder_axis_dq-cylinder_axis*daxis_projection;
      normal_len = sqrt(normal'*normal);
      dnormal_len = normal'*dnormal/normal_len;
%       
%       c2 = normal_len-obj.cylinder_radius-slack;
       nq = obj.robot.getNumPositions;
%       dc2 = zeros(1,obj.num_pt_F+nq+obj.num_slack);
%       dc2(1:nq) = dnormal_len;
%       dc2(nq+3+(1:obj.num_slack)) = -eye;
      normal_dir = normal/normal_len;
      dnormal_dir = (dnormal*normal_len-normal*dnormal_len)/(normal_len^2);
      force_projection = F'*normal_dir;
      dforce_projection_dF = normal_dir';
      dforce_projection_dq = F'*dnormal_dir;
      force_normal = F-force_projection*normal_dir;
      dforce_normal_dF = eye(3)-normal_dir*dforce_projection_dF;
      dforce_normal_dq = -normal_dir*dforce_projection_dq-force_projection*dnormal_dir;
      
      c1 = obj.mu^2*force_projection^2-force_normal'*force_normal;
      dc1 = zeros(1,nq+obj.num_pt_F+obj.num_slack);
      dc1(1,1:nq) = obj.mu^2*2*force_projection*dforce_projection_dq-2*force_normal'*dforce_normal_dq;
      dc1(1,nq+(1:obj.num_pt_F)) = obj.mu^2*2*force_projection*dforce_projection_dF-2*force_normal'*dforce_normal_dF;
      
%       c3 = F'*force_normal*slack;
%       dc3 = zeros(1,nq+obj.num_pt_F+obj.num_slack);
%       dc3(1,1:nq) = F'*dforce_normal_dq*slack;
%       dc3(1,nq+(1:obj.num_pt_F)) = slack*(force_normal'+F'*dforce_normal_dF);
%       dc3(1,nq+obj.num_pt_F+(1:obj.num_slack)) = F'*force_normal;
%       
      c = [c1];
      dc = [dc1];
    end
    
    function A = torque(obj)
      A = sparse(3,obj.num_pt_F);
    end
    
    function A = force(obj)
      A = obj.force_normalization_factor*speye(3*obj.num_pts);
    end
    
    function [pos,J] = contactPosition(obj,kinsol)
      [pos,J] = forwardKin(obj.robot,kinsol,obj.finger_idx,obj.finger_pt,0);
    end
    
    function [normal_dir,dnormal_dir] = normalDirection(obj,kinsol)
      [finger_pt_pos,dfinger_pt_pos] = forwardKin(obj.robot,kinsol,obj.finger_idx,obj.finger_pt);
      [cylinder_origin_pose,dcylinder_origin_pose] = forwardKin(obj.robot,kinsol,obj.cylinder_idx,obj.cylinder_axis_origin,2);
      cylinder_origin_pos = cylinder_origin_pose(1:3);
      dcylinder_origin_pos = dcylinder_origin_pose(1:3,:);
      [R_cylinder,dR_cylinder_dquat] = quat2rotmat(cylinder_origin_pose(4:7));
      dR_cylinder_dq = dR_cylinder_dquat*dcylinder_origin_pose(4:7,:);
      cylinder_axis = R_cylinder*obj.cylinder_axis_dir;
      dcylinder_axis_dq = matGradMult(dR_cylinder_dq,obj.cylinder_axis_dir);
      finger_pt_diff = finger_pt_pos-cylinder_origin_pos;
      dfinger_pt_diff = dfinger_pt_pos-dcylinder_origin_pos;
      axis_projection = finger_pt_diff'*cylinder_axis;
      daxis_projection = finger_pt_diff'*dcylinder_axis_dq+cylinder_axis'*dfinger_pt_diff;
      normal = finger_pt_diff-axis_projection*cylinder_axis;
      dnormal = dfinger_pt_diff-axis_projection*dcylinder_axis_dq-cylinder_axis*daxis_projection;
      normal_len = sqrt(normal'*normal);
      dnormal_len = normal'*dnormal/normal_len;
      normal_dir = normal/normal_len;
      dnormal_dir = (dnormal*normal_len-normal*dnormal_len)/(normal_len^2);
    end
    
    function [pos,J] = bodyContactPosition(obj,kinsol)
      [finger_pt_pos,dfinger_pt_pos] = forwardKin(obj.robot,kinsol,obj.finger_idx,obj.finger_pt,0);
      [cylinder_origin_pose,dcylinder_origin_pose] = forwardKin(obj.robot,kinsol,obj.cylinder_idx,obj.cylinder_axis_origin,2);
      cylinder_origin_pos = cylinder_origin_pose(1:3);
      dcylinder_origin_pos = dcylinder_origin_pose(1:3,:);
      [R_cylinder,dR_cylinder_dquat] = quat2rotmat(cylinder_origin_pose(4:7));
      dR_cylinder_dq = dR_cylinder_dquat*dcylinder_origin_pose(4:7,:);
      pos = R_cylinder'*(finger_pt_pos-cylinder_origin_pos);
      J = matGradMult(dR_cylinder_dq,finger_pt_pos-cylinder_origin_pos,true)+R_cylinder'*(dfinger_pt_pos-dcylinder_origin_pos);
    end
    
    function [pos_t,dpos_t] = tangentialDisplacement(obj,kinsol1,kinsol2)
      [pos1,dpos1] = bodyContactPosition(obj,kinsol1);
      [pos2,dpos2] = bodyContactPosition(obj,kinsol2);
      [pos1_surface,dpos1_surface] = projectToCylinderSurface(obj,pos1);
      [pos2_surface,dpos2_surface] = projectToCylinderSurface(obj,pos2);
      dpos1_surface_dq1 = dpos1_surface*dpos1;
      dpos2_surface_dq2 = dpos2_surface*dpos2;
      pos_t = pos1_surface-pos2_surface;
      dpos_t = [dpos1_surface_dq1 -dpos2_surface_dq2];
    end
    
  end
  
  methods(Access = private)
    function [pos_surface,dpos_surface] = projectToCylinderSurface(obj,pt)
      % compute the projection of a point to the surface of the cylinder
      % @pt  A point in the cylinder body frame
      pt_cylinder_origin = pt-obj.cylinder_axis_origin;
      dpt_cylinder_origin = eye(3);
      pt_cylinder_axis = pt_cylinder_origin'*obj.cylinder_axis_dir*obj.cylinder_axis_dir;
      dpt_cylinder_axis = obj.cylinder_axis_dir*obj.cylinder_axis_dir'*dpt_cylinder_origin;
      pt_axis_perp = pt-pt_cylinder_axis;
      dpt_axis_perp = eye(3)-dpt_cylinder_axis;
      pt_axis_radius = pt_axis_perp/norm(pt_axis_perp)*obj.cylinder_radius;
      dpt_axis_radius = (dpt_axis_perp*norm(pt_axis_perp)-pt_axis_perp*pt_axis_perp'/norm(pt_axis_perp)*dpt_axis_perp)/(norm(pt_axis_perp)^2)*obj.cylinder_radius;
      pos_surface = pt_cylinder_axis+pt_axis_radius;
      dpos_surface = dpt_cylinder_axis+dpt_axis_radius;
    end
  end
  methods(Access = protected)
    function lincon = generateWrenchLincon(obj)
      lincon = LinearConstraint(zeros(0,1),zeros(0,1),sparse(0,obj.num_pts*obj.num_pt_F+obj.num_slack));
    end
  end
end