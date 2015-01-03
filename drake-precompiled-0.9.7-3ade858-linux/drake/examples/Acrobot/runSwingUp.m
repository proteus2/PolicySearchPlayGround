function runSwingUp()
%% runs trajectory optimization and animates open-loop playback

p = AcrobotPlant;
v = AcrobotVisualizer(p);
[utraj,xtraj] = swingUpTrajectory(p,zeros(4,1)+[0;0;0;0]);
%      sys = cascade(utraj,p);
%      xtraj=simulate(sys,utraj.tspan,zeros(4,1));
load('traj_list_snopt');
xtraj=traj_list{25,2};
xtraj=xtraj.setOutputFrame(p.getStateFrame);
v.playback(xtraj);

end
