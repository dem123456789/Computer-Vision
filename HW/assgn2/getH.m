function H = getH(X1, X2)
% Question 2(a)
% Homography that maps points in X1 to points in X2. Inputs
% X1, X2 are Nx2 arrays of inhomgeneous image coordinates. Output is
% an invertible 3x3 matrix. Requires function getT().

% check input
if ((~ismatrix(X1)) || (~ismatrix(X2)) || ~isempty(find(size(X1) ~= size(X2), 1))...
		|| (size(X1, 2) ~= 2) || (size(X1, 1) == 0))
	error('Input must be two Nx2 matrices.');
end
N = size(X1,1);
T1 = getT(X1);
T2 = getT(X2);
X1n = (T1*[X1'; ones(1,N)])';
X2n = (T2*[X2'; ones(1,N)])';
wixi = repmat(X2n(:,3),1,3).* X1n;
yixi = repmat(X2n(:,2),1,3).* X1n;
xixi = repmat(X2n(:,1),1,3).* X1n;
A = [zeros(N,3),-wixi,yixi;wixi,zeros(N,3),-xixi];
[U,D,V] = svd(A);
V_last = V(:,end);
H_tilde = [V_last(1:3)';V_last(4:6)';V_last(7:9)'];
% replace the next line with your own code
H = inv(T2)*H_tilde*T1;
end % end function getH