function mmd_val = computeMMD(x1,x2)
    data_mean = mean([x1, x2],2);
    data_std =  std([x1, x2]')';
    data_std(end) = 1;
    theta_stddev = data_std(3);


    x1 = bsxfun(@minus,x1,data_mean);
    x1 = bsxfun(@rdivide,x1,data_std);

    x2 = bsxfun(@minus,x2,data_mean);
    x2 = bsxfun(@rdivide,x2,data_std);

    n1 = size(x1,2);
    n2 = size(x2,2);
           
    K1 = zeros(n1,n1);
    for idx=1:n1
        dists = (bsxfun(@minus,x1(:,idx),x1)) ; 

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
        K1(idx,:) = exp(-sum(dists)./(2*100));
    end
    
    K2 = zeros(n2,n2);
    for idx=1:n2
        dists = (bsxfun(@minus,x2(:,idx),x2)) ; 

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
        K2(idx,:) = exp(-sum(dists)./(2*100));
    end
    
    k = zeros(n1,n2);
    for idx=1:n1
        dists = (bsxfun(@minus,x1(:,idx),x2)) ; 
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

        dists = dists.^2;
        k(idx,:) = exp(-sum(dists)./(2*100));
    end
    
    mmd_val = (1/n1^2)*sum(sum(K1)) + (1/n2^2)*sum(sum(K2)) - (2/(n1*n2))*sum(sum(k));
end
