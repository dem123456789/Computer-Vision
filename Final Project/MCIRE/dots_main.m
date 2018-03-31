clear
close all
load('ransac_dots.mat')
im = imread('./data/dots_outliers.tif');
dims = size(im);
inds = find(im);
[dta_y,dta_x] = ind2sub(dims(1:2), inds);
[m_x,std_x,m_y,std_y] = getStats(dta_x,dta_y);
x_norm = normalize(dta_x,m_x,std_x);
y_norm = normalize(dta_y,m_y,std_y);
numSamples = size(dta_x,1);

num_param = 2;
num_iter = 1000;
valid_iter = 100;
num_em = 30;
samples = zeros(num_param+1,num_iter);

X = [x_norm ones(numSamples,1)];
y = y_norm;
sigma2 = gamrnd(1,1);
beta_hats = zeros(num_param,num_em);
z_0 = ones(numSamples,1);
z = ones(numSamples,num_em+1);
p_hats = ones(1,num_em);
triggerd_p = 0.98;
inliers_idx = 1:numSamples;


a=0.01;b=0.01;
epsilon = 0.1;
min_epsilon = 0.001;
stuck_counts = 0;
num_ifstuck = 3;
t = 0;


for e=1:num_em
    X_z = X(logical(z(:,e)),:);
    y_norm_z = y(logical(z(:,e)),:);
    cur_numSamples = size(X_z,1);
    XtX_inv = inv(X_z'*X_z);
    beta_hat = XtX_inv*X_z'*y_norm_z;
    beta_hats(:,e) = beta_hat;
    n = size(X_z,1);
    %% MCMC
    while t < num_iter
        t = t + 1;
        beta  = mvnrnd(beta_hat,sigma2*XtX_inv)';
        sigma2 = 1/gamrnd(n/2+a,sum((y_norm_z-X_z*beta).^2)/2+b);
        samples(:,t) = [beta;sigma2];
    end
    t = 0;
    valid_samples = samples(:,valid_iter:end);
    %plotMCMC(valid_samples) % Comment out to plot mcmc
    
    %% IRE
    posteriorMean = mean(valid_samples,2);
    T = unique(valid_samples','rows')';
    y_predict_norm = bsxfun(@plus,X_z(:,1)*T(1,:),T(2,:));
    distance = @(y_predict,y) (y_predict-y).^2;
    E = bsxfun(distance,y_predict_norm,y_norm_z);
    E_sorted = sort(E,1);
    r_min = min(E_sorted,[],2);
    v_epsilon = sum(bsxfun(@lt,E_sorted,r_min+epsilon),2);
    minIndex = find(v_epsilon==min(v_epsilon),1,'last');
    p_hats(e) = min(triggerd_p,minIndex/numSamples);
    p_hat =  p_hats(e)*numSamples/cur_numSamples;
    nInliers = max(1,round(p_hat*cur_numSamples));
    y_predict_norm = bsxfun(@plus,X_z(:,1)*posteriorMean(1),posteriorMean(2));
    error = bsxfun(distance,y_predict_norm,y_norm_z);
    [~,sortidx] = sort(error);
    inliers = sortidx(1:nInliers);
    outliers = sortidx(nInliers+1:end);
    outliers_idx = inliers_idx(outliers);
    if(length(inliers_idx)==nInliers)
        stuck_counts = stuck_counts + 1;
    else
        stuck_counts = 0;
    end
    inliers_idx = inliers_idx(sort(inliers));
    tmp = z(:,e);
    tmp(outliers_idx) = 0;
    z(:,e+1) = tmp;

%% Optional
    if(stuck_counts==num_ifstuck)
        epsilon = epsilon/2;
        stuck_counts = 0;
    end
    cur_epsilon = epsilon;
    
    if(epsilon<min_epsilon)
        %break;
    end 
    
    %% Visualization    
    figure('pos',[300 300 400 800]); 
    scatter(dta_x,dta_y); 
    hold on;
    x_result = [1 dims(2)];
    x_result_norm = normalize(x_result,m_x,std_x);
    for i=1:size(valid_samples,2)
        y_result_norm = valid_samples(1,i)*x_result_norm + valid_samples(2,i);
        y_result = denormalize(y_result_norm,m_y,std_y);
        p0 = plot(x_result, y_result, 'g-', 'LineWidth', 3);
    end
    y_postmean_norm = posteriorMean(1)*x_result_norm + posteriorMean(2);
    y_postmean = denormalize(y_postmean_norm,m_y,std_y);
    y_ransac = lineConsensus(1)*x_result + lineConsensus(2);
    p1 = plot(x_result, y_postmean, 'b-', 'LineWidth', 2);
    p2 = plot(x_result, y_ransac, 'y-', 'LineWidth', 2);
    p3 = scatter(dta_x(~logical(tmp)), dta_y(~logical(tmp)), 'filled');
    legend([p0,p1,p2,p3],'MCMC samples','Posterior Mean','RANSAC','Outliers','Location', 'Best')
    title(sprintf('iter: %d, inlier rate: %.3f, epsilon: %.3f',e,p_hats(e),cur_epsilon))
    %tightfig;
    filenmae = sprintf('./output/dots/%d.tiff',e);
    print(filenmae,'-dtiff',['-r' '300']);
%     close all

end 

%% Final run from inliers
X_z = X(logical(z(:,e)),:);
y_norm_z = y(logical(z(:,e)),:);
cur_numSamples = size(X_z,1);
XtX_inv = inv(X_z'*X_z);
beta_hats(:,end) = XtX_inv*X_z'*y_norm_z;
save('./output/dots/result.mat','inliers_idx','beta_hats')


















