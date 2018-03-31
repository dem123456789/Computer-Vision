N = load('./data/bunny.mat');
N = N.N;
x = N(:,:,1);
y = N(:,:,2);
n = 5;
s = [0,0,1];
figure; % create a new figure
quiver(x(1:n:end,1:n:end),y(1:n:end,1:n:end),'.');
axis image; % set unit aspect ratio between x and y axes
axis ij; % place origin in top-left corner (like an image)
%%
figure
imshow(N(:,:,3))
%%
[p,q,z] = size(N);
up45 = [0,cosd(45),cosd(45)];
up45_im = zeros(p,q);
for i = 1:p
    for j = 1:q
        up45_im(i,j) = max([0,squeeze(N(i,j,:))'*up45']);
    end
end
figure
imshow(up45_im)

right45 = [cosd(45),0,cosd(45)];
right45_im = zeros(p,q);
for i = 1:p
    for j = 1:q
        right45_im(i,j) =  max([0,squeeze(N(i,j,:))'*right45']);
    end
end
figure
imshow(right45_im)

right75 = [cosd(25),0,cosd(75)];
right75_im = zeros(p,q);
for i = 1:p
    for j = 1:q
        right75_im(i,j) =  max([0,squeeze(N(i,j,:))'*right75']);
    end
end
figure
imshow(right75_im)
%%
% S = load('./data/PhotometricStereo/sources.mat');
% V = S.S;
% nv = size(V,1);
% tmp = imread('./data/PhotometricStereo/female_01.tif');
% tmp = im2gray(tmp);
% [p,q] = size(tmp);
% I = zeros([p,q,nv]);
% for i=1:nv
%     tmp_I = im2gray(imread(sprintf('./data/PhotometricStereo/female_0%d.tif',i)));
%     I(:,:,i) = tmp_I;
% end
% g = zeros([p,q,3]);
% zo = zeros([p,q,1]);
% for i=1:p
%     for j=1:q
%         ii=squeeze(I(i,j,:));
%         g(i,j,:)=(V)\(ii);
%         zo(i,j,:) = norm(squeeze(g(i,j,:)));
%     end
% end
% N = g./repmat(zo,[1,1,3]);
% figure
% imshow(zo)
% x = N(:,:,1);
% y = N(:,:,2);
% n = 6;
% figure; % create a new figure
% quiver(x(1:n:end,1:n:end),y(1:n:end,1:n:end),'.');
% axis image; % set unit aspect ratio between x and y axes
% axis ij; % place origin in top-left corner (like an image)
%%
% s1 =[0.58,-0.58,-0.58]; 
% s2 =[-0.58,-0.58,-0.58]; 
% I1 = zeros([p,q,1]);
% I2 = zeros([p,q,1]);
% for i=1:p
%     for j=1:q
%         I1(i,j,:) = max([0,squeeze(g(i,j,:))'*s1']);
%         I2(i,j,:) = max([0,squeeze(g(i,j,:))'*s2']);
%     end
% end
% figure
% imshow(I1)
% figure
% imshow(I2)
%%
% Z = integrate_frankot(N);
% % Z is an HxW array of surface depths
% figure;
% s=surf(-Z); % use the ¡®-¡¯ sign since our Z-axis points down
% % output s is a ¡®handle¡¯ for the surface plot
% % adjust axis
% axis image; axis off;
% zlim([-200 200])
% % change surface properties using SET
% set(s,'facecolor',[.5 .5 .5],'edgecolor','none');
% % add a light to the axis for visual effect
% l=camlight;
% % enable mouse-guided rotation
% view([-170 60])
% rotate3d on
% figure;
% s=surf(-Z); % use the ¡®-¡¯ sign since our Z-axis points down
% % output s is a ¡®handle¡¯ for the surface plot
% % adjust axis
% axis image; axis off;
% zlim([-200 200])
% % change surface properties using SET
% set(s,'facecolor',[.5 .5 .5],'edgecolor','none');
% % add a light to the axis for visual effect
% l=camlight;
% % enable mouse-guided rotation
% view([-200 70])
% rotate3d on