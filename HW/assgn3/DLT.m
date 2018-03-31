function out = DLT(X1, X2)
% check input
if ((~ismatrix(X1)) || (~ismatrix(X2)) || (size(X1, 0) == 0) || (size(X1, 1) == 0))
	error('Input incorrect.');
end
N = size(X1,1);
c1 = size(X1,2);
c2 = size(X2,2);
T1 = getT(X1);
T2 = getT(X2);
X1n = (T1*[X1'; ones(1,N)])';
X2n = (T2*[X2'; ones(1,N)])';
wixi = repmat(X2n(:,3),1,c1+1).* X1n;
yixi = repmat(X2n(:,2),1,c1+1).* X1n;
xixi = repmat(X2n(:,1),1,c1+1).* X1n;
A = [zeros(N,c1+1),-wixi,yixi;wixi,zeros(N,c1+1),-xixi];
[~,~,V] = svd(A);
V_last = V(:,end);
out_tilde = reshape(V_last,c2,c1);
% replace the next line with your own code
out = inv(T2)*out_tilde*T1;
end % end function getH