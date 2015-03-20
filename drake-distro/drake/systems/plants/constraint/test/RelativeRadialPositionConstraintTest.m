function RelativeRadialPositionConstraintTest(varargin)
  w = warning('off','Drake:RigidBodyManipulator:UnsupportedVelocityLimits');
  warning('off','Drake:RigidBodyManipulator:ReplacedCylinder');
  warning('off','Drake:RigidBodyManipulator:BodyHasZeroInertia');
  warning('off','Drake:RigidBodyManipulator:UnsupportedContactPoints');
  r = RigidBodyManipulator(strcat(getDrakePath(),'/examples/PR2/pr2.urdf'));
  warning(w);
  q_nom = zeros(r.getNumPositions(),1);
  constraintTester('RelativeRadialPositionConstraintTest', r, @makeCon, @(r) q_nom, @(r) q_nom, 10, varargin{:});
end

function con = makeCon(r)
  %n_pts = 4;
  bodyA_idx = findLinkInd(r,'r_gripper_palm_link');
  bodyB_idx = findLinkInd(r,'l_gripper_palm_link');
  radial_axis = [1; 1; 0];
  min_r = 0.5;
  max_r = inf;
  %rpy = 2*pi*rand(3,1) - pi;
  %xyz = [0.2;0.2;0.2].*rand(3,1) - [0;0.1;0.1];
  %lb = [-0.1;-0.1;-0.1];
  %ub = [0.1;0.1;0.1];
  %pts = bsxfun(@minus,bsxfun(@times,(ub-lb),rand(3,n_pts)),(ub-lb)/2);
  %pts = 0.8*[[0;1;1],[0;-1;1],[0;-1;-1],[0;1;-1]].*repmat((ub-lb)/2,1,4);
  pts = 0.4*rand(3,1) - 0.2;

  T = [0;0;0;1;0;0;0];
  %T = [xyz;rpy2quat(rpy)];
%   T = [rpy2rotmat(rpy),xyz;zeros(1,3),1];

  con = RelativeRadialPositionConstraint(r,pts,radial_axis,min_r,max_r,bodyA_idx,bodyB_idx,T,[0 1]);
  real_con = con.generateConstraint(0);
  q = randn(r.getNumPositions,1);
  [c,dc] = real_con{1}.eval(q,r.doKinematics(q));
  [~,dc_numeric] = geval(@(q) real_con{1}.eval(q,r.doKinematics(q)),q,struct('grad_method','numerical'));
  valuecheck(dc,dc_numeric,1e-4);
  valuecheck(dc,sparse(real_con{1}.iCfun,real_con{1}.jCvar, dc(sub2ind([real_con{1}.num_cnstr,real_con{1}.xdim],real_con{1}.iCfun,real_con{1}.jCvar)),real_con{1}.num_cnstr,real_con{1}.xdim));
end
