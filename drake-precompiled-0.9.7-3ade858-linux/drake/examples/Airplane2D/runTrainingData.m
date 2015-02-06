

n_x0=20;
x0_rand = rand(1,n_x0);
x0_x = 6*x0_rand + (1-x0_rand)*0;
x0_rand = rand(1,n_x0);
x0_y = 0*x0_rand + (1-x0_rand)*0;

if ~exist('./train_alpha_list.mat','file')
    train_alpha_list = 15*x0_rand + (1-x0_rand)*25;
    save('train_alpha_list','train_alpha_list');
else
    load('train_alpha_list')
end

if ~exist('./train_x0_list.mat','file')
    train_x0_list = [x0_x;x0_y;zeros(1,n_x0);zeros(1,n_x0)];
    train_x0_list = [train_x0_list];
    save('train_x0_list','train_x0_list');
else
    load('train_x0_list')
end

x0_list = train_x0_list(:,1:10);
alpha_list = train_alpha_list(1:10);

x0_alpha_list  = [train_x0_list; alpha_list];
% for alpha_idx=1:numel(alpha_list) 
%     for x0_idx=1:size(x0_list,2)
for idx=1:size(x0_alpha_list,2)
        x0 = x0_alpha_list(1:4,idx);
        alpha = x0_alpha_list(5,idx);
        
        init_fname = sprintf('./InitTraining/initial_mmd_traj_alpha=%d,x0=[%d,%d,%d,%d].mat',alpha,x0(1),x0(2),x0(3),x0(4))
        load(init_fname);
%         if ~exist(init_fname,'file')
%                         [utraj,xtraj,~] = getTrajectory(x0,alpha,false);
%                         save(init_fname, 'xtraj','utraj');
%          end
% %     end
 end
 