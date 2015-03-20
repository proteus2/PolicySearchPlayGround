%% this script takes trajectories, and then learns a control policy
x_list = [0,1]; roll_list = [0,pi/2];

dim_q = 42+1; N=10; %number of knot points
q_list = zeros(dim_q,numel(x_list)*numel(roll_list)*10);
q_idx=1;

init_conds_list = zeros(dim_q,numel(x_list)*numel(roll_list));
init_idx = 1;

for rollidx = 1:size(roll_list,2)
    roll = roll_list(1,rollidx);
    for idx=1:size(x_list,2)
        x = x_list(1,idx);
        fname = sprintf('traj_x=%d,roll=%d,.mat',x,roll)
        load(fname);
        init_conds_list(:,init_idx) = [q_sol(:,1); 0];
        
        % gather q_list
%         q_list(:,q_idx:q_idx+10-1) = [q_sol(1:12,:); [0 h_sol]];
        q_idx = q_idx+10;
        
        sol = [q_sol(:,:); [0 h_sol]];
        train_x{init_idx} = sol(:,1:end-1)';
        train_y{init_idx} = sol(:,2:end)';
        init_idx = init_idx + 1;
    end
end

% append dh at the end of x
% x=q_list(:,1:end-1)';
% y=q_list(:,2:end)';

save('init_train_data','train_x','train_y','init_conds_list','N');
% controller = TreeBagger(50,x,y,'Method','regression','MinLeaf',1);