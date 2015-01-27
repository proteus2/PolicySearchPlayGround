% Controller per iteration - n_mmd_itern of them
% Data set used for each controller
% Predict function that predicts an action for given state

classdef MMDController
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
        function obj = MMDController(RF_seed)
            obj.n_mmd_itern = 0;
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
            
            if obj.n_mmd_itern == 0
                obj.n_dataset = size(x_data,2);
            end
            
            % Check the mmd discrepancy between the new data and the existing data
            [min_mmd,min_mmd_idx] = obj.computeMMD(x_data);
            % if the mmd value is less than the set treshold, then aggregate the data. Retrain the controller
%             if (min_mmd < obj.mmd_threshold)
%                 obj.data_sets_unnormalized{min_mmd_idx,1} = [obj.data_sets_unnormalized{min_mmd_idx,1} x_data];
%                 obj.data_sets_unnormalized{min_mmd_idx,2} = [obj.data_sets_unnormalized{min_mmd_idx,2} y_data];
%                 [x_data,new_mean,new_std] = obj.normalizeData(min_mmd_idx);
%                 
%                 obj.data_mean{min_mmd_idx,1} = new_mean;
%                 obj.data_stddev{min_mmd_idx,1} = new_std;
%                 
%                 obj.data_sets{min_mmd_idx,1} = x_data;
%                 obj.data_sets{min_mmd_idx,2} = obj.data_sets_unnormalized{min_mmd_idx,2};
%                 
%                 n_data = size(obj.data_sets{min_mmd_idx,1},2);
%                 obj.self_discrepancy(min_mmd_idx,1) = 1/n_data^2 * sum(sum(obj.computeKernel(min_mmd_idx)));
%                 obj.controllers{min_mmd_idx,1} = TreeBagger(50,obj.data_sets{min_mmd_idx,1}',obj.data_sets{min_mmd_idx,2}','Method','regression','MinLeaf',1);
%             % else, create a new controller
%             else
%                 neg_theta_idx = (x_data(3,:) < 0);
%                 x_data(3,neg_theta_idx) = x_data(3,neg_theta_idx) + 2*pi;
                obj.n_mmd_itern = obj.n_mmd_itern + 1;
                obj.data_sets_unnormalized{obj.n_mmd_itern,1} = x_data;
                obj.data_sets_unnormalized{obj.n_mmd_itern,2} = y_data;

                % normailze the data
                mu = mean(x_data,2);
                sigma = std(x_data',1)';
                if any(sigma==0) == 1
                    sigma(sigma==0) = 1;
                end
                obj.data_mean{obj.n_mmd_itern,1} = mu;
                obj.data_stddev{obj.n_mmd_itern,1} = sigma;
                x_data=bsxfun(@minus,x_data,obj.data_mean{obj.n_mmd_itern,1});
                x_data=bsxfun(@rdivide,x_data,obj.data_stddev{obj.n_mmd_itern,1});

%                 if size(x_data,2) < obj.n_dataset
%                     num_replicate = floor(obj.n_dataset/size(x_data,2));
%                     x_data = repmat(x_data,1,num_replicate);
%                     y_data = repmat(y_data,1,num_replicate);
%                 end

                obj.data_sets{obj.n_mmd_itern,1} = x_data;
                obj.data_sets{obj.n_mmd_itern,2} = y_data;

                n_data = size(x_data,2);
                G = obj.computeKernel(obj.n_mmd_itern);
                obj.self_discrepancy(obj.n_mmd_itern,1) = 1/n_data^2 * sum(sum(obj.computeKernel(obj.n_mmd_itern)));
                
                % compute the maximum distance to the center of the dataset
                obj.max_d(obj.n_mmd_itern) = -Inf;
                for idx = 1:size(obj.data_sets_unnormalized{obj.n_mmd_itern,1},2)
                    k = obj.computeKernel(obj.n_mmd_itern,obj.data_sets_unnormalized{obj.n_mmd_itern,1}(:,idx)); 
                    if k>obj.max_d(obj.n_mmd_itern)
                        obj.max_d(obj.n_mmd_itern) = k;
                    end
                end
                
                    num_replicate = 10;
                    x_data = repmat(x_data,1,num_replicate);
                    y_data = repmat(y_data,1,num_replicate);
                rng(obj.RF_seed);
                obj.controllers{obj.n_mmd_itern,1} = TreeBagger(50,x_data',y_data','Method','regression','MinLeaf',1);
            end
%         end
    
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
        
        function [min_mmd,min_mmd_idx]=computeMMD(obj,x_data)
            if obj.n_mmd_itern == 1
                min_mmd = Inf;
                min_mmd_idx = -1;
                return;
            end
            n_datasets = size(obj.data_sets,1);
            mmd_list = zeros(n_datasets,1);
            
            x2=x_data;
            m = size(x2,2);
            k = zeros(m,m);
            for idx1=1:m
                dists = (bsxfun(@minus,x2(:,idx1),x2)) ; 
                dists=dists.^2;
                dists(end,:) = dists(end,:)*2;
                k(idx1,:) = exp(-sum(dists)./(2));
            end
            c=1/m^2*sum(sum(k));
            
            for data_idx = 1:n_datasets
                x=obj.data_sets{data_idx,1}; 
                n = size(x,2);
%                 k = zeros(n,n);
%                 for idx1=1:n   
%                     dists = (bsxfun(@minus,x(:,idx1),x)) ; 
%                     dists=dists.^2;
%                     dists(end,:) = dists(end,:)*2;
%                     k(idx1,:) = exp(-sum(dists)./(2));
%                 end
%                 a=1/n^2*sum(sum(k));
                a = obj.self_discrepancy(data_idx,1);
                
                mean_data = obj.data_mean{data_idx,1};
                stddev_data = obj.data_stddev{data_idx,1};
                x2=bsxfun(@minus,x_data,mean_data);
                x2=bsxfun(@rdivide,x2,stddev_data);
            
                k = zeros(n,m);
                for idx1=1:n
                    dists = (bsxfun(@minus,x(:,idx1),x2)) ; 
                    dists = dists.^2;
                    dists(end,:) = dists(end,:)*2;
                    k(idx1,:) = exp(-sum(dists)./2);
                end
                b = -2/(m*n)*sum(sum(k));
                
                mmd_list(data_idx) = a+b+c;
            end
            
            [min_mmd,min_mmd_idx] = min(mmd_list);
            
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
                
%                 sum_kernel=0;
                % replace this
%                 for idx=1:n
%                     sum_kernel = sum_kernel + obj.kernel(s,x(:,idx));
%                 end
%             
%                 dists1 = (bsxfun(@minus,s(1:4,1),x(1:4,:))).^2;
%                 
%                 dists2 = 2*(bsxfun(@minus,s(5,1),x(5,:))).^2;
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
        

        function k = kernel(obj,x1,x2)
            % only supports rbf
           
            sigma=1;
            d=norm(x1-x2)^2;
            k = exp(-d/(2*sigma));
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
        
        function obj = setNewController2(obj,x_data,y_data)
            
            if obj.n_mmd_itern == 0
                obj.n_dataset = size(x_data,2);
            end
            obj.n_mmd_itern = obj.n_mmd_itern + 1;
            obj.data_sets_unnormalized{obj.n_mmd_itern,1} = x_data;
            obj.data_sets_unnormalized{obj.n_mmd_itern,2} = y_data;

            % Get the data collected so far, and aggregate them
            
            
            % Train the new classifier
            mu = mean(x_data,2);
            sigma = std(x_data',1)';
            if any(sigma==0) == 1
                sigma(sigma==0) = 1;
            end
            x_data=bsxfun(@minus,x_data,obj.data_mean{obj.n_mmd_itern,1});
            x_data=bsxfun(@rdivide,x_data,obj.data_stddev{obj.n_mmd_itern,1});

            obj.data_sets{obj.n_mmd_itern,1} = x_data;
            obj.data_sets{obj.n_mmd_itern,2} = y_data;

            n_data = size(x_data,2);
            G = obj.computeKernel(obj.n_mmd_itern);
            obj.self_discrepancy(obj.n_mmd_itern,1) = 1/n_data^2 * sum(sum(obj.computeKernel(obj.n_mmd_itern)));

            % compute the maximum distance to the center of the dataset
            obj.max_d(obj.n_mmd_itern) = -Inf;
            for idx = 1:size(obj.data_sets_unnormalized{obj.n_mmd_itern,1},2)
                k = obj.computeKernel(obj.n_mmd_itern,obj.data_sets_unnormalized{obj.n_mmd_itern,1}(:,idx)); 
                if k>obj.max_d(obj.n_mmd_itern)
                    obj.max_d(obj.n_mmd_itern) = k;
                end
            end
%                 
%                     num_replicate = 10;
%                     x_data = repmat(x_data,1,num_replicate);
%                     y_data = repmat(y_data,1,num_replicate);
            rng(obj.RF_seed);
            obj.controllers{obj.n_mmd_itern,1} = fitcknn(x_data',y_data');%TreeBagger(50,x_data',y_data','Method','regression','MinLeaf',1);
        end
   end    
end
