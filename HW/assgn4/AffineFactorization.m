function [M,T,X] = AffineFactorization(x)
n = size(x,1);
m = size(x,3);
T = mean(x,1);
x_centered = x - repmat(T,n,1,1);
T = squeeze(T);
W = [];
for i=1:m
    W = [W;x_centered(:,:,i)'];
end
[U,D,V] = svd(W);
M = U(:,1:3)*D(1:3,1:3);
X = V(:,1:3);
end