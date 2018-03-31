function A = getA(x,y,N)

A = [zeros(N, 3), -repmat(y(3, :)', [1 3]) .* x', repmat(y(2, :)', [1 3]) .* x';
    repmat(y(3, :)', [1 3]) .* x', zeros(N, 3), -repmat(y(1, :)', [1 3]) .* x'];
end