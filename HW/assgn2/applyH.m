function Iout = applyH(Iin, H)
% Question 2(b)
% Warp image Iin using homography H. Inputs are image Iin
% and 3x3 invertible matrix H. Output is image Iout, possibly of different
% height and width than input.
[m,n,c] = size(Iin);
corners = [1,1,1;1,m,1;n,1,1;n,m,1]';
limits = H*corners;
limits = limits./repmat(limits(3,:),3,1);
xmin = floor(min(limits(1,:)));xmax = ceil(max(limits(1,:)));
ymin = floor(min(limits(2,:)));ymax = ceil(max(limits(2,:)));
num_x_pts = n;
num_y_pts = m;
% create regularly-spaced grid of (x,y)-pixel coordinates
[x,y]=meshgrid(linspace(xmin,xmax,num_x_pts), linspace(ymin,ymax,num_y_pts));
% reshape them so that a homography can be applied to all points in parallel
X=[x(:) y(:)];
% [Apply a homography to homogeneous coordinates corresponding to ¡®X¡¯. ] %
x_prime = [X';ones(1,num_x_pts*num_y_pts)];
x_org = inv(H)*x_prime;
% [Compute inhomogeneous coordinates of mapped points. ] %
% [Save result in Nx2 matrix named ¡®Xh¡¯. ] %
Xh = (x_org./repmat(x_org(3,:),3,1))';
Iout = zeros(num_y_pts,num_x_pts,c);
for i=1:c
% interpolate I to get intensity values at image points ¡®Xh¡¯
Ih=interp2(double(Iin(:,:,i)),Xh(:,1),Xh(:,2),'linear');
% reshape intensity vector into image with correct height and width
Ih=reshape(Ih,[num_y_pts,num_x_pts]);
% Points in ¡®Xh¡¯ that are outside the boundaries of the image are assigned
% value ¡®NaN¡¯, which means ¡®not a number¡¯. The final step is to
% set the intensities at these points to zero.
Ih(isnan(Ih))=0;
Iout(:,:,i) = Ih;
end
Iout = uint8(Iout);
end % end function applyH