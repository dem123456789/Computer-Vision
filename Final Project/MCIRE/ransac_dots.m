%% Part a
% Fit to all points.

% read "dots outliers" file
im = imread('./data/dots_outliers.tif');
dims = size(im);

% read coordinates of dots:
inds = find(im);
[y,x] = ind2sub(dims(1:2), inds);

% construct A and y matrices for each color channel and find least?squares
% solution of corresponding homogeneous linear system:

% red
numDots = length(x);
A = [x, y, ones(numDots, 1)];
[~, ~, V] = svd(A);
lineAll = V(:, 3);
% create extreme points of calculated lines
xCoords = [1 dims(2)];
yCoords = - (lineAll(1) * xCoords + lineAll(3)) / lineAll(2);
% plot resuts on top of "dots outliers"
figure; imshow(im); hold on;
plot(xCoords, yCoords, 'r-', 'LineWidth', 2);
%% Part b
% Use RANSAC to prune outliers.
% RANSAC parameters
threshold = 20;
numIters = 100;
N = length(x);
bestConsensusSet = [];
sizeBestConsensusSet = length(bestConsensusSet);
objBestConsensusset = 0;
for iter = 1:numIters,
sampledInds = randperm(N, 2);
% make corresponding homogeneous vectors
X1 = [x(sampledInds(1)); y(sampledInds(1)); 1];
X2 = [x(sampledInds(2)); y(sampledInds(2)); 1];
% find line as a homogeneous vector
l = cross(X1, X2);
% normalize line so that its inner product with another homogeneous vector
% is equal to the perpendicular distance between the line and the point
% corresponding to that vector
scaleFactor = hypot(l(1), l(2));
l = l / scaleFactor;
% find distances of all points from line
distances = abs(l(1) * x + l(2) * y + l(3));
% threshold and check if a better consensus set has been found
consensusSet = find(distances < threshold);
if (length(consensusSet) < sizeBestConsensusSet),
continue;
end;
if ((length(consensusSet) == sizeBestConsensusSet) && ...
(sum(distances(consensusSet)) > objBestConsensusset))
continue;
end;
bestConsensusSet = consensusSet;
sizeBestConsensusSet = length(consensusSet);
objBestConsensusset = sum(distances(consensusSet));
end;
% fit line to selected points
xConsensus = x(bestConsensusSet);
yConsensus = y(bestConsensusSet);
AConsensus = [xConsensus, yConsensus, ones(sizeBestConsensusSet, 1)];
[~, ~, VConsensus] = svd(AConsensus);
lineConsensus = VConsensus(:, 3);
% create extreme points of calculated lines
xCoords = [1 dims(2)];
yCoords = - (lineConsensus(1) * xCoords + lineConsensus(3)) / lineConsensus(2);
% plot resuts on top of "dots outliers"
plot(xCoords, yCoords, 'g-', 'LineWidth', 2);
lineConsensus = -lineConsensus./lineConsensus(2);
lineConsensus = [lineConsensus(1) lineConsensus(3)];
save('ransac_dots','lineConsensus','bestConsensusSet')