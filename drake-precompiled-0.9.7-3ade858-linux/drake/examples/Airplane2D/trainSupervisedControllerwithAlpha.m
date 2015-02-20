load('train_alpha_list')
load('train_x0_list');

x=[];y=[];
data={};
for idx=1:numel(train_alpha_list)
    alpha = train_alpha_list(idx);
    x0 = train_x0_list(:,idx);
    
    init_fname = sprintf('./InitTraining/initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4))
  
    load(init_fname);
    if exist('u_traj_from_curr_loc','var') && ~exist('utraj','var');
        xtraj = x_traj_from_curr_loc;
        utraj = u_traj_from_curr_loc;
    end
    
    tf = xtraj.getBreaks(); tf=tf(end);
    tf_list(idx) = tf;
    t = xtraj.getBreaks();
    [x_temp,y_temp] = turnTrajToData(xtraj,utraj,t,alpha);
    data{idx,1}=x_temp; data{idx,2}=y_temp;
    x=[x x_temp]; y=[y y_temp];
end

x = x';y=y';
load('RF_seed');
rng(RF_seed);
[controller] = TreeBagger(50,x,y,'Method','regression');
save('supervised_controller','controller','data','train_alpha_list');



