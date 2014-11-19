


% sample 10 different alpha values from 10 different gaussian distribution
m_list = [10:100:1000;0.01:0.1:1];
alpha_list = zeros(10,2); idx=1;
for m = m_list(:,:)
    mu = m;
    SIGMA = [1 1.5; 1.5 3];
    alpha = mvnrnd(mu,SIGMA,1);
    alpha_list(idx,:) = alpha;
    idx = idx+1;
end


% run the trajectory optimization


% supervised learning using Random Forest

