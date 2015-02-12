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
%             gramMatrix = obj.computeGramMatrix(x_data,sigma(3));
%             obj.self_discrepancy(obj.n_mmd_itern,1) = 1/n_data^2 * sum(sum(gramMatrix));

            % compute the maximum MMD from each point to the center of
            % dataset
            obj.max_d(obj.n_mmd_itern) = -Inf;
            
            far_x_list = [];
            d_list = [];
            for idx = 1:size(x_data,2)
                x = x_data(:,idx);
                k = obj.computeMMD(x,x_data,mu,sigma,mu,sigma); 
                d_list = [d_list k];
                if k>=obj.max_d(obj.n_mmd_itern)
                    obj.max_d(obj.n_mmd_itern) = k;
                    far_x_list = [far_x_list x];
                end
            end
%                         far_x_list(:,1) = [];
% 
%             figure;scatter(x_data(1,:),x_data(2,:))
%             hold on;scatter(far_x_list(1,:),far_x_list(2,:))
            
            n_replicate = 3;
            x_data = repmat(x_data,1,n_replicate);
            y_data = repmat(y_data,1,n_replicate);
            rng(obj.RF_seed);
            obj.controllers{obj.n_mmd_itern,1} = TreeBagger(50,x_data(1:4,:)',y_data','Method','regression','MinLeaf',1);
        end
        
        function mmd = computeMMD(obj,x1,x2,mu1,sigma1,mu2,sigma2)
            %% NOTE: This function takes ONLY noramlized data
            if (~isequal(mu1,mu2)|| ~isequal(sigma1,sigma2))
                % if two datasets have differen tmean and sigma,
                % unnormalize and renomralize.
                x1 = bsxfun(@times,x1,simga1) + mu1;
                x2 = bsxfun(@times,x2,simga2) + mu2;
                n = size(x1,2);
                [x,~,sigma] = obj.normalizeData([x1 x2]);
                x1 = x(:,1:n);
                x2 = x(:,n+1:end);
            else 
                sigma = sigma1;
            end
            
            % compute the Gram matrix of x1
            g1 = obj.computeGramMatrix(x1,sigma(3));
            
            % compute the Gram matrix of x2
            g2 = obj.computeGramMatrix(x2,sigma(3));
            
            % compute K(x1,x2)
            n=size(x1,2); m = size(x2,2);
            K = zeros(n,m);
            for idx=1:n
                dists = computeDistance(obj,x1(:,idx),x2,sigma(3));
                K(idx,:) = obj.rbf_kernel(dists);
            end
            
            mmd = sum(sum(g1))/(n^2) + sum(sum(g2))/(m^2) - 2*sum(sum(K))/(n*m);
        end
            
        function [x,mu,sigma] = normalizeData(obj,x)
            mu = mean(x,2);
            sigma = std(x,0,2);
            if any(sigma<exp(-5)) == 1
                sigma(sigma<exp(-5)) = 1;
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
        
        function [dist_x] = computeDistance(obj,x1,x2,theta_std_dev,Q)
            %% Must FIX and NORMALIZE both x1 with same mean and std dev first
            assert(size(x1,2)==1,'x1 size not 1');
            
            difference = abs(bsxfun(@minus,x1,x2));
            theta_dists = difference(3,:)*theta_std_dev;
   
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
                    %return;
                end
            end
            difference(3,:) = theta_dists*theta_std_dev;
            diff_x = difference;
            
            if ~exist('Q','var')
            Q = eye(size(x1,1));
            Q(1,1) = 10;
            Q(2,2) = 10;
            Q(3,3) = 15;
            Q(4,4) = 10;
            Q(5,5) = 1;
            end
%             Q(1,1) = 1000000;
            dist_x = diff_x'*Q*diff_x;
            dist_x = (diag(dist_x));
        end
                
        function [min_d,min_idx,emptyCandidates,candidates,d_list] = checkDiscrepancy(obj,x)
            min_idx=1;
            min_d = inf;
            
            x = fixTheta(obj,x);
            
            assert(size(x,2)==1)
            candidates = {};
            d_list =[];
            for idx=1:size(obj.data_sets,1)
                data = obj.data_sets{idx,1};
                data_mu = obj.data_mean{idx,1};
                data_std = obj.data_stddev{idx,1};
                normed_x=x-data_mu;
                normed_x=normed_x./data_std;

                curr_d = obj.computeMMD(normed_x,data,data_mu,data_std,data_mu,data_std);
                d_list= [d_list curr_d];
                if curr_d <= obj.max_d(idx)
                    candidates{size(candidates,1)+1,1} = idx; candidates{size(candidates,1),2} = curr_d;
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
        
        function flag = checkNormalized(obj,x)
            flag = false;
            if isequal(round(mean(x,2)), zeros(size(x,1),1))
                    %&& ( isequal(round(std(x,0,2)),zeros(size(x,1))) || isequal(floor(std(x,0,2)), zeros(size(x,1),1)))
                flag = true;
            end
                
            
        end
        
        function k = computeGramMatrix(obj,x,theta_stddev)
            %% Takes only normalized data
            n = size(x,2);
            k = zeros(n,n);
            for idx1=1:n   
                dists = computeDistance(obj,x(:,idx1),x,theta_stddev);
                k(idx1,:) = obj.rbf_kernel(dists);
            end
        end
        
        function k = rbf_kernel(obj,distance)
            % computes the kernel given distance
            sigma = 100;
            k = exp(-distance./(2*sigma));
        end

        function u = predict(obj,x,idx)
            x = fixTheta(obj,x); 
            if nargin<3
                [~,idx,~,~] = checkDiscrepancy(obj,x);
            end
            x = x-obj.data_mean{idx,1};
            x = x./obj.data_stddev{idx,1};
            ctrller = obj.controllers{idx,1};
            u = ctrller.predict(x(1:4,:)');
        end
        
   end    
end
