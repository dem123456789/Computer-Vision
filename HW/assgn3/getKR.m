function [K,R] = getKR(P)
M = P(:,1:3);
[R,K] = qr(M);
end % end function getC