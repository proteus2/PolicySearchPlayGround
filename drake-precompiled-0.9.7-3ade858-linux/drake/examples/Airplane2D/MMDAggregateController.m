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
            obj.controllers{1,1} = TreeBagger(50,x_data',y_data','Method','regression','MinLeaf',1);
        end
    
        function [normalized_data,mean_data,stddev_data] = normalizeData(obj,data_idx)
                x_data = obj.data_sets_unnormalized{data_idx,1};
                
                mean_data = mean(x_data,2);
                stddev_data = std(x_data',1)';
                if any(stddev_data==0) == 1
                    stddev_data(stddev_data==0) = 1;
                end
                
                normalized_data=bsxfun(@minus,x_data,mean_data);
                normalized_data=bsxfun(@rdivide,normalized_data,stddev_data);
        end
        
        function [min_d,min_idx,emptyCandidates] = checkDiscrepancy(obj,x)
            min_idx=1;
            min_d = inf;
            
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
                % Compute Gram Matrix
                k = zeros(n,n);
                for idx1=1:n   
                    dists = (bsxfun(@minus,x(:,idx1),x)) ; 
                    theta_stddev = obj.data_stddev{data_idx,1}(3);
                    
                    th_dist_idx_pos = find((dists(3,:))*theta_stddev  > pi);
                    while ~isempty(th_dist_idx_pos)
                        dists(3,th_dist_idx_pos) = (dists(3,th_dist_idx_pos)*theta_stddev   - 2*pi)./theta_stddev  ;
                        th_dist_idx_pos = find(dists(3,:)*theta_stddev  > pi);
                    end


                    th_dist_idx_neg =  (dists(3,:))*theta_stddev  < -pi;
                    while ~isempty(th_dist_idx_neg)
                        dists(3,th_dist_idx_neg) = (dists(3,th_dist_idx_neg)*theta_stddev   + 2*pi)./theta_stddev ;
                        th_dist_idx_neg =  find(dists(3,:)*theta_stddev  < -pi);
                    end
                
                    dists=dists.^2;
                    dists(end,:) = dists(end,:)*2;
%                     k(idx1,:) = -sum(dists)./(2);
                    k(idx1,:) = exp(-sum(dists)./(2*100));
%                     for idx2=1:n
%                         k(idx1,idx2) = obj.kernel(x(:,idx1),x(:,idx2));
%                     end
                end
            elseif nargin==3
                % Compute equation (4) in my RSS paper
                data_mean = obj.data_mean{data_idx,1};
                data_stddev = obj.data_stddev{data_idx,1};
                s = s-data_mean;
                s = s./data_stddev;
                
                dists = (bsxfun(@minus,s,x)) ; 
                theta_stddev = obj.data_stddev{data_idx,1}(3);
                
                th_dist_idx_pos = find((dists(3,:))*theta_stddev  > pi);
                while ~isempty(th_dist_idx_pos)
                    dists(3,th_dist_idx_pos) = (dists(3,th_dist_idx_pos)*theta_stddev   - 2*pi)./theta_stddev  ;
                    th_dist_idx_pos = find(dists(3,:)*theta_stddev  > pi);
                end


                th_dist_idx_neg =  (dists(3,:))*theta_stddev  < -pi;
                while ~isempty(th_dist_idx_neg)
                    dists(3,th_dist_idx_neg) = (dists(3,th_dist_idx_neg)*theta_stddev   + 2*pi)./theta_stddev ;
                    th_dist_idx_neg =  find(dists(3,:)*theta_stddev  < -pi);
                end
                    
                dists=dists.^2;
                dists(end,:) = dists(end,:)*2;
                sum_dists = sum(dists);
                sum_kernel = sum( exp(-sum_dists./(2*100)) );
                k = 1 - (2/n)*sum_kernel + obj.self_discrepancy(data_idx,1);
           
            end 
        end
        
        function u = predict(obj,x,idx)
            if nargin<3
                [~,idx,~] = checkDiscrepancy(obj,x);
            end
            x = x-obj.data_mean{idx,1};
            x = x./obj.data_stddev{idx,1};
            
            ctrller = obj.controllers{idx,1};
            u = ctrller.predict(x');
        end
   end    
end
