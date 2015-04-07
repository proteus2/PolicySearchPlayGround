load('observations_list.mat');
%% Generates the distribution of CoMs from given observations
% x ~ N(radius,0.001^2) ( perpendicular to the hand movement)
% y = N(radius,0.001^2)  (axis parallel to the hand movement)
% z ~ N(len/2, 0.01^2) ( height )

% sample CoMs for each observations
com_list = zeros( size(obs_cands,1),3,2);
for idx=1:size(obs_cands,1)
    radius = obs_cands(idx,1);
    len = obs_cands(idx,2);
    
    mean = [radius;0];
    com_list(idx,1,1) = radius^2*randn(1,1);
    com_list(idx,2,1) = radius^2*randn(1,1);
    com_list(idx,3,1) = 0.01*randn(1,1)+len/2;
   
    com_list(idx,1,2) = radius^2*randn(1,1);
    com_list(idx,2,2) = radius^2*randn(1,1);
    com_list(idx,3,2) = 0.01*randn(1,1)+len/2;
    
    
end
save('com_list_for_observations_list.mat','com_list','obs_cands');

