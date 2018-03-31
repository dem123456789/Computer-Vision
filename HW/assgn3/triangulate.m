function X = triangulate(x1, x2, P1, P2)
    % Problem 4(b)
    % write a function that takes camera matrix P1 and P2, and image
    % points x1, x2 and estimates the 3D world points X 
N = size(x1,1);
c1 = size(P1,1);
X = zeros(N,c1);
for i=1:N
    wih2 = repmat(x1(i,3),1,c1+1).* P1(2,:);
    yih3 = repmat(x1(i,2),1,c1+1).* P1(3,:);
    wih1 = repmat(x1(i,3),1,c1+1).* P1(1,:);
    xih3 = repmat(x1(i,1),1,c1+1).* P1(3,:);
    xih2 = repmat(x1(i,1),1,c1+1).* P1(2,:);
    yih1 = repmat(x1(i,2),1,c1+1).* P1(1,:);
    A1 = [yih3-wih2;wih1-xih3];
    c2 = size(P2,1);
    wih2 = repmat(x2(i,3),1,c2+1).* P2(2,:);
    yih3 = repmat(x2(i,2),1,c2+1).* P2(3,:);
    wih1 = repmat(x2(i,3),1,c2+1).* P2(1,:);
    xih3 = repmat(x2(i,1),1,c2+1).* P2(3,:);
    xih2 = repmat(x2(i,1),1,c1+1).* P2(2,:);
    yih1 = repmat(x2(i,2),1,c1+1).* P2(1,:);
    A2 = [yih3-wih2;wih1-xih3];
    A = [A1;A2];
    [~,~,V] = svd(A);
    V_last = V(:,end);
    V_last = V_last./(V_last(end));
    X(i,:) = V_last(1:end-1);
end
unseen = X(end,:)-(X(2,:)-X(1,:));
X = [X; unseen];
end
