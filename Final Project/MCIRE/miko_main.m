clear
close all
x1_id = 1;
x2_id = 5;
x1_path = sprintf('./data/miko/img%d.bmp',x1_id);
x2_path = sprintf('./data/miko/img%d.bmp',x2_id);
GT_H = dlmread(sprintf('./data/miko/H%dto%dp',x1_id,x2_id));
x1 = imread(x1_path);
x2 = imread(x2_path);
[h1,w1,~] = size(x1);
[h2,w2,~] = size(x2); 
x1_corners = [[1;1;w1;w1],[1;h1;h1;1]];
x2_corners_GT = [x1_corners ones(4,1)]*GT_H';
x2_corners_GT = bsxfun(@rdivide,x2_corners_GT,x2_corners_GT(:,3));

min_shift = 1.3;
[dta_x,dta_y] = getDatafromSIFT(x1,x2,min_shift);
% save('./data/miko/dta_%dto%dp.mat','dta_x','dta_y')
% load('./data/miko/dta_%dto%dp.mat')

numSamples = size(dta_x,1);
T_x = getT(dta_x);
T_y = getT(dta_y);
x_norm = (T_x*[dta_x ones(numSamples,1)]')';
y_norm = (T_y*[dta_y ones(numSamples,1)]')';


num_param = 3;
num_iter = 5000;
valid_iter = 100;
num_em = 30;
samples_beta = zeros(num_param,num_param,num_iter);
samples_sigma2 = zeros(1,num_iter);
samples = zeros(num_param,num_iter);




sigma2 =  gamrnd(1,1);
beta_hats = zeros(num_param,num_param,num_em);
z_0 = ones(numSamples,1);
z = ones(numSamples,num_em+1);
p_hats = ones(1,num_em);
triggerd_p = 1;
inliers_idx = 1:numSamples;

a=0.01;b=0.01;
epsilon = 0.1;
min_epsilon = 1e-3;
stuck_counts = 0;
num_ifstuck = 3;
t = 0;


for e=1:num_em
    x_norm_z = x_norm(logical(z(:,e)),:);
    y_norm_z = y_norm(logical(z(:,e)),:);
    cur_numSamples = size(x_norm_z,1);
    X_z = getA(x_norm_z',y_norm_z',cur_numSamples);

    XtX_inv = inv(x_norm_z'*x_norm_z);
%     [~, ~, V] = svd(X_z);
%     h = V(:, end);
%     beta_hat = reshape(h, [3 3]);
    beta_hat = x_norm_z\y_norm_z;
    beta_hats(:,:,e) = beta_hat;
    n = cur_numSamples;
    %% MCMC
    while t < num_iter
        t = t + 1;
        beta  = mvnrnd(beta_hat,sigma2*XtX_inv)';
        sigma2 =  1/gamrnd(n/2+a,sum(sqrt(sum((y_norm_z-x_norm_z*beta).^2)))/2+b);
        samples_beta(:,:,t) = beta;
        samples_sigma2(:,t) = sigma2;
    end
    t = 0;
    valid_samples = samples_beta(:,:,valid_iter:end);
    tmp_valid_samples = reshape(valid_samples,num_param*num_param,size(valid_samples,3));
%     plotMCMC(tmp_valid_samples) % Comment out to plot mcmc
    
    %% IRE
    posteriorMean = mean(valid_samples,3);
    [~,ia,~] = unique(tmp_valid_samples','rows');
    T = valid_samples(:,:,ia);
    n_T = length(ia);
    y_predict_norm = zeros(n,num_param,n_T);
    E = zeros(n,n_T);
    for k = 1:length(ia)
        H_k = T(:,:,k);
        y_predict_norm(:,:,k) = x_norm_z*H_k;
        E(:,k) = sum((y_predict_norm(:,:,k)-y_norm_z).^2,2);
    end
    E_sorted = sort(E,1);
    r_min = min(E_sorted,[],2);
    v_epsilon = sum(bsxfun(@lt,E_sorted,r_min+epsilon),2);
    minIndex = find(v_epsilon==min(v_epsilon),1,'last');
    p_hats(e) = min(triggerd_p,minIndex/numSamples);
    p_hat =  p_hats(e)*numSamples/cur_numSamples;
    nInliers = max(1,round(p_hat*cur_numSamples));
    
    
    y_predict_norm = x_norm_z*posteriorMean;
    error = sqrt(sum((y_predict_norm-y_norm_z).^2,2));
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
        break;
    end   


    
   %% Visualization
    figure('pos',[300 300 900 600]);
    subplot(1,2,1)
    imshow(x1); hold on;
    inliers_x1_x = dta_x(inliers_idx,1);
    inliers_x1_y = dta_x(inliers_idx,2);
    outliers_x1_x = dta_x(~logical(tmp),1);
    outliers_x1_y = dta_x(~logical(tmp),2);
    plot(inliers_x1_x,inliers_x1_y,'.b','markersize',15);
    plot(outliers_x1_x,outliers_x1_y,'.r','markersize',15);
    legend({'Inliers','Outliers'});
    subplot(1,2,2)
    imshow(x2); hold on;
    inliers_x2_x = dta_y(inliers_idx,1);
    inliers_x2_y = dta_y(inliers_idx,2);
    outliers_x2_x = dta_y(~logical(tmp),1);
    outliers_x2_y = dta_y(~logical(tmp),2);
    plot(inliers_x2_x,inliers_x2_y,'.r','markersize',15);
    plot(outliers_x2_x,outliers_x2_y,'.b','markersize',15);
    x2_corners_MCIRE= (inv(T_y)*posteriorMean*(T_x*[x1_corners ones(4,1)]'))';
    x2_corners_MCIRE=bsxfun(@rdivide,x2_corners_MCIRE,x2_corners_MCIRE(:,3));
    plot(x2_corners_GT([1:4 1],1),x2_corners_GT([1:4 1],2),'g--','linewidth',4);
    plot(x2_corners_MCIRE([1:4 1],1),x2_corners_MCIRE([1:4 1],2),'m','linewidth',4);
    legend({'Inliers','Outliers','GT','MCIRE'});
    title(sprintf('iter: %d, inlier rate: %.3f, epsilon: %.5f',e,p_hats(e),cur_epsilon))
    tightfig;
    filenmae = sprintf('./output/miko/%d/%d.png',x2_id,e);
    print(filenmae,'-dtiff',['-r' '300']);
    close all    
end

%% Final run from inliers
x_norm_z = x_norm(logical(z(:,e)),:);
y_norm_z = y_norm(logical(z(:,e)),:);
cur_numSamples = size(x_norm_z,1);
% X_z = getA(x_norm_z',y_norm_z',cur_numSamples);
% [~, ~, V] = svd(X_z);
% h = V(:, end);
% beta_hat = reshape(h, [3 3]);   
beta_hat = x_norm_z\y_norm_z;
save(sprintf('./output/miko/result_%d.mat',x2_id),'inliers_idx','beta_hats')


















