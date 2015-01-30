function theta = KMM(train_data,test_data,max_n_data)
temp_train = train_data;
temp_test = test_data;
    data_mean = mean([train_data, test_data],2);
    data_std =  std([train_data, test_data]')';
    data_std(end) = 1;
    theta_stddev = data_std(3);


    train_data = bsxfun(@minus,train_data,data_mean);
    train_data = bsxfun(@rdivide,train_data,data_std);

    test_data = bsxfun(@minus,test_data,data_mean);
    test_data = bsxfun(@rdivide,test_data,data_std);

    n_tr = size(train_data,2);
    n_te = size(test_data,2);

    K = zeros(n_tr,n_tr);
    for idx=1:n_tr
        dists = (bsxfun(@minus,train_data(:,idx),train_data)) ; 


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
        K(idx,:) = exp(-sum(dists)./(2*100));
    end


    k = zeros(n_tr,n_te);
    for idx=1:n_tr
        dists = (bsxfun(@minus,train_data(:,idx),test_data)) ; 

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
    k = n_tr/n_te*sum(k,2);

    lb_theta = zeros(n_tr,1);
    ub_theta = ones(n_tr,1);
    cvx_begin 
        variable theta(n_tr)
        minimize( 1/2*theta'*K*theta - k'*theta )
        subject to 
            lb_theta <= theta
    %         theta'*ones(n_tr,1) - 1 <= 1
    cvx_end

    theta = theta/min(theta);
    theta = theta/sum(theta)*max_n_data;
    theta = ceil(theta);
% 
%     p=PlanePlant()
%     field = ObstacleField();
%     field = field.GenerateRandomObstacles();    
%     figure(25); clf;  hold on;
%     v = PlaneVisualizer(p,field);
%     v.draw(0,[4.1203;0.3583;0;0]);
% 
%     hold on; scatter(temp_train(1,:),temp_train(2,:),theta)
%     hold on; scatter(temp_test(1,:),temp_test(2,:))
end
% 
% %% create new dataset
% theta = ceil(theta/min(theta));
% x_data = [];
% y_data = [];
% 
% original_x=controller.data_sets_unnormalized{1};
% original_y= controller.data_sets_unnormalized{2};
% for idx=1:size(train_data,2)
%     x_data = [x_data repmat(original_x(:,idx),1,theta(idx))];
%     y_data = [y_data repmat(original_y(:,idx),1,theta(idx))];
% end
%     load('RF_seed');
% controller = MMDAggregateController(RF_seed);
% controller = setNewController(controller,x_data,y_data);
% tf = size(x1,2)*0.01;
% alpha = 11;
% traj = EvaluateControllers({controller},x1(:,1),tf,alpha);
% 
% p=PlanePlant()
% field = ObstacleField();
% field = field.GenerateRandomObstacles();    
% figure(25); clf;  hold on;
% v = PlaneVisualizer(p,field);
% v.draw(0,x1(:,1));
% 
% hold on; scatter(train_data(1,:),train_data(2,:))
% hold on; scatter(test_data(1,:),test_data(2,:))
% traj_evaled=traj{1}.eval(traj{1}.getBreaks);
% hold on; scatter(traj_evaled(1,:),traj_evaled(2,:));
