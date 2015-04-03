load('train_partially_observable_alpha_list')

n_alpha = size(train_alpha_list,2);
n_obs = size(train_obs_list,2);

x0=[3.9;0;0;0];

x=[];y=[];
for obs_idx=1:n_obs
    obs = train_obs_list(obs_idx);
    alpha_for_obs_val = train_alpha_list(obs_idx,:);
   % load('./InitTraining/partially_observable_initial_mmd_traj_alpha=1.356525e+01,1.387324e+01,1.424192e+01,x0=[3.900000e+00,0,0,0].mat');
    init_fname = sprintf( './InitTraining/partially_observable_initial_mmd_traj_obs_val=%d,x0=[%d,%d,%d,%d].mat',obs,x0(1),x0(2),x0(3),x0(4) )
    load(init_fname)
    
    for idx=1:numel(xtraj_list) % numel(xtraj_list) = number of alpha values associated with each observation
        xtraj = rungeKattaSimulation([3.9;0;0;0],utraj,0.001,1,PlanePlant(alpha_for_obs_val(idx)),false); 
        t = xtraj.getBreaks(); tf=t(end);
        tf_list(obs_idx,idx) = tf;
        t=0:tf/21:tf;
        [new_x,new_y] = turnTrajToData(xtraj,utraj,t,obs);
        x=[new_x x]; y =[new_y y];
    end
end

load('RF_seed');
rng(RF_seed);
[controller] = TreeBagger(50,x',y','Method','regression');
save('supervised_partially_observable_controller','controller','train_alpha_list');

