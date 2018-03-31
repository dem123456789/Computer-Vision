function P = getCamera(X3, X2)
    % Problem 3(a)
    % the function that computes the 3x4 camera matrix P from nx3
    % world coordinates X3 and an nx2 matrix of pixel coordinates X2
    % representing the projection of the world points into a single 
    % projective camera
    % replace the next line with your own code
    % check input
    if ((~ismatrix(X3)) || (~ismatrix(X2)) || (size(X3, 1) == 0) || (size(X3, 1) == 0))
        error('Input incorrect.');
    end
    N = size(X3,1);
    c1 = size(X3,2);
    c2 = size(X2,2);
    T1 = getT(X3,c1);
    T2 = getT(X2,c2);
    X3n = (T1*[X3'; ones(1,N)])';
    X2n = (T2*[X2'; ones(1,N)])';
    wixi = repmat(X2n(:,3),1,c1+1).* X3n;
    yixi = repmat(X2n(:,2),1,c1+1).* X3n;
    xixi = repmat(X2n(:,1),1,c1+1).* X3n;
    A = [zeros(N,c1+1),-wixi,yixi;wixi,zeros(N,c1+1),-xixi];
    [~,~,V] = svd(A);
    V_last = V(:,end);
    P_tilde = reshape(V_last,c1+1,c2+1)';
    % replace the next line with your own code
    P = inv(T2)*P_tilde*T1;
end