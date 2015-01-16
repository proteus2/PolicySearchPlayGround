data1 = obj.data_sets_unnormalized{1,1};
data2 = obj.data_sets_unnormalized{2,1}; 

figure; scatter(data1(1,:),data1(2,:));
hold on; scatter(data2(1,:),data2(2,:));
hold on; scatter(x(1),x(2),1200,'magenta');

dists1 = sum(bsxfun(@minus,x,data1).^2);
dists2 = sum(bsxfun(@minus,x,data2).^2); 

figure; plot(exp(-dists1./2));
hold on; plot(exp(-dists2./2));
legend('data1','data2')

load('traj6.mat')
visualizeTraj(x_traj_from_curr_loc,5);