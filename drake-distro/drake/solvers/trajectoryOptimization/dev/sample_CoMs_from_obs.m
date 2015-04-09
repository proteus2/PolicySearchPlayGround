load('./partial_observable_init_training_data/observations_list.mat');
%% Generates the distribution of CoMs from given observations
% x ~ N(radius,0.001^2) ( perpendicular to the hand movement)
% y = N(radius,0.001^2)  (axis parallel to the hand movement)
% z ~ N(len/2, 0.01^2) ( height )

% sample CoMs for each observations
factor=0.5
com_list = zeros( size(obs_cands,1),3,2);
for idx=1:size(obs_cands,1)
    radius = obs_cands(idx,1);
    len = obs_cands(idx,2);
    
    mean = [radius;0];
    com_list(idx,1,1) = radius*factor*randn(1,1);
    com_list(idx,2,1) = radius*factor*randn(1,1);
    com_list(idx,3,1) = (len/2)*factor*randn(1,1)+len/2;
   
    com_list(idx,1,2) = radius*factor*randn(1,1);
    com_list(idx,2,2) = radius*factor*randn(1,1);
    com_list(idx,3,2) = (len/2)*factor*randn(1,1)+len/2;
    
    while abs(com_list(idx,1,1)) > radius || abs(com_list(idx,1,2)) > radius
            com_list(idx,1,1) = radius*factor*randn(1,1);

    com_list(idx,1,2) = radius*factor*randn(1,1);
    end
    
    
    while abs(com_list(idx,2,1)) > radius || abs(com_list(idx,2,2)) > radius
    com_list(idx,2,1) = radius*factor*randn(1,1);
        com_list(idx,2,2) = radius*factor*randn(1,1);

    end
    
    while abs(com_list(idx,3,1)) > len/2 || abs(com_list(idx,3,2) )> len/2
            com_list(idx,3,1) = (len/2)*factor*randn(1,1)+len/2;
                com_list(idx,3,2) = (len/2)*factor*randn(1,1)+len/2;
    end
end
save('./partial_observable_init_training_data/com_list_for_partially_observations_list.mat','com_list','obs_cands');

