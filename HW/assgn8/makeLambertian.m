function imout = makeLambertian(im, s)
    %% 1(d)
    r = null(s);
    r1 = r(:,1);
    r2 = r(:,2);
    [a,b,~] = size(im);
    J = zeros([a,b,2]);
    J_norm = zeros([a,b,1]);
    for i = 1:a
        for j = 1:b
            J(i,j,1) = r1'*squeeze(im(i,j,:));
            J(i,j,2) = r2'*squeeze(im(i,j,:));
            J_norm(i,j,1) = norm([J(i,j,1),J(i,j,2)]);
        end
    end
imout =  J_norm;
end