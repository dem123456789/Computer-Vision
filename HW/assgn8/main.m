% im=im2double(imread('./data/fruitbowl.png'));
% figure
% imshow(min(1,im./0.1));
% s = [0.6257 0.5678 0.5349];
% imout = makeLambertian(im, s);
% figure
% imshow(min(1,imout./0.1));
%%
% load('./data/bananas.mat');
% T = metamericLight(ripe,overripe);
% display(T)
%%
% Load test data. Variables are:
%   sourceimage  = 34x34 source texture image (rings.jpg)
%   targetwindow = 11x11 target window to be matched
%   validmask    = 11x11 binary matrix
%   G            = 11x11 Gaussian kernel
%   gt_wSSD      = 24x24 "ground truth" weighted SSD for comparison
load('./data/testFindMatches.mat');

% Replace this line with your wSSD code, which will form the core of your 
%  function FindMatches. Your wSSD code here should produce a 24x24 map of 
%  wSSD scores (same size as the source texture image), and it should do 
%  so without using loops. Instead of loops you should use appropriate 
%  calls to conv2(...,'valid').
[~, mywSSD]=FindMatches(targetwindow, validmask, sourceimage, G);

% compare
if size(mywSSD)~=size(gt_wSSD)
    error(['My wSSD is not 24x24 as expected']);
end

% compare your wSSD map beside the ground truth. You want the 
%  right-most "Absolute difference" map to be filled with zeros. It 
%  should say "(max=0)" in the title.  
figure(1); clf;
subplot(1,3,1); imshow(gt_wSSD,[]); title 'True wSSD';
subplot(1,3,2); imshow(mywSSD,[]); title 'My wSSD';
subplot(1,3,3); imshow(abs(gt_wSSD-mywSSD),[]); 
title(sprintf('Absolute difference (max=%0.2g)',max(abs(gt_wSSD(:)-mywSSD(:)))));

sourceimage = im2double(imread('./data/rings.jpg'));
synthdim= [100 100];
ws = [5 7 13];
for i=1:length(ws) 
    figure
    subplot(2,3,2)
    imshow(sourceimage); 
    title(sprintf('windowsize=%d',ws(i)))
    for j=1:3
        synthim = SynthTexture(sourceimage, ws(i), synthdim);
        subplot(2,3,3+j)
        imshow(synthim);
    end
end

% synthim = SynthTexture(sourceimage, 21, synthdim);