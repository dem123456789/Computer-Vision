function [out] = objective(A,M)
A = reshape(A,[3,3]);
m = size(M,1)/2;
out = 0;
for i=1:m
    out = out + (M((i-1)*2+1,:)*A*A'*M((i-1)*2+2,:)')^2+(M((i-1)*2+1,:)*A*A'*M((i-1)*2+1,:)'-M((i-1)*2+2,:)*A*A'*M((i-1)*2+2,:)')^2;
end
end