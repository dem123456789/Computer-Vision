clear;
close all;
%%
load('./data/corners.mat');
Pl = getCamera(corners_3D,leftpts);
Pr = getCamera(corners_3D,rightpts);
Cl = getC(Pl);
tmp_Cl = Cl(1:end-1)';
Cr = getC(Pr);
tmp_Cr = Cr(1:end-1)';
iml = imread('./data/calib_left.bmp');
imr = imread('./data/calib_right.bmp');
corners_l = getcorners(iml);
corners_r = getcorners(imr);
[Kl,Rl] = getKR(Pl);
[Kr,Rr] = getKR(Pr);
ray_poly_l = pinv(Pl)*corners_l+10*repmat(Cl,1,size(corners_l,2));
ray_poly_l = ray_poly_l(1:end-1,:)./repmat(ray_poly_l(end,:),size(corners_l,1),1);
ray_poly_l = ray_poly_l';
ray_poly_r = pinv(Pr)*corners_r-10*repmat(Cr,1,size(corners_r,2));
ray_poly_r = ray_poly_r(1:end-1,:)./repmat(ray_poly_r(end,:),size(corners_r,1),1);
ray_poly_r = ray_poly_r';

ray_poly_l_line = pinv(Pl)*corners_l+0.1*repmat(Cl,1,size(corners_l,2));
ray_poly_l_line = ray_poly_l_line(1:end-1,:)./repmat(ray_poly_l_line(end,:),size(corners_l,1),1);
ray_poly_r_line = pinv(Pr)*corners_r-0.1*repmat(Cr,1,size(corners_r,2));
ray_poly_r_line = ray_poly_r_line(1:end-1,:)./repmat(ray_poly_r_line(end,:),size(corners_r,1),1);
% figure;
% hold on
% grid on
% view(-60,20)
% plotpenta(ray_poly_l,tmp_Cl,'r')
% plotpenta(ray_poly_r,tmp_Cr,'g')
% plot3([repmat(tmp_Cl(1),1,4);ray_poly_l_line(1,:)],[repmat(tmp_Cl(2),1,4);ray_poly_l_line(2,:)],[repmat(tmp_Cl(3),1,4);ray_poly_l_line(3,:)],'r--')
% plot3([repmat(tmp_Cr(1),1,4);ray_poly_r_line(1,:)],[repmat(tmp_Cr(2),1,4);ray_poly_r_line(2,:)],[repmat(tmp_Cr(3),1,4);ray_poly_r_line(3,:)],'g--')
% scatter3(corners_3D(:,1),corners_3D(:,2),corners_3D(:,3),'.')
%%
iml = imread('./data/kleenex_left.bmp');
imr = imread('./data/kleenex_right.bmp');
% figure;
% imshow(imr,[]);
% impixelinfo;
x1 = [198 327;203 191;363 270;343 399;422 286;443 163;294 95];
x2 = [220 337;143 225;241 273;319 382;408 278;341 163;241 125];
xl = [x1 ones(size(x1,1),1)];
xr = [x2 ones(size(x2,1),1)];
X = triangulate(xl,xr,Pl,Pr);
% figure;
% hold on
% grid on
% view(-80,5)
% plotpenta(ray_poly_l,tmp_Cl,'r')
% plotpenta(ray_poly_r,tmp_Cr,'g')
% plot3([repmat(tmp_Cl(1),1,4);ray_poly_l_line(1,:)],[repmat(tmp_Cl(2),1,4);ray_poly_l_line(2,:)],[repmat(tmp_Cl(3),1,4);ray_poly_l_line(3,:)],'r--')
% plot3([repmat(tmp_Cr(1),1,4);ray_poly_r_line(1,:)],[repmat(tmp_Cr(2),1,4);ray_poly_r_line(2,:)],[repmat(tmp_Cr(3),1,4);ray_poly_r_line(3,:)],'g--')
% plotcube(X,'b')
%%
% dist_check = norm([corners_3D(1,:)-corners_3D(2,:)]);
% dist_cube = norm([X(1,:)-X(2,:)]);
% dist_cube_cm = dist_cube/dist_check*2;
% volume = dist_cube_cm^3;
%%
H = planeMapping(X,Pl,Pr);
X1 = X(1:4,:);
H1 = H(1:3,:);
% tmp = [x1 ones(size(x1,1),1)]';
xmin = min(X1(:,1));xmax = max(X1(:,1));
ymin = min(X1(:,2));ymax = max(X1(:,2));
zmin = min(X1(:,3));zmax = max(X1(:,3));
limits = [xmin xmax;ymin ymax;zmin zmax];
applyH(iml,H1,limits)