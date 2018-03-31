function T = getT(X)
if ((~ismatrix(X)) || (size(X, 2) ~= 2) || (size(X, 1) == 0))
    error('Input matrix must be a Nx2 matrix.');
end
X = transpose(X);
%% Calculate tx, ty and s

Xbar = mean(X(1, :));
Ybar = mean(X(2, :));

% We use hypot(x, y) instead of sqrt(x ? 2 + y ? 2) or norm([x, y]), as
% this function can be significantly faster and numerically more robust
% than the other two.
stdVal = mean(hypot(X(1, :) - Xbar, X(2, :) - Ybar));
if stdVal > 0,
s = sqrt(2) / stdVal;
else
s = 1;
warning('All points coincide.');
end;

tx = - s * Xbar;
ty = - s * Ybar;

%% Form and return T
T = [s 0 tx;
0 s ty;
0 0 1];