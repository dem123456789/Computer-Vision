function H = ransacH(X1, X2)
% Question 4(a)
% Homography that maps inlying subset of points in X1 to points in X2. Inputs
% X1, X2 are Nx2 arrays of inhomgeneous image coordinates. Output is
% an invertible 3x3 matrix. Requires functions getT() and get(H).

% check input
if ((~ismatrix(X1)) || (~ismatrix(X2)) || ~isempty(find(size(X1) ~= size(X2), 1))...
		|| (size(X1, 2) ~= 2) || (size(X1, 1) == 0))
	error('Input must be two Nx2 matrices.');
end

% replace the next line with your own code
% code here
N = size(X1,1);
num_iter = 300; % number of RANSAC iterations
inlier_threshold = 20; % threshold for inlier set of each line
num_inliers = 0;
for i=1:num_iter
    randidx = randperm(N);
    selected_X1 = X1(randidx(1:4),:);
    selected_X2 = X2(randidx(1:4),:);
    H = getH(selected_X1,selected_X2);
    other_X1 = X1(randidx(5:end),:);
    other_X2 = X2(randidx(5:end),:);
    predicted_X2 = H*[other_X1'; ones(1,N-4)];
    eps = cross([other_X2'; ones(1,N-4)],predicted_X2);
    eps_norm = sqrt(sum(eps.^2,1));
    tmp_num_inliers = sum(abs(eps_norm)<inlier_threshold);
    if(tmp_num_inliers>num_inliers)
        num_inliers = tmp_num_inliers;
        inliers_X1  = [selected_X1;other_X1(abs(eps_norm)<inlier_threshold,:)];
        inliers_X2  = [selected_X2;other_X2(abs(eps_norm)<inlier_threshold,:)];
    end
end
H = getH(inliers_X1,inliers_X2);
end % end function ransacH