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
            
            % make all angles positive
            x_data = fixTheta(obj,x_data);

            % save the unprocessed, unnormalized data. 
            obj.n_mmd_itern = obj.n_mmd_itern + 1;
            obj.data_sets_unnormalized{obj.n_mmd_itern,1} = x_data;
            obj.data_sets_unnormalized{obj.n_mmd_itern,2} = y_data;

            % standardize the data
            [x_data,mu,sigma] = obj.normalizeData(x_data);
            obj.data_mean{obj.n_mmd_itern,1} = mu;
            obj.data_stddev{obj.n_mmd_itern,1} = sigma;

            % save the data that will be used to train the RF
            obj.data_sets{obj.n_mmd_itern,1} = x_data;
            obj.data_sets{obj.n_mmd_itern,2} = y_data;
            n_data = size(x_data,2);
            
            % compute the K, gram matrix.
            gramMatrix = obj.computeGramMatrix(x_data,sigma(3));
            obj.self_discrepancy(obj.n_mmd_itern,1) = 1/n_data^2 * sum(sum(gramMatrix));

            % compute the maximum MMD from each point to the center of
            % dataset
            obj.max_d(obj.n_mmd_itern) = -Inf;
            for idx = 1:size(x_data,2)
                x = x_data(:,idx);
                k = obj.computeMMD(x,x_data,mu,sigma,mu,simga); 
                if k>obj.max_d(obj.n_mmd_itern)
                    obj.max_d(obj.n_mmd_itern) = k;
                end
            end
            
            
%             obj.max_d(obj.n_mmd_itern) = -Inf;
%             for idx = 1:size(obj.data_sets_unnormalized{obj.n_mmd_itern,1},2)
%                 k = obj.computeKernel(obj.n_mmd_itern,obj.data_sets_unnormalized{obj.n_mmd_itern,1}(:,idx)); 
%                 if k>obj.max_d(obj.n_mmd_itern)
%                     obj.max_d(obj.n_mmd_itern) = k;
%                 end
%             end
            
            n_replicate = 5;
            x_data = repmat(x_data,1,n_replicate);
            y_data = repmat(y_data,1,n_replicate);
            rng(obj.RF_seed);
            obj.controllers{obj.n_mmd_itern,1} = TreeBagger(50,x_data',y_data','Method','regression','MinLeaf',1);
        end
        
        function mmd = computeMMD(obj,x1,x2,mu1,sigma1,mu2,sigma2)
            if ~(mu1 == mu2 && sigma1 == sigma2)
                x1 = bsxfun(@times,x1,simga1) + mu1;
                x2 = bsxfun(@times,x2,simga1) + mu2;
            end
            % compute the Gram matrix of x1
            g1 = obj.computeGramMatrix(x1,x1_stddev);
            
            % compute the Gram matrix of x2
            g2 = obj.computeGramMatrix(x2,x2_stddev);
            
            % compute K(x1,x2)
        end
            
        function [x,mu,sigma] = normalizeData(obj,x)
            mu = mean(x,2);
            sigma = std(x',1)';
            if any(sigma==0) == 1
                sigma(sigma==0) = 1;
            end
            x = bsxfun(@minus,x,mu);
            x = bsxfun(@rdivide,x,sigma);
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
        
        function [diff_x] = computeDiff(obj,x1,x2,theta_std_dev)
            dists = abs(bsxfun(@minus,x1,x2));
            theta_dists = dists(3,:)*theta_std_dev;
   
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
            dists(3,:) = theta_dists;
            diff_x = dists;
        end
        
        
        function [min_d,min_idx,emptyCandidates,candidates] = checkDiscrepancy(obj,x)
            min_idx=1;
            min_d = inf;
            x = fixTheta(obj,x);
            
            candidates = {};
            d_list =[];
            for idx=1:size(obj.data_sets,1)
                curr_d = obj.computeKernel(idx,x);
                if curr_d <= obj.max_d(idx)
                    candidates{size(candidates,1)+1,1} = idx; candidates{size(candidates,1),2} = curr_d;
                    d_list= [d_list curr_d];
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
        
        function k = computeGramMatrix(obj,x,theta_stddev)
                n = size(x,2);
                k = zeros(n,n);
                for idx1=1:n   
                    difference = computeDiff(obj,x(:,idx1),x,theta_stddev);
                    difference=difference.^2;
                    dists = sum(difference);
                    k(idx1,:) = obj.rbf_kernel(-dists);
                end
%                 % Compute kernel between the x1 and x2
%                 x_mean = obj.data_mean{data_idx,1};
%                 x_stddev = obj.data_stddev{data_idx,1};
%                 s = s-x_mean;
%                 s = s./x_stddev;
%                 
%                 dists = computeDiffWithNormalizedData(obj,s,x,x_stddev);  
%                 dists=dists.^2;
%                 sum_kernel = sum( exp(-sum(dists)./(2)) );
%                 k = 1 - (2/n)*sum_kernel + obj.self_discrepancy(data_idx,1);
        end
        

        function k = rbf_kernel(obj,distance)
            % computes the kernel given distance
            sigma = 5;
            k = exp(-distance./(2*sigma));
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
