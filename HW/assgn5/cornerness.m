function C=cornerness(I,sigma)
w=2*floor(ceil(7*sigma)/2)+1;
[xx,yy]=meshgrid(-(w-1)/2:(w-1)/2,-(w-1)/2:(w-1)/2);
Dxx=(1/(sigma^4)).*(xx.^2-sigma^2).*exp(-(xx.^2+yy.^2)/(2*sigma^2));
Dyy=(1/(sigma^4)).*(yy.^2-sigma^2).*exp(-(xx.^2+yy.^2)/(2*sigma^2));
Dxy=(1/(sigma^4)).*(xx.*yy-sigma^2).*exp(-(xx.^2+yy.^2)/(2*sigma^2));
Ixx=conv2(I,Dxx,'same');
Iyy=conv2(I,Dyy,'same');
Ixy=conv2(I,Dxy,'same');
K = Ixx.*Ixy-Iyy.^2;
H = 1/2*(Ixx+Ixy);
alpha = 0.06;
C = K-alpha*4*H.^2;
end