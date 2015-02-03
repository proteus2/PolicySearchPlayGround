% Controller per iteration - n_mmd_itern of them
% Data set used for each controller
% Predict function that predicts an action for given state

classdef BoostedKMMController
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
      alpha_list;
      alphaDecision;
      ctrl_list;
   end 
   methods
        function obj = BoostedKMMController(RF_seed)
            obj.controllers = cell(0,1);
            obj.data_sets = cell(0,2);
            obj.data_sets_unnormalized = cell(0,2);
            obj.data_mean = cell(0,1);
            obj.data_stddev = cell(0,1);       
            obj.self_discrepancy = zeros(0,1);
            obj.mmd_threshold = 0.311;
            obj.max_d = -Inf;
            obj.RF_seed = RF_seed;
            obj.alpha_list = [];
            obj.ctrl_list = [];
        end

        function obj = setNewController(obj,x_data,y_data,kmm_weights)
            if size(obj.data_sets_unnormalized,1) == 0
                obj.data_sets_unnormalized{1,1} = [];
                obj.data_sets_unnormalized{1,2} = [];
                obj.alpha_list = x_data(5:end,1); 
                obj.ctrl_list = 1;
                curr_dataidx = 1;
            end
            
            alpha = x_data(5:end,1);
            x_data = x_data(1:4,:);
            
            % Increment the number of datasets collected
            n_datasets = size(obj.data_sets,1);
            
            % check if the current alpha has been added before
            curr_dataidx = find(sum(bsxfun(@minus,alpha,obj.alpha_list))==0);
            if isempty(curr_dataidx)
                curr_dataidx = n_datasets+1;
                obj.data_sets_unnormalized{curr_dataidx,1} = [];
                obj.data_sets_unnormalized{curr_dataidx,2} = [];
                obj.alpha_list = [obj.alpha_list alpha];
                obj.ctrl_list = [obj.ctrl_list curr_dataidx];
            end
            
            % save the dataset - transform the training data as per kmm weights
            kmmed_x = []; kmmed_y = [];
            for idx=1:size(x_data,2)
                kmmed_x = [kmmed_x repmat(x_data(:,idx),1,kmm_weights(idx))];
                kmmed_y = [kmmed_y repmat(y_data(:,idx),1,kmm_weights(idx))];
            end
            x_data = kmmed_x; y_data = kmmed_y;
            
            % learn a new controller, add it to the set of controllers
            obj.data_sets_unnormalized{curr_dataidx,1} = [obj.data_sets_unnormalized{curr_dataidx,1} x_data];
            obj.data_sets_unnormalized{curr_dataidx,2} = [obj.data_sets_unnormalized{curr_dataidx,2} y_data];

            % normailze the data
            mu = mean( obj.data_sets_unnormalized{curr_dataidx,1},2);
            sigma = std( obj.data_sets_unnormalized{curr_dataidx,1}',1)';
            if any(sigma==0) == 1
                sigma(sigma==0) = 1;
            end
            obj.data_mean{curr_dataidx,1} = mu;
            obj.data_stddev{curr_dataidx,1} = sigma;
            normalized_x=bsxfun(@minus,obj.data_sets_unnormalized{curr_dataidx,1},obj.data_mean{curr_dataidx,1});
            normalized_x=bsxfun(@rdivide,normalized_x,obj.data_stddev{curr_dataidx,1});
            y =  obj.data_sets_unnormalized{curr_dataidx,2};

            obj.data_sets{curr_dataidx,1} = normalized_x;
            obj.data_sets{curr_dataidx,2} = y;

          
            rng(obj.RF_seed);
            obj.controllers{curr_dataidx,1} = TreeBagger(50,normalized_x',y','Method','regression','MinLeaf',1);
            obj.alphaDecision =  TreeBagger(10,obj.alpha_list',obj.ctrl_list','Method','classification','MinLeaf',1);
        end
    
        
        
        function u = predict(obj,x)
            data_idx = obj.alphaDecision.predict(x(5:end,1)');
            data_idx = str2num(data_idx{1});
            x = x(1:4,1)-obj.data_mean{data_idx,1};
            x = x(1:4,1)./obj.data_stddev{data_idx,1};
            
            ctrller = obj.controllers{data_idx,1};
            u = ctrller.predict(x(1:4,1)');
        end
   end    
end
