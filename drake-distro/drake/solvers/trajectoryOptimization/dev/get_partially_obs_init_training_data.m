%% Make initial training data
path='./partial_observable_init_training_data';
load(strcat(path,'/com_list_for_observations_list.mat'));
% coms = zeros(2,3);
% for idx=1:1
%     radius = obs_cands(idx,1)
%     len = obs_cands(idx,2)
%     
%     coms(1,:) = com_list(idx,:,1);
%     coms(2,:) = com_list(idx,:,2);
%     getPartiallyObservableTrajectory(0,'./',radius,len,coms);
% end

%% Get initial training data
for idx=1:(size(obs_cands,1)-2)
    fname=strcat(path,sprintf('/new_traj_%d.mat',idx));
    load(fname);
    h_sol = [0 h_sol];
    trajectory = [q_sol(:,:); h_sol ];
    x=trajectory(:,1:end-1)';
    y=trajectory(:,2:end)';
    
    radius = obs_cands(idx,1);
    len=obs_cands(idx,2);
    
    fname_to_save = strcat( path, sprintf('/xy_format_new_traj_%d.mat',idx) );
    save(fname_to_save,'x','y','radius','len');
end