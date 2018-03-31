function [dta_x,dta_y] = getDatafromSIFT(x1,x2,min_shift)
VLFEATROOT = 'F:/MATLAB/R2016a/toolbox/vlfeat_bin';
run(sprintf('%s/toolbox/vl_setup',VLFEATROOT))
im1 = single(rgb2gray(x1));
im2 = single(rgb2gray(x2)) ;
[f1,d1] = vl_sift(im1);
[f2,d2] = vl_sift(im2);
maxNumMatches = 500;
siftThreshold = 7;
scores = [];
while(numel(scores)<maxNumMatches && siftThreshold > min_shift)
    [matches, scores] = vl_ubcmatch(d1,d2,siftThreshold);
    siftThreshold = 0.95*siftThreshold;
    fprintf('siftThreshold: %.1f, numMatches: %d\n',siftThreshold,numel(scores));
end
% [matches, scores] = vl_ubcmatch(d1, d2) ;
dta_x = f1(1:2,matches(1,:)); dta_x = dta_x'; 
dta_y = f2(1:2,matches(2,:)); dta_y = dta_y';
% perm = randperm(size(f1,2)) ;
% sel = perm(1:50) ;
% figure
% image(x1) ;
% h1 = vl_plotframe(f1(:,sel)) ;
% h2 = vl_plotframe(f1(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% h3 = vl_plotsiftdescriptor(d1(:,sel),f1(:,sel)) ;
% set(h3,'color','g') ;

end