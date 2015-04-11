x = [1,2,3,4;1000,2000,3000,4000];

x_query_1 = [2;7000];
x_query_2 = [50;5000];

% Looking at the data, x_q_1 should be much closer than x_query_2 to any of
% the data
dists1 = bsxfun(@minus,x_query_1,x).^2
dists2 = bsxfun(@minus,x_query_2,x).^2

% Let's see if our hypothesis is correct. Computing the L2 norm,
l2_norms_1 = sum(dists1)
l2_norms_2 = sum(dists2)
l2_norms_1<l2_norms_2

% It turns out that the l2 norm of query point 1 is larger than the second.

% Now normalize the data
sigma=std(x,[],2);
x_prime = bsxfun(@rdivide,bsxfun(@minus,x,mean(x,2)),1);
x_query_1_prime = (x_query_1-mean(x,2));
x_query_2_prime = (x_query_2-mean(x,2));
dists1=bsxfun(@minus,x_query_1_prime,x_prime).^2;
dists2=bsxfun(@minus,x_query_2_prime,x_prime).^2;
l2_norms_1 = sum(dists1)
l2_norms_2 = sum(dists2)
l2_norms_1<l2_norms_2

% Now, our hypothesis is correct - qpt 2 is further away from data points.
% Why was this possible through normalization?

% By subtracting the mean from every data point, we effectively represents
% each data point as a displacement from the mean.

% By dividing the displacements by the standard deviation, we effectively
% reduce the displacement by the factor of sigma - in otherwords, how many
% sigmas are you away from the mean?
sigma

% As a result, our data is now represented as number of sigmas away from
% mean. Since this sigma is large for big-scale feature and small for
% small-scale feature, this allows us to put data onto same scale.
