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
            x_data = fixAngleTobeBetweenZeroAndThreeSixty(obj,x_data);

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
            
            % compute the self discreapancy
            obj.self_discrepancy(obj.n_mmd_itern,1) = 1/(n_data^2)*sum(sum(obj.computeGramMatrix(x_data,sigma(3))));

            % compute the maximum MMD from each point to the center of
            % dataset
            obj.max_d(obj.n_mmd_itern) = -Inf;
            for idx = 1:size(x_data,2)
                x = x_data(:,idx);
                k = obj.computeMMD(x,x_data,mu,sigma,mu,sigma, (obj.self_discrepancy(obj.n_mmd_itern,1)) ); 
                if k>=obj.max_d(obj.n_mmd_itern)
                    obj.max_d(obj.n_mmd_itern) = k;
                end
            end
            
            n_replicate = 1;
            x_data = repmat(x_data,1,n_replicate);
            y_data = repmat(y_data,1,n_replicate);
            rng(obj.RF_seed);
            obj.controllers{obj.n_mmd_itern,1} = TreeBagger(50,x_data(1:4,:)',y_data','Method','regression','MinLeaf',1);
        end
        
        function mmd = computeMMD(obj,x1,x2,mu1,sigma1,mu2,sigma2,g2)
            %% NOTE: This function takes ONLY noramlized data
            if (~isequal(mu1,mu2)|| ~isequal(sigma1,sigma2))
                % if two datasets have different mean and sigma,
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
            n=size(x1,2);
            g1 = sum(sum(obj.computeGramMatrix(x1,sigma(3))))/(n^2);
            
            % compute the Gram matrix of x2 
             m = size(x2,2);
            if ~exist('g2','var') || (~isequal(mu1,mu2)|| ~isequal(sigma1,sigma2))
                g2 = sum(sum((obj.computeGramMatrix(x2,sigma(3)))))/(m^2);
            end
            % compute K(x1,x2)
            K = zeros(n,m);
            for idx=1:n
                dists = computeDistanceBetweenStates(obj,x1(:,idx),x2,sigma(3));
                K(idx,:) = obj.rbf_kernel(dists);
            end
            mmd = g1 + g2 - 2*sum(sum(K))/(n*m);
        end
            
        function [x,mu,sigma] = normalizeData(obj,x)
            mu = mean(x,2);
            sigma = std(x,[],2);
            if any(sigma<exp(-5)) == 1
                sigma(sigma<exp(-5)) = 1;
            end
            x = bsxfun(@minus,x,mu);
            x = bsxfun(@rdivide,x,sigma);
        end
        
        function k = computeGramMatrix(obj,x,theta_stddev)
            %% Takes only normalized data
            n = size(x,2);
            k = zeros(n,n);
            for idx1=1:n   
                dists = computeDistanceBetweenStates(obj,x(:,idx1),x,theta_stddev);
                k(idx1,:) = obj.rbf_kernel(dists);
            end
        end
        
        function dist_matrix = computeDistance(obj,x,D,theta_stddev)
            % computes the distance between x1 (n by 1)and x2
            % (n by m). The output is n by m matrix
            assert(size(x,2)==1,'x size not 1');
            
            diff_matrix = abs(bsxfun(@minus,x,D));
            
            % compute the difference in the theta, the third state
            % dimension
            theta_diff = diff_matrix(3,:)*theta_stddev;
            theta_diff(theta_diff>pi) = 2*pi - theta_diff(theta_diff>pi);
            if any(theta_diff<0) || any(theta_diff>pi)
                    fprintf('Wrong angle difference detected')
                    keyboard;
            end
            diff_matrix(3,:) = theta_diff;
            
