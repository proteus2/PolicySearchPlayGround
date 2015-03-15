n_mmd_itern = 50;
n_obs=30;

obs_rand = rand(1,n_obs);
n_alpha = 3;
train_alpha_list = zeros(n_obs,n_alpha);
if ~exist('./train_partially_observable_alpha_list.mat','file')
    train_obs_list = 0.05*obs_rand + (1-obs_rand)*0.1;
    
    % sample alpha values for each observations: alpha_list(n_obs,n_alphas)
    for obs_idx = 1:n_obs
        obs = train_obs_list(obs_idx);        
        % each alpha value is drawn according to N(1/obs,1)
        train_alpha_list(obs_idx,:) = randn(1,n_alpha) + 1/obs;
    end
    
    % save the alpha values
    save('train_partially_observable_alpha_list','train_alpha_list','train_obs_list');
else
    load('train_partially_observable_alpha_list')
end

%train_alpha_list=train_alpha_list(1:n_obs);
train_x0_list= repmat([3.9; 0; 0; 0],1,n_obs); 
aggregate=false;
[controller,data] = trainPartiallyObservableMMD(train_x0_list,n_mmd_itern,train_alpha_list,train_obs_list,aggregate);

save('mmd_partially_observable_controller.mat','controller','data','train_alpha_list','train_x0_list');
