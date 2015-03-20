classdef RobustGrasp < NonlinearProgram
  % Given a distribution of mass, inertia tensor and COM  location of the object, find the
  % robust open-loop finger trajectory, such that we can move the object (cup) from one
  % place  to another.
  properties(SetAccess = protected)
    uncertainty_handle
    robot
    planners
  end
  
  methods
    function obj = RobustGrasp(hand_urdf,hand_tip_names, hand_tip_pts,...
        back_tip_names, back_tip_pts,...
        object_struct, obj_beg_pose, obj_end_pose, hand_beg_pose,...
        hand_beg_vel, N,tf_range,Q_comddot,Qv,Q,q_nom,Q_contact_force,...
        uncertainty_handle,num_samples,ncp_tol)
      % @param hand A RigidBodyManipulator of the hand
      obj = obj@NonlinearProgram(0);
      objects_urdf = cell(num_samples,1);
      num_fingers = length(hand_tip_names);
      
      for i = 1:num_samples
        objects_urdf{i}= uncertainty_handle(i);
      end
      
      if(~isfield(object_struct,'type'))
        error()
      end
      
      %if(size(hand_tip_pts,1) ~= 3 || size(hand_tip_pts,2)~= num_fingers)
      %  error();
      %end
      
      function [c,dc] = ground_phi_handle(pts)
        num_pts = size(pts,2);
          c = pts(3,:)';
          dc = sparse((1:num_pts)',3*(1:num_pts)',ones(num_pts,1),num_pts,3*num_pts);
      end

      % TODO - Remove once we rever to complementarity constraints
      % Knot point at which we make contact with the surface of the cylinder.
      grasp_idx = 3;
      
      obj.planners = cell(num_samples,1);
      for i = 1:num_samples    
          
        %% Define the world and two rigid bodies: cylinder and robot hand
        % add cylinder
        obj.robot = RigidBodyManipulator(objects_urdf{i},struct('floating',true,'replace_cylinders_with_capsules',false));
        object_idx = obj.robot.findLinkInd(object_struct.name);
        
        % add the robot hand
        obj.robot = obj.robot.addRobotFromURDF(hand_urdf,[],[],struct('floating',true));
        
        cw_struct = struct('active_knot',[],'cw',[]);
        cw_count = 1;
        
        %% Define complementarity and cone wrench constraints for contact - either the object is in contact, or it is not
        % add friction constraint (condition for which the cylinder does
        % not drop once grasped)
        % TODO - Reenable complementariy constraints 
        force_normalization_factor = obj.robot.getMass*norm(obj.robot.gravity);
        for j = 1:num_fingers
         hand_tip_idx = obj.robot.findLinkInd(hand_tip_names{j});
         if(strcmp(object_struct.type,'cylinder'))
           cylinder_axis = object_struct.axis;
           cylinder_radius = object_struct.radius;
           cylinder_axis_origin = object_struct.axis_origin;
           cylinder_mu = object_struct.mu;
            
           finger_wrench = CylinderFrictionConeWrench(obj.robot,object_idx,hand_tip_idx,hand_tip_pts(:,j),cylinder_axis,cylinder_axis_origin,cylinder_radius,cylinder_mu,force_normalization_factor,ncp_tol);%robot,object_idx,hand_tip_idx,hand_tip_pts(:,j),cylinder_axis,cylinder_axis_origin,cylinder_radius,cylinder_mu,force_normalization_factor,ncp_tol);
           cw_struct(cw_count) = struct('active_knot',(1:N),'cw',finger_wrench);
           cw_count = cw_count+1;
         end
        end

        % add the ground contact for the object - cylinder is either
        % touching the table or it is lifted
        if(strcmp(object_struct.type,'cylinder'))
          ground_mu = 1;
          cylinder_pts = obj.robot.getBody(object_idx).getCollisionGeometry{1}.getBoundingBoxPoints;
          cylinder_pts = cylinder_pts(:,cylinder_pts(3,:) < 0);
          
          %table_wrench = ComplementarityFrictionConeWrench(obj.robot,object_idx,cylinder_pts,ground_mu,[0;0;1],@ground_phi_handle,force_normalization_factor,ncp_tol);
          % TODO - Remove if we choose to readd complementarity constraints
          alpha = linspace(0,2*pi,5);
          alpha = alpha(1:4);
          table_wrench = LinearFrictionConeWrench(obj.robot,object_idx,cylinder_pts, force_normalization_factor * [ground_mu*cos(alpha);ground_mu*sin(alpha);ones(1,4)]);
          cw_struct(cw_count) = struct('active_knot',(1:grasp_idx),'cw',table_wrench);
          %cw_struct(cw_count) = struct('active_knot',(1:N),'cw',table_wrench);
        end

        %% TODO - Remove manual constraint
        %contact_pts = zeros(3,4);
        %theta = pi / 6;
        %x_contact_pt = object_struct.radius*cos(theta);
        %y_contact_pt = object_struct.radius*sin(theta);
        %contact_pts(:,1) = obj_beg_pose(1:3) + [-x_contact_pt; y_contact_pt; 0.0360];
        %contact_pts(:,2) = obj_beg_pose(1:3) + [-x_contact_pt; y_contact_pt; -0.0360];
        %contact_pts(:,3) = obj_beg_pose(1:3) + [x_contact_pt; y_contact_pt; 0];
        %contact_pts(:,4) = obj_beg_pose(1:3) + [0; -object_struct.radius; 0];
        %pickup_cnstrs = cell(4,1);
        %for j = 1:4
        %  link_idx = obj.robot.findLinkInd(hand_tip_names{j});
        %  link_tip = hand_tip_pts(:,j);
        %  cnstr = WorldPositionConstraint(obj.robot, link_idx, link_tip, contact_pts(:,j), contact_pts(:,j));
        %  pickup_cnstrs{j} = cnstr;
        %end
        %options = IKoptions(obj.robot);
        %nq = obj.robot.getNumPositions();
        %q_nom = inverseKin(obj.robot, zeros(nq, 1), zeros(nq, 1),...
        %  pickup_cnstrs{1}, pickup_cnstrs{2}, pickup_cnstrs{3}, pickup_cnstrs{4}, options);
        %q_nom = bsxfun(@times, q_nom, ones(1,N));
        
        
        %% Create a non linear program for each sample. Add dynamic and cone-wrench constraints that we defined above.
        % Adding planner for each sample. Consctructs costs and
        % constraints.
        obj.planners{i} = SingleBodyDynamicsFullKinematicsPlanner(obj.robot,object_idx,N,tf_range,Q_comddot,Qv,Q,q_nom,Q_contact_force,cw_struct);

        % constraint for making the hand to stay above the ground
        num_bodies = obj.robot.getNumBodies();
        hand_links = 1:num_bodies;
        hand_links = hand_links(hand_links~=obj.robot.findLinkInd('cylinder'));
        hand_links = hand_links(hand_links~=obj.robot.findLinkInd('world'));
        for j = hand_links
          obj.planners{i} = obj.planners{i}.addRigidBodyConstraint(...
            WorldPositionConstraint(obj.robot, j, zeros(3,1), ...
            [-inf; -inf; 0], inf(3,1)),...
            num2cell(1:N));
        end

        % constraint for making the cylinder to stay above the ground
        obj.planners{i} = obj.planners{i}.addRigidBodyConstraint(...
          WorldPositionConstraint(obj.robot, obj.robot.findLinkInd('cylinder'),...
          [0; 0; -object_struct.len / 2], [-inf; -inf; 0], inf(3,1)),...
          num2cell(1:N));

        %% TODO - Remove manual constraint
        %for j = 1:4
        %  obj.planners{i} = obj.planners{i}.addRigidBodyConstraint(pickup_cnstrs{j}, {grasp_idx});
        %end

        % Add back of finger tips constraints - dont penetrate
        for j = 1:length(back_tip_names)
          cnstr = RelativeRadialPositionConstraint(obj.robot, back_tip_pts(:,j),...
            [1;1;0], object_struct.radius, inf,...
            obj.robot.findLinkInd(back_tip_names{j}), obj.robot.findLinkInd('cylinder'));
          obj.planners{i} = obj.planners{i}.addRigidBodyConstraint(cnstr, num2cell(1:N));
        end
      end
      
      %% Combine decision variables, constraints and cost functions for all the samples
      % add decision variables, constraints, and cost function for each of the sample
      num_vars = 0;
      num_lcon = 0;
      num_shared_data = 0;
      for i = 1:num_samples
          x_name = strcat('sample_',num2str(i),'_',obj.planners{i}.x_name);
          obj = obj.addDecisionVariable(obj.planners{i}.num_vars, x_name);

          for j = 1:length(obj.planners{i}.shared_data_functions)
            shared_data_xind = obj.planners{i}.shared_data_xind_cell{j};
            for k = 1:length(shared_data_xind)
              shared_data_xind{k} = shared_data_xind{k}+num_vars;
            end
            obj = obj.addSharedDataFunction(obj.planners{i}.shared_data_functions{j},shared_data_xind);
          end  
          
          for j = 1:numel(obj.planners{i}.nlcon)
              obj = obj.addNonlinearConstraint(obj.planners{i}.nlcon{j}, cellfun(@(x) x + num_vars, obj.planners{i}.nlcon_xind{j}, 'UniformOutput', false),obj.planners{i}.nlcon_dataind{j}+num_shared_data);
          end
          
          for j = 1:numel(obj.planners{i}.cost)
              obj = obj.addCost(obj.planners{i}.cost{j}, cellfun(@(x) x + num_vars, obj.planners{i}.cost_xind_cell{j}, 'UniformOutput', false),obj.planners{i}.cost_dataind{j}+num_shared_data);
          end
          
          num_vars = num_vars + obj.planners{i}.num_vars;
          num_lcon = num_lcon + size(obj.planners{i}.Ain, 1) + size(obj.planners{i}.Aeq, 1);
          num_shared_data = num_shared_data+length(obj.planners{i}.shared_data_functions);
      end
      
      A = zeros(num_lcon, num_vars);
      lb = -inf(num_lcon, 1);
      ub = inf(num_lcon, 1);
      x_lb = -inf(num_vars, 1);
      x_ub = inf(num_vars, 1);
      nq = obj.planners{1}.nq;
      nv = obj.planners{1}.nv;
      nh = N - 1;
      
      % contraints for having trajectories to be equal across
      % different samples. Only constrains h,q, and v.
      A_tau = zeros((nh+(nq+nv)*N)*(num_samples-1),num_vars);
      b_tau = zeros((nh+(nq+nv)*N)*(num_samples-1),1);
      
      % initilize the position constraints for object and hand
      % no constraint: -inf and inf for other decision variables
      grasp_object_lb = -inf(num_vars, 1);
      grasp_object_ub = inf(num_vars, 1);
      hand_beg_lb = -inf * ones(num_vars, 1);
      hand_beg_ub = inf * ones(num_vars, 1);

      %% Constrain finger_1 and finger_2 to move together
      %A_fingers = zeros(3*2*N, num_vars);
      %b_fingers = zeros(3*2*N, 1);

      num_vars = 0;
      num_lcon = 0;
      for i = 1:num_samples
          vars_range = num_vars + 1 : num_vars + obj.planners{i}.num_vars;
          lcon_range = num_lcon + 1 : num_lcon + size(obj.planners{i}.Ain, 1) + size(obj.planners{i}.Aeq,1);
          A(lcon_range,vars_range) = [obj.planners{i}.Ain; obj.planners{i}.Aeq];
          lb(lcon_range,1) = [-inf*ones(size(obj.planners{i}.bin)); obj.planners{i}.beq];
          ub(lcon_range,1) = [obj.planners{i}.bin; obj.planners{i}.beq];
          
          x_lb(vars_range,1) = obj.planners{i}.x_lb;
          x_ub(vars_range,1) = obj.planners{i}.x_ub;
          
          % constructing constraints for having same trajectories across
          % all samples
          if i > 1
              % get hqv_index of i-1th sample to index into num_vars
              num_vars_per_sample = nh + (nq+nv)* N;                                          % number of decision variables per sample                              
              node_range = num_vars_per_sample * (i-2) + (1:num_vars_per_sample);             % node_range = index into the ith sample's decision variables
              qv_range = [obj.planners{i-1}.q_inds; obj.planners{i-1}.v_inds];
              hqv_index = [obj.planners{i-1}.h_inds; qv_range(:)];                            % get the h, q, and v values for i-1th sample
              hqv_index = (i-2)*obj.planners{1}.num_vars + hqv_index;                         % account for offset. NOTE: if each planner has diff number of num_vars, this would not work
              A_tau(node_range, hqv_index) = eye(num_vars_per_sample);                         

              % get hqv_index of ith sampel to index into num_vars
              qv_range = [obj.planners{i}.q_inds; obj.planners{i}.v_inds];
              hqv_index = [obj.planners{i}.h_inds; qv_range(:)];
              hqv_index = (i-1)*obj.planners{1}.num_vars + hqv_index;                           
              A_tau(node_range, hqv_index) = -eye(num_vars_per_sample);                        
          end
          
          q_1_inds = num_vars + obj.planners{i}.q_inds(:,1);
          q_N_inds = num_vars + obj.planners{i}.q_inds(:,N);

          obj_1_xyz_idx = q_1_inds(obj.planners{i}.grasp_object_xyz_idx);
          obj_1_rpy_idx = q_1_inds(obj.planners{i}.grasp_object_rpy_idx);
          obj_N_xyz_idx = q_N_inds(obj.planners{i}.grasp_object_xyz_idx);
          obj_N_rpy_idx = q_N_inds(obj.planners{i}.grasp_object_rpy_idx);
          
          % beginnig and end constraints for the object being grasped
          grasp_object_lb(obj_1_xyz_idx, 1) = obj_beg_pose(1:3);
          grasp_object_ub(obj_1_xyz_idx, 1) = obj_beg_pose(1:3);
          grasp_object_lb(obj_1_rpy_idx, 1) = obj_beg_pose(4:6);
          grasp_object_ub(obj_1_rpy_idx, 1) = obj_beg_pose(4:6);
          grasp_object_lb(obj_N_xyz_idx, 1) = obj_end_pose(1:3);
          grasp_object_ub(obj_N_xyz_idx, 1) = obj_end_pose(1:3);
          grasp_object_lb(obj_N_rpy_idx, 1) = obj_end_pose(4:6);
          grasp_object_ub(obj_N_rpy_idx, 1) = obj_end_pose(4:6);
          q_mid_inds = num_vars + obj.planners{i}.q_inds(:,(2:N-1));
          obj_mid_rpy_idx = q_mid_inds(obj.planners{i}.grasp_object_rpy_idx);
          %grasp_object_lb(obj_mid_rpy_idx) = [-pi/2; -pi/2; -inf];
          %grasp_object_ub(obj_mid_rpy_idx) = [pi/2; pi/2; inf];

          % TODO - Possibly remove if we choose to add complementarity
          % constraint for ground again
          % Specify object doest not move until grasp_idx
          for h = 1:grasp_idx
            q_inds = num_vars + obj.planners{i}.q_inds(:,h);
            obj_xyz_idx = q_inds(obj.planners{i}.grasp_object_xyz_idx);
            obj_rpy_idx = q_inds(obj.planners{i}.grasp_object_rpy_idx);
            grasp_object_lb(obj_xyz_idx, 1) = obj_beg_pose(1:3);
            grasp_object_ub(obj_xyz_idx, 1) = obj_beg_pose(1:3);
            grasp_object_lb(obj_rpy_idx, 1) = obj_beg_pose(4:6);
            grasp_object_ub(obj_rpy_idx, 1) = obj_beg_pose(4:6);
          end

          palm_body = obj.robot.getBody(obj.robot.findLinkInd('palm'));
          q_idx = num_vars + obj.planners{i}.q_inds(:,1);
          v_idx = num_vars + obj.planners{i}.v_inds(:,1);
          hand_q_idx = q_idx(palm_body.position_num);
          hand_v_idx = v_idx(palm_body.velocity_num);
          hand_beg_lb(hand_q_idx, 1) = hand_beg_pose;
          hand_beg_ub(hand_q_idx, 1) = hand_beg_pose;
          hand_beg_lb(hand_v_idx, 1) = hand_beg_vel;
          hand_beg_ub(hand_v_idx, 1) = hand_beg_vel;

          num_vars = num_vars + obj.planners{i}.num_vars;
          num_lcon = num_lcon + size(obj.planners{i}.Ain,1) + size(obj.planners{i}.Aeq,1);
      end

      %for h = 1:N
      %  for finger_link = 1:3
      %    finger1 = obj.robot.getBody(obj.robot.findLinkInd(sprintf('finger_1_link_%d', finger_link)));
      %    finger2 = obj.robot.getBody(obj.robot.findLinkInd(sprintf('finger_2_link_%d', finger_link)));
      %    A_fingers((h-1)*6+finger_link, obj.planners{1}.q_inds(finger1.position_num,h)) = 1;
      %    A_fingers((h-1)*6+finger_link, obj.planners{1}.q_inds(finger2.position_num,h)) = -1;
      %    A_fingers((h-1)*6+3+finger_link, obj.planners{1}.v_inds(finger1.velocity_num,h)) = 1;
      %    A_fingers((h-1)*6+3+finger_link, obj.planners{1}.v_inds(finger2.velocity_num,h)) = -1;
      %  end
      %end


      % Readds all the linear constraints of the sub-problems as one big
      % linear constraint
      obj = obj.addLinearConstraint(LinearConstraint(lb, ub, A));
      
      % The lower and upper bounds of x given to us by the each planner
      obj = obj.addBoundingBoxConstraint(BoundingBoxConstraint(x_lb,x_ub));
      
      % Constrains all the trajectories to have the same trajectory
      obj = obj.addLinearConstraint(LinearConstraint(b_tau,b_tau,A_tau));
      
      % Constrains the grasp object's initial and end positions
      obj = obj.addBoundingBoxConstraint(BoundingBoxConstraint(grasp_object_lb, grasp_object_ub));
      
      % Constrains the starting pose of the hand
      obj = obj.addBoundingBoxConstraint(BoundingBoxConstraint(hand_beg_lb,hand_beg_ub));

      %% Constrains finger_1 and finger_2 to move together
      %obj = obj.addLinearConstraint(LinearConstraint(b_fingers, b_fingers, A_fingers));
    end
    
    % [x] TODO - Add final position constraint and initial position constraint
    % TODO - Add new pts to back of fingers for collision detection
    % TODO - For visualization, look at playback in handMoveBlock.m in master
    % branch
    % [x] TODO - Constraint on time duration between two node points
    % (ex. testJump.m in master); make sure the node points are the same
    % across all trajectories
    % HOWTO - Visualization
    % v = hand.constructVisualizer()
    % lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'palm')
    % lcmgl.glColor3f(1,0,0)
    % kinsol = hand.doKinematics(zeros(hand.getNumPositions(), 1));
    % lcmgl.sphere(hand.forwardKin(kinsol, hand.findLinkInd('palm'), pts), 0.01, 20, 20);
    % lcmgl.switchBuffers()
    % for communicating with lcmgl
  end
  
end