%             difference = abs(bsxfun(@minus,x1,x2));
%             theta_dists = difference(3,:)*theta_std_dev;
%             wrong_th_dists = find(abs(theta_dists)>pi);
%             while ~isempty(wrong_th_dists)
%                 theta_dists(wrong_th_dists) = min(abs(theta_dists(wrong_th_dists)),abs(2*pi-abs(theta_dists(wrong_th_dists))));
%                 if any(theta_dists<0)
%                     fprintf('Wrong angle difference detected')
%                     return;
%                 end
%                 wrong_th_dists = find(abs(theta_dists)>pi); 
%             end
%             difference(3,:) = theta_dists*theta_std_dev;
%             diff_x = difference;
            
            
            if ~exist('Q','var')
                Q = eye(size(x1,1));
                Q(1,1) = 10;
                Q(2,2) = 10;
                Q(3,3) = 15;
                Q(4,4) = 15;
                if size(x1,1) ==5
                    Q(5,5) = 20;
                end
            end
            dist_x = diff_matrix'*Q*diff_matrix;
            dist_matrix = (diag(dist_x));
        end
        
        function x_prime = fixAngleTobeBetweenZeroAndThreeSixty(obj,x)
            % our data must have theta value between 0 and 360
            theta = x(3,:);
            negtheta = find(theta<0);
            while ~isempty(negtheta)
                theta(negtheta) = theta(negtheta) + 2*pi;
                negtheta = find(theta<0);
            end
            
            overtheta = find(theta>2*pi);
            while ~isempty(overtheta)
                theta(overtheta) = theta(overtheta) - 2*pi;
                overtheta = find(theta<0);
            end
            
            x_prime = x;
            x_prime(3,:) = theta;
        end
        
        function [dist_x] = computeDistanceBetweenStates(obj,x1,x2,theta_std_dev,Q)
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
%                 if ~isempty(wrong_th_dists)
%                     fprintf('Wrong angle difference detected')
%                     %return;
%                 end
            end
            difference(3,:) = theta_dists*theta_std_dev;
            diff_x = difference;
            
            if ~exist('Q','var')
                Q = eye(size(x1,1));
                Q(1,1) = 10;
                Q(2,2) = 10;
                Q(3,3) = 15;
                Q(4,4) = 15;
                if size(x1,1) ==5
                    Q(5,5) = 20;
                end
            end
%             Q(1,1) = 1000000;
            dist_x = diff_x'*Q*diff_x;
            dist_x = (diag(dist_x));
        end
                
        function [min_d,min_idx,emptyCandidates,candidates,d_list] = checkDiscrepancy(obj,x)
            min_idx=1;
            min_d = inf;
            
            x = fixAngleTobeBetweenZeroAndThreeSixty(obj,x);
            
            %% computes the candidates
            assert(size(x,2)==1)
            candidates = {};
            d_list =[];
            for idx=1:size(obj.data_sets,1)
                data = obj.data_sets{idx,1};
                data_mu = obj.data_mean{idx,1};
                data_std = obj.data_stddev{idx,1};
                normed_x=x-data_mu;
                normed_x=normed_x./data_std;
                if size(obj.self_discrepancy,1)==0
                    curr_d = obj.computeMMD(normed_x,data,data_mu,data_std,data_mu,data_std);
                else
                    curr_d = obj.computeMMD(normed_x,data,data_mu,data_std,data_mu,data_std, obj.self_discrepancy(idx,1));
                end
                if curr_d <= obj.max_d(idx)
                    candidates{size(candidates,1)+1,1} = idx; candidates{size(candidates,1),2} = curr_d;
                    d_list= [d_list curr_d];
                end
            end
            
            %% computes the min_idx
            if ~isempty(candidates)
%                 [min_d,min_idx] = min(cell2mat(candidates(:,2)));
%                 min_idx = candidates{min_idx,1};
                candidate_idx = cell2mat(candidates(:,1));
                d_cand_list = zeros(numel(candidate_idx),1);
                for idx=1:numel(candidate_idx)
                    % pick the one with the closest distance
                    data_mu = obj.data_mean{candidate_idx(idx),1};
                    data_std = obj.data_stddev{candidate_idx(idx),1};
                    normed_x=x-data_mu;
                    normed_x=normed_x./data_std; 
                    d_cand_list(idx) = min(computeDistanceBetweenStates(obj,normed_x,obj.data_sets{candidate_idx(idx),1},data_std(3)));
                end
                [min_d,min_idx] = min(d_list);%min(d_cand_list);
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
        

        
        function k = rbf_kernel(obj,distance)
            % computes the kernel given distance
            sigma = 10;
            k = exp(-distance./(2*sigma));
        end

        function [u,idx] = predict(obj,x,idx)
            x = fixAngleTobeBetweenZeroAndThreeSixty(obj,x); 
            if nargin<3
                [~,idx,empty_cand,~,d_list] = checkDiscrepancy(obj,x);
                if empty_cand
                    [~,idx] = min(d_list);
                end
            end
            x = x-obj.data_mean{idx,1};
            x = x./obj.data_stddev{idx,1};
            ctrller = obj.controllers{idx,1};
            u = ctrller.predict(x(1:4,:)');
        end
        
   end    
end
