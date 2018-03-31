function Iout = applyH2(I1,I2,I3,H12,H32)
% Question 3(a)
% Create a panoramic image from images I1, I2, and I3 using 3x3 invertible matrices H12 and H32.
[m1,n1,c1] = size(I1);
corners = [1,1,1;1,m1,1;n1,1,1;n1,m1,1]';
limits = H12*corners;
limits = limits./repmat(limits(3,:),3,1);
xmin_1 = floor(min(limits(1,:)));xmax_1 = ceil(max(limits(1,:)));
ymin_1 = floor(min(limits(2,:)));ymax_1 = ceil(max(limits(2,:)));
num_x_pts_1 = xmax_1-xmin_1+1;
num_y_pts_1 = ymax_1-ymin_1+1;
% create regularly-spaced grid of (x,y)-pixel coordinates
[x,y]=meshgrid(linspace(xmin_1,xmax_1,num_x_pts_1), linspace(ymin_1,ymax_1,num_y_pts_1));
% reshape them so that a homography can be applied to all points in parallel
X=[x(:) y(:)];
% [Apply a homography to homogeneous coordinates corresponding to ¡®X¡¯. ] %
x1_prime = [X';ones(1,num_x_pts_1*num_y_pts_1)];
x12 = inv(H12)*x1_prime;
% [Compute inhomogeneous coordinates of mapped points. ] %
% [Save result in Nx2 matrix named ¡®Xh¡¯. ] %
Xh = (x12./repmat(x12(3,:),3,1))';
Iout12 = zeros(num_y_pts_1,num_x_pts_1,c1);
for i=1:c1
% interpolate I to get intensity values at image points ¡®Xh¡¯
Ih=interp2(double(I1(:,:,i)),Xh(:,1),Xh(:,2),'linear');
% reshape intensity vector into image with correct height and width
Ih=reshape(Ih,[num_y_pts_1,num_x_pts_1]);
% Points in ¡®Xh¡¯ that are outside the boundaries of the image are assigned
% value ¡®NaN¡¯, which means ¡®not a number¡¯. The final step is to
% set the intensities at these points to zero.
Ih(isnan(Ih))=0;
Iout12(:,:,i) = Ih;
end


[m3,n3,c3] = size(I3);
corners = [1,1,1;1,m3,1;n3,1,1;n3,m3,1]';
limits = H32*corners;
limits = limits./repmat(limits(3,:),3,1);
xmin_3 = floor(min(limits(1,:)));xmax_3 = ceil(max(limits(1,:)));
ymin_3 = floor(min(limits(2,:)));ymax_3 = ceil(max(limits(2,:)));
num_x_pts_3 = xmax_3-xmin_3+1;
num_y_pts_3 = ymax_3-ymin_3+1;
% create regularly-spaced grid of (x,y)-pixel coordinates
[x,y]=meshgrid(linspace(xmin_3,xmax_3,num_x_pts_3), linspace(ymin_3,ymax_3,num_y_pts_3));
% reshape them so that a homography can be applied to all points in parallel
X=[x(:) y(:)];
% [Apply a homography to homogeneous coordinates corresponding to ¡®X¡¯. ] %
x3_prime = [X';ones(1,num_x_pts_3*num_y_pts_3)];
x32 = inv(H32)*x3_prime;
% [Compute inhomogeneous coordinates of mapped points. ] %
% [Save result in Nx2 matrix named ¡®Xh¡¯. ] %
Xh = (x32./repmat(x32(3,:),3,1))';
Iout32 = zeros(num_y_pts_3,num_x_pts_3,c3);
for i=1:c3
% interpolate I to get intensity values at image points ¡®Xh¡¯
Ih=interp2(double(I3(:,:,i)),Xh(:,1),Xh(:,2),'linear');
% reshape intensity vector into image with correct height and width
Ih=reshape(Ih,[num_y_pts_3,num_x_pts_3]);
% Points in ¡®Xh¡¯ that are outside the boundaries of the image are assigned
% value ¡®NaN¡¯, which means ¡®not a number¡¯. The final step is to
% set the intensities at these points to zero.
Ih(isnan(Ih))=0;
Iout32(:,:,i) = Ih;
end

% figure;
% imshow(uint8(Iout12))
% figure;
% imshow(uint8(I2))
% figure;
% imshow(uint8(Iout32))

[m2,n2,c2] = size(I2);
[x,y]=meshgrid(1:n2, 1:m2);
% reshape them so that a homography can be applied to all points in parallel
X=[x(:) y(:)];
x2_prime = [X';ones(1,n2*m2)];

xmin_2 = 1;xmax_2 = n2;
ymin_2 = 1;ymax_2 = m2;
xmin_all = min([xmin_1,xmin_2,xmin_3]);
xmax_all = max([xmax_1,xmax_2,xmax_3]);
ymin_all = min([ymin_1,ymin_2,ymin_3]);
ymax_all = max([ymax_1,ymax_2,ymax_3]);
mask_left = x1_prime(1,:)<=min(xmax_1,xmin_2)|(x1_prime(1,:)>min(xmax_1,xmin_2)&(x1_prime(2,:)>max(x2_prime(2,x2_prime(1,:)>=min(xmax_1,xmin_2)...
            &x2_prime(1,:)<=max(xmax_1,xmin_2))))|(x1_prime(2,:)<min(x2_prime(2,x2_prime(1,:)>=min(xmax_1,xmin_2)...
            &x2_prime(1,:)<=max(xmax_1,xmin_2)))));
mask_right = x3_prime(1,:)>=max(xmin_3,xmax_2)|(x3_prime(1,:)<max(xmin_3,xmax_2)&(x3_prime(2,:)>max(x2_prime(2,x2_prime(1,:)>=min(xmin_3,xmax_2)...
            &x2_prime(1,:)<=max(xmin_3,xmax_2))))|(x3_prime(2,:)<min(x2_prime(2,x2_prime(1,:)>=min(xmin_3,xmax_2)...
            &x2_prime(1,:)<=max(xmin_3,xmax_2)))));
mask_left = reshape(mask_left,num_y_pts_1,num_x_pts_1);
mask_right = reshape(mask_right,num_y_pts_3,num_x_pts_3);
I_final = zeros(ymax_all-ymin_all+1,xmax_all-xmin_all+1,3);
for i=1:c2
I_tmp = zeros(ymax_all-ymin_all+1,xmax_all-xmin_all+1);
ind1 = sub2ind([ymax_all-ymin_all+1,xmax_all-xmin_all+1], x1_prime(2,mask_left)-ymin_all+1, x1_prime(1,mask_left)-xmin_1+1);
ind2 = sub2ind([ymax_all-ymin_all+1,xmax_all-xmin_all+1], x2_prime(2,:)-ymin_all+1, x2_prime(1,:)-xmin_1+1);
ind3 = sub2ind([ymax_all-ymin_all+1,xmax_all-xmin_all+1], x3_prime(2,mask_right)-ymin_all+1, x3_prime(1,mask_right)-xmin_1+1);
Iout12_tmp = Iout12(:,:,i);
I2_tmp = I2(:,:,i);
Iout32_tmp = Iout32(:,:,i);
I_tmp(ind1)=Iout12_tmp(mask_left);
I_tmp(ind2)=I2_tmp;
I_tmp(ind3)=Iout32_tmp(mask_right);
I_final(:,:,i) = I_tmp;
end
Iout = uint8(I_final);
end % end function applyH2