%% TEST SCRIPT
 

%% Noramlize data test
mean(obj.data_sets_unnormalized{1,1},2) == mu
std(obj.data_sets_unnormalized{1,1},0,2) == sigma
mu
sigma
avg = mean(x_data,2)
dev = std(x_data,0,2)

%% computeDiff test
angles = [45,0,0,45,45,-45];
x1 =zeros(5,6); 
x1(3,:) = angles
x1(3,:)=x1(3,:)*pi/180;
x2 =zeros(5,6);
x2(3,1) = -45; x2(3,2)=180; x2(3,3)=360; x2(3,4)=-135; x2(3,5)=135; x2(3,6) = -135
x2(3,:) = x2(3,:) * pi/180


x1 = obj.fixTheta(x1);
x2 = obj.fixTheta(x2);
[x,~,sigma]=obj.normalizeData([x1 x2]);
x1 = x(:,1:6);
x2 = x(:,7:12);


answer= [90, 180,0,180,90,90];
temp = [];
for idx=1:6
    idx
    diffx=obj.computeDistance(x1(:,idx),x2,sigma(3));
    temp = [temp sqrt(diffx)/sigma(3)*180/pi];
end

%% test computeMMD
x = [1:10;1:10;zeros(1,10);1:10];
[normd_x,mu,sigma]=obj.normalizeData(x);
K=obj.computeDistance(normd_x(:,1),normd_x,sigma(3));