function [X,G]=edgels(im,sigma)
%EDGELS   Edge detector based on Laplacian of Gaussian
%  [X,G]=EDGELS(IM,SIGMA) computes edges in image IM at the scale given by
%  the scalar value SIGMA. SIGMA is the standard deviation (in pixels) of
%  the Gaussian filters used to computed first and second derivatives in
%  the image.
%
%  The output X is an Nx2 array, where each row is the (x,y) position of an
%  edge point (or 'edgel'). Edgels are localized to sub-pixel accuracy, so
%  these coordinates are not generally integers. The output G is another
%  Nx2 array that stores the gradient vector at each edge point. 
%
%  The norm of each row of Dx provides the gradient magnitudes, for example, and
%  edgels with small gradient magnitudes can be removed as a post-process,
%  by performing additional operations on the [X,G] returned by this function.
%
%  Reference:
%  ----------
%  Closely related to the algorithm described in Chapter Four of R.
%  Szeliski, "Computer Vision: Algorithms and Applications", available in
%  draft form at http://research.microsoft.com/en-us/um/people/szeliski/Book/

% convert image to double grayscale (so intensity values are in [0,1])
if size(im,3)>1
	im=im2double(rgb2gray(im));
else
	im=im2double(im);
end

% LoG response
Ilog=conv2(im,lapgauss(sigma),'same');

% locate the four-pixel squares having exactly two
%   zero-crossings along their four pair-wise connections
%<your code here>
S = Ilog>0;
[n,m]=size(im);
Z = zeros(n,m);
for i=1:n-1
    for j=1:m-1
        Z(i,j) = (double(S(i,j)~=S(i,j+1))+double(S(i,j)~=S(i+1,j))) == 2;
    end
end
% sub-pixel localization of these surviving zero-crossings. Use Szeliski 
%   equation 4.25. Note that the equation has a type-o; the formula should use 
%   directly the values of the LoG response Ilog, instead of their signs 
%   S(Ilog).
%<your code here>
[I,J]=ind2sub([n,m],find(Z==1));
X = zeros(length(I),2);
for i=1:length(I)
    cx1 = I(i).*Ilog(I(i)+1,J(i))-(I(i)+1).*Ilog(I(i),J(i))/(Ilog(I(i)+1,J(i))-Ilog(I(i),J(i)));
    cy1 = J(i);
    cx2 = I(i);
    cy2 = J(i).*Ilog(I(i),J(i)+1)-(J(i)+1).*Ilog(I(i),J(i))/(Ilog(I(i),J(i)+1)-Ilog(I(i),J(i)));
    X(i,1) = (cx1+cx2)/2;
    X(i,2) = (cy1+cy2)/2;
end
% sample the image gradient at these localized points. (The 
%   localized points are assumed to be in an Nx2 array X 
%   with rows of the form (x,y).)
%<your code here>
[Dx,Dy] = deriv(sigma);
Jgradx=conv2(im,Dx,'same');
Jgrady=conv2(im,Dy,'same');
G = zeros(length(I),2);
G(:,1)=interp2(Jgradx,X(:,1),X(:,2));
G(:,2)=interp2(Jgrady,X(:,1),X(:,2));
%%% SUB-ROUTINESD
%%%
end