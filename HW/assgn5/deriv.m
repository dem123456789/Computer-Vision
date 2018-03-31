function [Dx,Dy]=deriv(sigma)
% Create derivative-of-Gaussian kernels for horizontal and vertical derivatives.
% Input SIGMA is the standard deviation of the Gaussian. Use equation 4.21 
% in the Szelsiki book. Note that the equation has a type-o; the multiplicative 
% factor 1/sigma^3 should instead be 1/sigma^4; this does not affect the results
% though.

%<your code here>
w=2*floor(ceil(7*sigma)/2)+1;
[xx,yy]=meshgrid(-(w-1)/2:(w-1)/2,-(w-1)/2:(w-1)/2);

Dx=(1/(sigma^4)).*(-xx).*exp(-(xx.^2+yy.^2)/(2*sigma^2));
Dy=(1/(sigma^4)).*(-yy).*exp(-(xx.^2+yy.^2)/(2*sigma^2));
end