file_list = dir('data_for_plots/batch_runs/');
file_list = file_list(3:end);
file_dir = './data_for_plots/batch_runs/';
file_list = file_list';
n_files = size(file_list,2);

sup_cost_list = zeros(n_files/2,1);
mmd_cost_list = zeros(n_files/2,1);
opt_cost_list = zeros(n_files/2,2);
alpha_list = zeros(n_files,1);
idx=1;
for file = file_list
    load(strcat(file_dir,file.name));
    alpha = strsplit(file.name,'=');
    alpha = alpha{2}; alpha=strsplit(alpha,','); alpha=str2double(alpha{1});
    alpha_list(idx) = alpha;
    if idx <= n_files/2
        mmd_cost_list(idx) = cost_list(1,2);
        sup_cost_list(idx) = cost_list(2,2);
    else
       opt_cost_list(idx) = cost_list(1,2);
    end
    
    idx=idx+1;
end

opt_cost_list=opt_cost_list(:,2);
opt_cost_list = opt_cost_list(opt_cost_list ~= 0);
figure; bar([mmd_cost_list sup_cost_list opt_cost_list])
legend('mmd','sup','opt')

figure; bar( [mean(mmd_cost_list);mean(sup_cost_list);mean(opt_cost_list)] );

better_alphas = alpha_list(mmd_cost_list<sup_cost_list);
worse_alphas = alpha_list(mmd_cost_list>sup_cost_list);