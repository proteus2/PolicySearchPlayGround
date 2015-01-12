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
   end 
   methods
        function obj = MMDController()
            obj.n_mmd_itern = 0;
            obj.controllers = cell(0,1);
            obj.data_sets = cell(0,2);
            obj.data_sets_unnormalized = cell(0,2);
            obj.data_mean = cell(0,1);
            obj.data_stddev = cell(0,1);       
            obj.self_discrepancy = zeros(0,1);
        end

        function obj = setNewController(obj,x_data,y_data)
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
            
            obj.data_sets{obj.n_mmd_itern,1} = x_data;
            obj.data_sets{obj.n_mmd_itern,2} = y_data;
            
            n_data = size(x_data,2);
            obj.self_discrepancy(obj.n_mmd_itern,1) = 1/n_data^2 * sum(sum(obj.computeKernel(obj.n_mmd_itern)));
            obj.controllers{obj.n_mmd_itern,1} = TreeBagger(50,x_data',y_data','Method','regression');
        end

        function [min_d,min_idx] = checkDiscrepancy(obj,x)
            min_idx=1;
            min_d = inf;
            
            for idx=1:obj.n_mmd_itern
                curr_d = obj.computeKernel(idx,x);
                if curr_d < min_d
                    min_idx = idx;
                    min_d = curr_d;
                end
            end
        end

        function k = computeKernel(obj,data_idx,s)
            x=obj.data_sets{data_idx,1}; 
            n = size(x,2);

            if nargin == 2
                X = x;
                n1sq = sum(X.^2,1);
                n1 = size(X,2);
                D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*X'*X;
                K = exp(-D/(2));

                % Compute Gram Matrix
                k = zeros(n,n);
                for idx1=1:n   
                    dists = (bsxfun(@minus,x(:,idx1),x)).^2;
                    k(idx1,:) = exp(-sum(dists)./2);
%                     for idx2=1:n
%                         k(idx1,idx2) = obj.kernel(x(:,idx1),x(:,idx2));
%                     end
                end
            elseif nargin==3
                % Compute equation (4) in my RSS paper
                s = s-obj.data_mean{data_idx,1};
                s = s./obj.data_stddev{data_idx,1};
                
%                 sum_kernel=0;
                % replace this
%                 for idx=1:n
%                     sum_kernel = sum_kernel + obj.kernel(s,x(:,idx));
%                 end
                dists = (bsxfun(@minus,s,x)).^2;
                sum_kernel = sum( exp(-sum(dists)./2) );
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
                [~,idx] = checkDiscrepancy(obj,x);
            end
            %idx
            x = x-obj.data_mean{idx,1};
            x = x./obj.data_stddev{idx,1};
            
            ctrller = obj.controllers{idx,1};
            u = ctrller.predict(x');
        end
        

   end    
end