im = imread('./data/calib_right.bmp');
sigma = 0.6;
[X,G] = edgels(im,sigma);
figure
imshow(im)
hold on
quiver(X(:,1),X(:,2),G(:,1),G(:,2))
%%
% im_org = imread('./data/calib_right.bmp');
% if size(im_org,3)>1
% 	im=im2double(rgb2gray(im_org));
% else
% 	im=im2double(im_org);
% end
% figure;
% imshow(im)
% sigma = 2;
% threshold = 1;
% C = cornerness(im,sigma);
% figure
% imshow(C)
% Co = nonmax_suppression(C);
% [I,J] = ind2sub(size(im),find(Co>threshold));
% overlay_C = insertMarker(im_org,[J,I]);
% figure
% imshow(overlay_C)