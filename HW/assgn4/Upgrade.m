function [M,X]=Upgrade(Min,Xin)
myfunc = @(A) objective(A,Min);
A=lsqnonlin(myfunc,reshape(eye(3),[9,1]));
A=reshape(A,[3 3]);
H = [inv(A) zeros(3,1);zeros(1,3),1];
X = H*[Xin ones(size(Xin,1),1)]';
X = X';
T = getT(X(:,1:3),3);
X = (T*X')';
X = X(:,1:3);
M = 1/T(1,1)*Min*A;
end