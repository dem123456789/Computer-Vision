function DD=lapgauss(sigma)
% Create Laplacian-of-Gaussian kernel with standard deviation SIGMA.
% Use equation 4.23 in the Szelsiki book.

% use an odd-size square window with length greater than 5 times sigma
w=2*floor(ceil(7*sigma)/2)+1;
[xx,yy]=meshgrid(-(w-1)/2:(w-1)/2,-(w-1)/2:(w-1)/2);

% Equation 4.23 from Szeliski's book. (Actually, he has a small type-o; 
%   the equation here is correct)
DD=(1/(sigma^4)).*(1-(xx.^2+yy.^2)/(2*sigma^2)).*exp(-(xx.^2+yy.^2)/(2*sigma^2));

return;
end