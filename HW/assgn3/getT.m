function T = getT(X,c)
% check input
if ((~ismatrix(X)) || (size(X, 2) ~= c) || (size(X, 1) == 0))
	error('Input incorrect.');
end
N = size(X,1);
mu = mean(X,1);
tmp = [];
for i=1:c
   tmp = [tmp X(:,i)-mu(i)];
end
stdev = norm(tmp);
if stdev > 0
    s = sqrt(c) / stdev;
else
    s = 1;
end
t = zeros(c,1);
for i=1:c
    t(i) = - s * mu(i);
end
% replace the next line with your own code
T = [s*eye(c) t;[zeros(1,c) 1]];
end % end function getT