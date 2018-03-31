function d=xiongheight(im,X)
%XIONGHEIGHT_SOLUTION  Estimate height of Dr. Ying Xiong.
%   D = XIONGHEIGHT_SOLUTION(IM,X) computes the height of Dr. Xiong from 
%   image IM and pixel coordinates X. Image IM can be grayscale or color. 
%   Array X is and an N-by-2 array of pixel coordinates, with each row of 
%   the form (x,y). Output D is Dr. Xiong's height in inches.
%
%   When you have an answer, submit to: 
%       https://goo.gl/forms/agSMzbZiQXXunHrk1
%
%   For example solution see XIONGHEIGHT_SOLUTION.

%   Skeleton code by CS283, v3 2017

% Possibly-relevant vertical measurements in the scene (in inches)
HANDRAIL=36;
TALLBRICK=33;

% image dimensions [h w]
dims=[size(im,1) size(im,2)];

%display image and input points
figure(1); clf;
him=imshow(im,[]);
hold on;
hpts=plot(X(:,1),X(:,2),'r+');
htxt=text(X(:,1)+20,X(:,2),num2str([1:size(X,1)]'));
set(htxt,'color','r')

% examples of how to use helper functions 
% (delete this part from your submission)
fprintf(1,'Distance between points 18 and 22 is %.1f pixels.\n',...
    imdist([X(18,:) 1],[X(22,:) 1]));
h=plotimageline(gca,dims,cross([X(18,:) 1],[X(22,:) 1]));
set(h,'color','y');

% insert your code here
l0 = cross([X(5,:) 1],[X(9,:) 1])';
l1 = cross([X(7,:) 1],[X(8,:) 1])';
l2 = cross([X(13,:) 1],[X(14,:) 1])';
vanish_l = (cross(l0,l1)'*cross(l1,l2))*l1+2*(cross(l0,l1)'*cross(l2,l1))*l2;
b1 = [X(3,:) 1];
b2 = [X(2,:) 1];
u = cross(cross(b1,b2),vanish_l);
t1 = [X(4,:) 1];
t2 = [X(1,:) 1];
v= cross(cross(b1,t1),cross(b2,t2));
new_l2 = cross(v,b2);
t1_d = cross(cross(t1,u),new_l2);
t1_d = t1_d./sqrt(sum(t1_d.^2));
b2 = b2./sqrt(sum(b2.^2));
d_t1_d = imdist(t1_d,b2);
t2 = t2./sqrt(sum(t2.^2));
d_t2 = imdist(t2,b2);
v = v./sqrt(sum(v.^2));
d_v = imdist(v,b2);
ratio = d_t1_d*(d_v-d_t2)/(d_t2*(d_v-d_t1_d));
% output Ying's height here
d=ratio*HANDRAIL;
fprintf('height is %f',d);
%%%
%%% SUB ROUTINES
%%%

function h=plotimageline(hax,dims,L)
% plot line on image
%  hax: handle to axis
%  dims: [h w] of image
%  L: homogeneous three-vectors of lines, one per row

if size(L,2) ~= 3
    error('Unexpected line dimensions');
end

numL=size(L,1);
h=zeros(numL,1);

% extreme points of lines
xCoords = [1 dims(2)];
yCoords = - (repmat(L(:,1),[1,2]) .* repmat(xCoords,[numL,1]) + repmat(L(:,3),[1,2])) ./ repmat(L(:,2),[1 2]);
for i=1:numL
    h(i)=plot(hax,xCoords, yCoords(i,:), 'b', 'LineWidth', 1);
end
return

function d=imdist(x1,x2);
% Euclidean image distance between two homogeneous vectors
x1i=x1(1:2)/x1(3);
x2i=x2(1:2)/x2(3);
d=sqrt(sum((x1i-x2i).^2));
return;

