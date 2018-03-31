function Iout = applyH(Iin,H,limits)
num_x_pts_1 = 50;
num_y_pts_1 = 50;
num_z_pts_1 = 50; 
% create regularly-spaced grid of (x,y)-pixel coordinates
[x,y]=meshgrid(linspace(limits(1,1),limits(1,2),num_x_pts_1), linspace(limits(2,1),limits(2,2),num_y_pts_1));
% reshape them so that a homography can be applied to all points in parallel
X=[x(:) y(:)];
% [Apply a homography to homogeneous coordinates corresponding to ¡®X¡¯. ] %
x_prime = [X ones(size(X,1),1)]';
x_org = inv(H)*x_prime;
% [Compute inhomogeneous coordinates of mapped points. ] %
% [Save result in Nx2 matrix named ¡®Xh¡¯. ] %
Xh = (x_org./repmat(x_org(end,:),3,1))';
Iout = zeros(num_y_pts_1,num_x_pts_1,3);
for i=1:3
% interpolate I to get intensity values at image points ¡®Xh¡¯
Ih=interp3(double(Iin(:,:,i)),Xh(:,1),Xh(:,2),'linear');
% reshape intensity vector into image with correct height and width
Ih=reshape(Ih,[num_y_pts_1,num_x_pts_1]);
% Points in ¡®Xh¡¯ that are outside the boundaries of the image are assigned
% value ¡®NaN¡¯, which means ¡®not a number¡¯. The final step is to
% set the intensities at these points to zero.
Ih(isnan(Ih))=0;
Iout(:,:,i) = Ih;
end
end