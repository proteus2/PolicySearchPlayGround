function gatherTrajData()
%% runs trajectory optimization and animates open-loop playback

p = AcrobotPlant;
v = AcrobotVisualizer(p);
traj_list = cell(size(0:0.6284:pi,2),2);
idx=1;
maxidx = size(0:0.6284:pi,2); maxidx=maxidx^2
for theta=0:0.6284:(pi+0.6284)
	for rho=0:0.6284:(pi+0.6284)
		x0 = zeros(4,1)+[theta;rho;0;0]
		idx
		
		[utraj,xtraj] = swingUpTrajectory(p,x0);
		traj_list{idx,1} = utraj;
		traj_list{idx,2} = xtraj;
		idx=idx+1;
	end
end
save('traj_list_snopt2','traj_list')

%      sys = cascade(utraj,p);
%      xtraj=simulate(sys,utraj.tspan,zeros(4,1));
% v.playback(xtraj);

end
