load('train_alpha_list')
load('train_x0_list');

% x=[];y=[];
% data={};
% for idx=1:numel(train_alpha_list)
%     alpha = train_alpha_list(idx);
%     x0 = train_x0_list(:,idx);
%     
%     init_fname = sprintf( './InitTraining/unobservable_initial_mmd_traj_alpha=%d,%d,%d,x0=[%d,%d,%d,%d].mat',alpha_list(1),alpha_list(2),alpha_list(3),x0(1),x0(2),x0(3),x0(4) )
%   
%     load(init_fname);
%     if exist('u_traj_from_curr_loc','var') && ~exist('utraj','var');
%         xtraj = x_traj_from_curr_loc;
%         utraj = u_traj_from_curr_loc;
%     end
%     
%     tf = xtraj.getBreaks(); tf=tf(end);
%     tf_list(idx) = tf;
%     t = xtraj.getBreaks();
%     [x_temp,y_temp] = turnTrajToData(xtraj,utraj,t,alpha);
%     data{idx,1}=x_temp; data{idx,2}=y_temp;
%     x=[x x_temp]; y=[y y_temp];
% end
alpha_list=train_alpha_list;
init_fname = sprintf( './InitTraining/unobservable_initial_mmd_traj_alpha=%d,%d,%d,x0=[%d,%d,%d,%d].mat',alpha_list(1),alpha_list(2),alpha_list(3),x0(1),x0(2),x0(3),x0(4) );
load(init_fname);

x=[];y=[];
tf_list = zeros(1,10);
for idx=1:numel(xtraj_list)
    xtraj = rungeKattaSimulation([3.9;0;0;0],utraj,0.001,1,PlanePlant(alpha_list(idx)),false); %xtraj_list{idx,1};
    t = xtraj.getBreaks(); tf=t(end);
    tf_list(idx) = tf;
    t=0:tf/21:tf;
    [new_x,new_y] = turnTrajToData(xtraj,utraj,t);
    x=[new_x x]; y =[new_y y];
end



x = x';y=y';
load('RF_seed');
rng(RF_seed);
[controller] = TreeBagger(50,x,y,'Method','regression');
save('unobservable_supervised_controller','controller','data','train_alpha_list');



