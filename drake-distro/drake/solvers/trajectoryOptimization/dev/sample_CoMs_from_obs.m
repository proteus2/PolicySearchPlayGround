load('observations_list.mat');

% sample CoMs for each observations
com_list = zeros( size(obs_cands,1),3,2);
for idx=1:size(obs_cands,1)
    radius = obs_cands(idx,1);
    len = obs_cands(idx,2);
    
    mean = [radius;0];
    com_list(idx,1,1) = 0.001*randn(1,1)+radius;
    com_list(idx,2,1) = 0;
    com_list(idx,3,1) = 0.01*randn(1,1)+len/2;
   
    com_list(idx,1,2) = 0.001*randn(1,1)+radius;
    com_list(idx,2,2) = 0;
    com_list(idx,3,2) = 0.01*randn(1,1)+len/2;
    
end
save('com_list_for_observations_list.mat','com_list','obs_cands');

