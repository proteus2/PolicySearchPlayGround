%% Q3 Part B

p=CompassGaitPlant();
[~,traj] = strideFunction(p, [0; 0; 2; -0.4]);


%% Q3 Part C
% using the equation w^*_{roll} =
% cot(2*alpha)*sqrt(4*g/l*sin(alpha)*sin(gamma))
m=1; g=9.8; alpha=pi/8; gamma=0.08;
wstar = 4;
l = (4*g*sin(alpha)*sin(gamma))*(cot(2*alpha))^2/(wstar)^2;

%% Q3 Part D
m=1; l=1; g=9.8; alpha= pi/8; gamma1=0.16; gamma2=0.02; gamma3=0.08;

w1_1 = sqrt(2*g/l*(1-cos(gamma1-alpha))); % the minimum speed required for a step in slope1
wstar1 = cot(2*alpha)*sqrt(4*g/l*sin(alpha*sin(gamma1))); % steady state velocity in slope1

w1_2 = sqrt(2*g/l*(1-cos(gamma2-alpha))); %minimum speed required for a step in slope2
w_roll2_init = cos(2*alpha)*sqrt(wstar1^2+4*g/l*sin(alpha)*sin(gamma2)); % first step in slope2

% we require that w_roll2 at the end of the second slope to be larger
% than w1_3 to reach a steady vel in the third slope.
w1_3 = sqrt(2*g/l*(1-cos(gamma3-alpha))); 

% so, how many steps can we take in the second slope?
nsteps = 1;
w_roll2 = w_roll2_init;
while w_roll2>w1_3
    w_roll2 = cos(2*alpha)*sqrt(w_roll2^2+4*g/l*sin(alpha)*sin(gamma2));
    nsteps = nsteps+1;
end

dist_per_step = 2*sin(alpha)*l;
d = dist_per_step*(nsteps-1); %distance travelled

%% Q4 Part C
x0=[   -0.323388563098678
   0.218668807978297
  -0.377182054327556
  -1.091826960670391];
p = CompassGaitPlant();
n = size(x0,1);
A = zeros(n,n);
pmap0 = strideFunction(p,x0);
h = 1e-10;
for idx1=1:n
    x0_h = x0;
    x0_h(idx1) = x0(idx1) + h;
    pmap_h = strideFunction(p,x0_h);
    A(:,idx1) = (pmap_h - pmap0)/h;
end
A
% part D
eig(A)
