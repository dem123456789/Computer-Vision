function C = getC(P)
x = det([P(:,2) P(:,3) P(:,4)]);
y = - det([P(:,1) P(:,3) P(:,4)]);
z = det([P(:,1) P(:,2) P(:,4)]);
t = - det([P(:,1) P(:,2) P(:,3)]);
C = [x/t;y/t;z/t;1];
% [~,~,V] = svd(P);
% C2 = V(:,end);
% C2 = C2./C2(4);
end % end function getC