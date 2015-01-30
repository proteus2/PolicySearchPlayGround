% Controller per iteration - n_mmd_itern of them
% Data set used for each controller
% Predict function that predicts an action for given state

classdef KMMController
   properties
       controllers;
       n_mmd_itern;
       data_sets;
       data_sets_unnormalized;
       data_mean;
       data_stddev;
       self_discrepancy;
       n_dataset;
       mmd_threshold;
       max_d;
       RF_seed;
   end 
   methods
        function obj = KMMController(RF_seed)
            obj.controllers = cell(0,1);
            obj.data_sets = cell(0,2);
            obj.data_sets_unnormalized = cell(0,2);
            obj.data_mean = cell(0,1);
            obj.data_stddev = cell(0,1);       
            obj.self_discrepancy = zeros(0,1);
            obj.mmd_threshold = 0.311;
            obj.max_d = -Inf;
            obj.RF_seed = RF_seed;
        end

        function obj = setNewController(obj,x_data,y_data,kmm_weights)
            if size(obj.data_sets_unnormalized,1) == 0
                obj.data_sets_unnormalized{1,1} = [];
                obj.data_sets_unnormalized{1,2} = [];
            end
            
            % transform the training data as per kmm weights
            kmmed_x = []; kmmed_y = [];
            for idx=1:size(x_data,2)
                kmmed_x = [kmmed_x repmat(x_data(:,idx),1,kmm_weights(idx))];
                kmmed_y = [kmmed_y repmat(y_data(:,idx),1,kmm_weights(idx))];
            end
            x_data = kmmed_x; y_data = kmmed_y;
            
            obj.data_sets_unnormalized{1,1} = [obj.data_sets_unnormalized{1,1} x_data];
            obj.data_sets_unnormalized{1,2} = [obj.data_sets_unnormalized{1,2} y_data];

            % normailze the data
            mu = mean( obj.data_sets_unnormalized{1,1},2);
            sigma = std( obj.data_sets_unnormalized{1,1}',1)';
            if any(sigma==0) == 1
                sigma(sigma==0) = 1;
            end
            obj.data_mean{1,1} = mu;
            obj.data_stddev{1,1} = sigma;
            normalized_x=bsxfun(@minus,obj.data_sets_unnormalized{1,1},obj.data_mean{1,1});
            normalized_x=bsxfun(@rdivide,normalized_x,obj.data_stddev{1,1});
            y =  obj.data_sets_unnormalized{1,2};

            obj.data_sets{1,1} = normalized_x;
            obj.data_sets{1,2} = y;

          
            rng(obj.RF_seed);
            obj.controllers{1,1} = TreeBagger(50,normalized_x',y','Method','regression','MinLeaf',5);
        end
    
        
        
        function u = predict(obj,x)
            x = x-obj.data_mean{1,1};
            x = x./obj.data_stddev{1,1};
            
            ctrller = obj.controllers{1,1};
            u = ctrller.predict(x');
        end
   end    
end
