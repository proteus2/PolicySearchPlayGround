% Controller per iteration - n_mmd_itern of them
% Data set used for each controller
% Predict function that predicts an action for given state

classdef MMDAggregateController
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
        function obj = MMDAggregateController(RF_seed)
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

        function obj = setNewController(obj,x_data,y_data)
            
            
            if size(obj.data_sets_unnormalized,1) == 0
                obj.n_dataset = size(x_data,2);
                obj.data_sets_unnormalized{1,1} = [];
                obj.data_sets_unnormalized{1,2} = [];
            end
            
            x_data = fixTheta(obj,x_data);

            % Check the mmd discrepancy between the new data and the existing data
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
            x_data=bsxfun(@minus,obj.data_sets_unnormalized{1,1},obj.data_mean{1,1});
            x_data=bsxfun(@rdivide,x_data,obj.data_stddev{1,1});
            y_data =  obj.data_sets_unnormalized{1,2};

            obj.data_sets{1,1} = x_data;
            obj.data_sets{1,2} = y_data;

            n_data = size(x_data,2);
            obj.self_discrepancy(1,1) = 1/n_data^2 * sum(sum(obj.computeKernel(1)));
                
            % compute the maximum distance to the center of the dataset
            obj.max_d(1) = -Inf;
            for idx = 1:size(obj.data_sets_unnormalized{1,1},2)
                k = obj.computeKernel(1,obj.data_sets_unnormalized{1,1}(:,idx)); 
                if k>obj.max_d(1)
                    obj.max_d(1) = k;
                end
            end
                    
            rng(obj.RF_seed);
            
            num_replicate = 5;
            x_data = repmat(x_data,1,num_replicate);
            y_data = repmat(y_data,1,num_replicate);
            
            obj.controllers{1,1} = TreeBagger(50,x_data',y_data','Method','regression','MinLeaf',2);
        end
      function x_prime = fixTheta(obj,x)
            theta = x(3,:);
            negtheta = find(theta<=0);
            while ~isempty(negtheta)
                theta(negtheta) = theta(negtheta) + 2*pi;
                negtheta = find(theta<=0);
            end
            x_prime = x;
            x_prime(3,:) = theta;
        end
        function [diff_x] = computeDiffWithNormalizedData(obj,x1,x2,std_dev)
            dists = abs(bsxfun(@minus,x1,x2));
            theta_dists = dists(3,:)*std_dev(3);
            wrong_th_dists = find(abs(theta_dists)>pi);
            while ~isempty(wrong_th_dists)
                theta_dists(wrong_th_dists) = min(abs(theta_dists(wrong_th_dists)),abs(2*pi-abs(theta_dists(wrong_th_dists))));
                if any(theta_dists<0)
                    fprintf('Wrong angle difference detected')
                    return;
                end
                wrong_th_dists = find(abs(theta_dists)>pi);
                if ~isempty(wrong_th_dists)
                    fprintf('Wrong angle difference detected')
                    return;
                end
            end
            dists(3,:) = theta_dists/std_dev(3);
            diff_x = dists;
        end
        
         function [min_d,min_idx,emptyCandidates,candidates] = checkDiscrepancy(obj,x)
            min_idx=1;
            min_d = inf;
            x = fixTheta(obj,x);
            
            candidates = {};
            for idx=1:size(obj.data_sets,1)
                curr_d = obj.computeKernel(idx,x);
                if curr_d <= obj.max_d(idx)
                    candidates{size(candidates,1)+1,1} = idx; candidates{size(candidates,1),2} = curr_d;
                end
                
                if curr_d < min_d
                    min_idx = idx;
                    min_d = curr_d;
                end
            end
            
            if ~isempty(candidates)
                [min_d,min_idx] = min(cell2mat(candidates(:,2)));
                min_idx = candidates{min_idx,1};
                emptyCandidates = false;
            else
                emptyCandidates = true;
            end
            
        end
        

        
        function k = computeKernel(obj,data_idx,s)
            x=obj.data_sets{data_idx,1}; 
            n = size(x,2);

            if nargin == 2
                % Compute Gram Matrix for data_idx
                k = zeros(n,n);
                for idx1=1:n   
                    dists = computeDiffWithNormalizedData(obj,x(:,idx1),x,obj.data_stddev{data_idx,1});
                    dists=dists.^2;
                    dists(5,:) = dists(5,:)*2;
                    k(idx1,:) = exp(-sum(dists)./(2*10));
                end
            elseif nargin==3
                % Compute equation (4) in my RSS paper
                x_mean = obj.data_mean{data_idx,1};
                x_stddev = obj.data_stddev{data_idx,1};
                s = s-x_mean;
                s = s./x_stddev;
                
                dists = computeDiffWithNormalizedData(obj,s,x,x_stddev);  
                dists=dists.^2;
                dists(5,:) = dists(5,:)*2;
                sum_kernel = sum( exp(-sum(dists)./(2*10)) );
                k = 1 - (2/n)*sum_kernel + obj.self_discrepancy(data_idx,1);
            end 
        end
        
         function u = predict(obj,x,idx)
            x = fixTheta(obj,x); 
            
            if nargin<3
                [~,idx,~,~] = checkDiscrepancy(obj,x);
            end
            
            idx
            x = x-obj.data_mean{idx,1};
            x = x./obj.data_stddev{idx,1};
            
            ctrller = obj.controllers{idx,1};
            u = ctrller.predict(x');
        end
   end    
end
