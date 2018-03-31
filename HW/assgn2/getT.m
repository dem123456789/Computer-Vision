function T = getT(X)
% Question 1(b)
% Similarity matrix T that normalizes a set of 2D points. Input
% X is an Nx2 array of inhomgeneous image coordinates. Output is
% an invertible 3x3 matrix.

% check input
if ((~ismatrix(X)) || (size(X, 2) ~= 2) || (size(X, 1) == 0))
	error('Input must be an Nx2 array.');
end
N = size(X,1);
x = X(:,1);
y = X(:,2);
sum_X = sum(X,1);
sum_x = sum_X(1);
sum_y = sum_X(2);
part1 = sum(sqrt((1-N*x/sum_x).^2 + (sum_y/sum_x)^2*(1-N*y/sum_y).^2));
part2 = N*sqrt(2)*(sum_x+sum_y)/sum_x;
tx = N*sqrt(2)/(part1 -part2);
ty = tx*sum_y/sum_x;
s = -N*tx/sum_x;

% replace the next line with your own code
T = [s,0,tx;0,s,ty;0,0,1];

end % end function getT