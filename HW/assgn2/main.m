% X = rand(50,2)*100;    % 50 random points in square [0,100]x[0,100]
% T = getT(X);            
% Xn = (T*[X'; ones(1,50)])';
% Xni = Xn(:,1:2)./repmat(Xn(:,3),[1 2]);
% a=sum(Xni(:, 1));
% % display results
% figure;
% subplot(1,2,1); plot(X(:,1),X(:,2),'.'); 
% axis equal; axis tight; title 'Input points';
% subplot(1,2,2); plot(Xni(:,1),Xni(:,2),'.'); 
% axis equal; axis tight; title 'Transformed points';

%%
% % read image, convert to grayscale with single precision 
% %  (doing it in color requires a little extra work; try it only after you get the grayscale version working) 
% % im=single(rgb2gray(imread(fullfile('.','data','MaxwellDworkin_01.jpg'))));
% im=imread(fullfile('.','data','MaxwellDworkin_01.jpg'));
% % figure;
% % imshow(im,[]);
% % impixelinfo;
% X1 = [255,267;250,443;548,96;543,298];
% X2 = [0,0;0,1;2.5,0;2.5,1];
% H = getH(X1,X2);
% % replace the next line with your own code
% imout = applyH(im, H);
% 
% 
% % display results
% figure;
% subplot(1,2,1); imshow(im,[]); title 'Input image';
% subplot(1,2,2); imshow(imout,[]); title 'Rectified image';

%%
% % read images, convert to grayscale with single precision 
% %  (doing it in color requires a little extra work; try it only after you get the grayscale version working) 
% % im1=single(rgb2gray(imread(fullfile('.','data','quad_left.jpg'))));
% % im2=single(rgb2gray(imread(fullfile('.','data','quad_middle.jpg'))));
% % im3=single(rgb2gray(imread(fullfile('.','data','quad_right.jpg'))));
% im1=single(imread(fullfile('.','data','quad_left.jpg')));
% im2=single(imread(fullfile('.','data','quad_middle.jpg')));
% im3=single(imread(fullfile('.','data','quad_right.jpg')));
% % figure;
% % imshow(im2,[]);
% % impixelinfo;
% 
% % here, type in the coordinates of your manually-identified pixels, using the following variables:
% %  X12: Nx2 array of points in quad_left that match points in quad_middle
% %  X21: Nx2 array of points in quad_middle that match points in quad_left
% %  X23: Mx2 array of points in quad_middle that match points in quad_right
% %  X32: Mx2 array of points in quad_right that match points in quad_middle
% X12 = [514,268;514,291;545,268;545,291];
% X21 = [53,246;53,269;84,246;84,269];
% X23 = [545,335;544,357;556,335;556,357];
% X32 = [81,329;80,352;92,329;92,352];
% 
% % compute and display the panoramic result
% figure;
% imout = applyH2(im1,im2,im3,getH(X12,X21),getH(X32,X23));
% imshow(imout,[]);

%%
% read images, convert to grayscale with single precision 
%  (doing it in color requires a little extra work; try it only after you get the grayscale version working) 
im1=imread(fullfile('.','data','quad_left.jpg'));
im2=imread(fullfile('.','data','quad_middle.jpg'));
im3=imread(fullfile('.','data','quad_right.jpg'));

% load (noisy) correspondences. These are the variables:
%  X12: points in quad_left that match points in quad_middle
%  X21: points in quad_middle that match points in quad_left
%  X23: points in quad_middle that match points in quad_right
%  X32: points in quad_right that match points in quad_middle
load(fullfile('.','data','quad_points.mat'));

% compute and display the panoramic result
%figure;
imout = applyH2(im1,im2,im3,ransacH(X12,X21),ransacH(X32,X23));
imshow(imout,[]);
