function runSwingUp()
%% runs trajectory optimization and animates open-loop playback

p = AcrobotPlant;
v = AcrobotVisualizer(p);
[utraj,xtraj] = swingUpTrajectory(p,zeros(4,1)+[0;0;0;0]);
save('solution_300N','utraj','xtraj');
%      sys = cascade(utraj,p);
%      xtraj=simulate(sys,utraj.tspan,zeros(4,1));
% load('traj_list_snopt');
% xtraj=traj_list{25,2};


dt = 0.01;
t =0:dt:6;
N = size(t,2);
x1=zeros(4,N);

for k=1:N-1
    control = utraj.eval(t(k));
    xdot = p.dynamics(0,x1(:,k),control);
    xnew = x1(:,k) + xdot*dt;
    q = xnew(1:2,:);
    qd = xnew(3:4,:);
    q(1,:) = q(1,:) - 2*pi*floor(q(1,:)./(2*pi));
    q(2,:) = q(2,:) - 2*pi*floor((q(2,:) + pi)./(2*pi));

    x1(:,k+1)=[q;qd];
end


xtraj = PPTrajectory(foh(t,x1));
xtraj = xtraj.setOutputFrame(p.getStateFrame);
v.playback(xtraj);

end
