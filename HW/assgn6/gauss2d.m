function out=gauss2d(sigma)
w=2*floor(ceil(7*sigma)/2)+1;
[xx,yy]=meshgrid(-(w-1)/2:(w-1)/2,-(w-1)/2:(w-1)/2);
out=(1/(2*pi*sigma^2)).*exp(-(xx.^2+yy.^2)/(2*sigma^2));
end