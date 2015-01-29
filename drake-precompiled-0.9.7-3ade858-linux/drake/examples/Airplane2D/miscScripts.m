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
ref_traj = controller.data_sets_unnormalized{1,1};
    field = ObstacleField();
    field = field.GenerateRandomObstacles();    
 figure(25); clf;  hold on;
    v = PlaneVisualizer(p,field);
    v.draw(0,x0);
 hold on; scatter(ref_traj(1,:),ref_traj(2,:),'black')
hold on; scatter(x1(1,1:end),x1(2,1:end),'blue');
%  hold on; scatter(x2(1,1:end),x2(2,1:end),'blue');

if ~isempty(x)
hold on; scatter(x(1,:),x(2,:),100,'magenta','filled')
end

%%
hold on; scatter(x_to_attach(1,:),x_to_attach(2,:),'magenta')


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