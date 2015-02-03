

n_x0=50;
x0_rand = rand(1,n_x0);
x0_x = 5*x0_rand + (1-x0_rand)*2;
x0_rand = rand(1,n_x0);
x0_y = 0*x0_rand + (1-x0_rand)*1;

if ~exist('./train_alpha_list.mat','file')
    train_alpha_list = 5*x0_rand + (1-x0_rand)*20;
    save('train_alpha_list','train_alpha_list');
else
    load('train_alpha_list')
end

if ~exist('./train_x0_list.mat','file')
    train_x0_list = [x0_x;x0_y;zeros(1,n_x0);zeros(1,n_x0)];
    train_x0_list = [[2;0;0;0] train_x0_list [5;0;0;0]];
    save('train_x0_list','train_x0_list');
else
    load('train_x0_list')
end

x0_list = train_x0_list;
alpha_list = train_alpha_list;
for alpha_idx=1:numel(alpha_list) 
    for x0_idx=25:size(x0_list,2)
        x0 = x0_list(:,x0_idx);
        %% 1) get the reference trajectory
        alpha = alpha_list(alpha_idx);
        
        init_fname = sprintf('initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4))
%         if ~exist(init_fname,'file')
                        [utraj,xtraj,~] = getTrajectoryForKMM(x0,alpha,true);
%                         save(init_fname, 'xtraj','utraj');
%          end
    end
 end
 