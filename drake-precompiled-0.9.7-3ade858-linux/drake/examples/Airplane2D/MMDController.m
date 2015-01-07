% Controller per iteration - n_mmd_itern of them
% Data set used for each controller
% Predict function that predicts an action for given state

classdef MMDController
   properties
       controllers;
       n_mmd_itern;
       data_sets;
       t;
       self_discrepancy;
   end 
   methods
        function obj = MMDController(t)
            obj.n_mmd_itern = 0;
            obj.controllers = cell(0,1);
            obj.data_sets = cell(0,2);
            obj.self_discrepancy = zeros(0,1);
            obj.t = t;
        end

        function obj = setNewController(obj,x_data,y_data)
            obj.n_mmd_itern = obj.n_mmd_itern + 1;
            obj.data_sets{obj.n_mmd_itern,1} = x_data;
            obj.data_sets{obj.n_mmd_itern,2} = y_data;
            
            [x,y]=aggregateDataFromCell(obj.data_sets(obj.n_mmd_itern,:));
            
            n_data = size(x,1);
            obj.self_discrepancy(obj.n_mmd_itern,1) = 1/n_data^2 * sum(sum(obj.computeKernel(obj.n_mmd_itern)));
            obj.controllers{obj.n_mmd_itern,1} = TreeBagger(50,x,y,'Method','regression');
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
            x=x.eval(obj.t);
            n = size(x,2);

            if nargin == 2
                % Compute Gram Matrix
                k = zeros(n,n);
                for idx1=1:n
                    for idx2=1:n
                        k(idx1,idx2) = obj.kernel(x(:,idx1),x(:,idx2));
                    end
                end
            elseif nargin==3
                % Compute equation (4) in my RSS paper
                sum_kernel=0;
                for idx=1:n
                    sum_kernel = sum_kernel + obj.kernel(s,x(:,idx));
                end
                k = 1 - 2/n*sum_kernel + obj.self_discrepancy(data_idx,1);
            end 
        end

        function k = kernel(obj,x1,x2)
            % only supports rbf
            
            sigma=1;
            d=norm(x1-x2);
            k = exp(-d/(2*sigma));
        end

        function u = predict(obj,x)
            [~,idx] = checkDiscrepancy(obj,x);
            ctrller = obj.controllers{idx,1};
            u = ctrller.predict(x');
        end
        

   end    
end