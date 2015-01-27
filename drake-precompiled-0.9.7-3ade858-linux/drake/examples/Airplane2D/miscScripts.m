data1 = obj.data_sets_unnormalized{1,1};
data2 = obj.data_sets_unnormalized{3,1}; 

figure; scatter(data1(1,:),data1(2,:));
hold on; scatter(data2(1,:),data2(2,:));
hold on; scatter(x(1),x(2),1200,'magenta');

dists1 = sum(bsxfun(@minus,x,data1).^2);
dists2 = sum(bsxfun(@minus,x,data2).^2); 

figure; plot((dists1));
hold on; plot((dists2));
legend('data1','data2')

sum(exp(-dists1./2))
sum(exp(-dists2./2))


%% Plotting mistake states, and reference trajectory - at the end of trainMMDver2
ref_traj = ref_traj_list{2,1};
figure; hold on; scatter(ref_traj(1,:),ref_traj(2,:),'black')
figure; scatter(x1(1,1:end),x1(2,1:end),'blue');
%  hold on; scatter(x2(1,1:end),x2(2,1:end),'blue');

if ~isempty(x)
hold on; scatter(x(1,:),x(2,:),100,'magenta','filled')
end

%%
hold on; scatter(x_to_attach(1,:),x_to_attach(2,:),'magenta')
