function mmd_val = computeMMD(x1,x2)
            if obj.n_mmd_itern == 0
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
                dists(5,:) = dists(5,:)*2;
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
                    dists(5,:) = dists(5,:)*2;
                    k(idx1,:) = exp(-sum(dists)./2);
                end
                b = -2/(m*n)*sum(sum(k));
                
                mmd_list(data_idx) = a+b+c;
            end
            
            [min_mmd,min_mmd_idx] = min(mmd_list);
            
        end

end