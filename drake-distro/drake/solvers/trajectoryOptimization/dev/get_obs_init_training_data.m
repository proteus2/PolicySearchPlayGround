%% Make initial training data
path='./observable_init/';
load(strcat(path,'com_list_for_partially_observations_list.mat'));
coms = cell(1,2);
for idx=1:40
    radius = obs_cands(idx,1)
    len = obs_cands(idx,2)
    
    coms{1} = mat2cell(com_list(idx,:,1),1);
    getObservableTrajectory(path,radius,len,coms);
end

%% Get initial training data
% for idx=1:(size(obs_cands,1)-2)
%     fname=strcat(path,sprintf('/new_traj_%d.mat',idx));
%     load(fname);
%     h_sol = [0 h_sol];
%     trajectory = [q_sol(:,:); h_sol ];
%     x=trajectory(:,1:end-1)';
%     y=trajectory(:,2:end)';
%     
%     radius = obs_cands(idx,1);
%     len=obs_cands(idx,2);
%     
%     fname_to_save = strcat( path, sprintf('/xy_format_new_traj_%d.mat',idx) );
%     save(fname_to_save,'x','y','radius','len');
% end
