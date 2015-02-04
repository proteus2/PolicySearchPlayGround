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
ref_traj = controller.data_sets_unnormalized{2,1};
    field = ObstacleField();
    field = field.GenerateRandomObstacles();    
 figure(25); clf;  hold on;
 p=PlanePlant();
    v = PlaneVisualizer(p,field);
    v.draw(0,[5;0;-1;0]);
 hold on; scatter(ref_traj(1,:),ref_traj(2,:),'black')
hold on; scatter(x1(1,1:end),x1(2,1:end),'blue');
%  hold on; scatter(x2(1,1:end),x2(2,1:end),'blue');

if ~isempty(x)
hold on; scatter(x(1,:),x(2,:),100,'magenta','filled')
end

hold on; scatter(x_to_attach(1,:),x_to_attach(2,:),'magenta')

%% Plotting mistakes vs distance from the center
ref_traj = controller.data_sets_unnormalized{1,1};
dists = sum(bsxfun(@minus,controller.data_mean{1},ref_traj).^2);
y=[];
for idx=1:size(ref_traj,2)
    y(idx) = controller.predict([ref_traj(:,idx);alpha;x0]);
end
train_err = abs((controller.data_sets_unnormalized{1,2} - y));

figure;plot(dists,'o')
hold on; plot(train_err,'o')
plot(ones(1,21),'black')
legend('dists','train_err')
%% visualizing trajectoreis
load('cost_list_kmm_vs_kmm_500'); 
idx=1;
for x0_idx=1:size(test_x0_list,2)
    x0=test_x0_list(:,x0_idx);
    for alpha_idx=1:numel(alpha_list)
        alpha = alpha_list(alpha_idx);
        x0,alpha
        traj = traj_list_all_alpha{idx,2};
        visualizeTraj(traj)
        idx = idx+1;
    end
end

%%
field = ObstacleField();
field = field.GenerateRandomObstacles();

t1= traj_list{1,1}.eval(traj_list{1,1}.getBreaks);
t2= traj_list{2,1}.eval(traj_list{2,1}.getBreaks);
opt = traj_list_opt{1,1}.eval(traj_list_opt{1,1}.getBreaks);
c1 = [];
c2 = [];
c3 = [];
for idx=1:size(t1,2)-1
x = t1(:,idx);
[c,dc] = field.obstacleConstraint(x);
[c,i]=max(c);
c1 = [c1 c];

x = t2(:,idx);
[c,dc] = field.obstacleConstraint(x);
[c,i]=max(c);
c2 = [c2 c];
end
for idx=1:size(opt,2)-1
x = opt(:,idx);
[c,dc] = field.obstacleConstraint(x);
[c,i]=max(c);
c3 = [c3 c];
end