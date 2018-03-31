function out=gauss1d(sigma)
w=2*floor(ceil(7*sigma)/2)+1;
xx=-(w-1)/2:(w-1)/2;
out=(1/(sqrt(2*pi)*sigma)).*exp(-(xx.^2)/(2*sigma^2));
end