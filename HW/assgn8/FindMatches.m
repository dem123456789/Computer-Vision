function [pixvalues, matcherrors] = FindMatches(targetwindow, validmask, sourceimage, G)
errthresh = 0.1;
w0 = validmask.*G; 
w0=w0/sum(w0(:)); 
w1 = ones(size(sourceimage));
matcherrors =  conv2(w1,rot90(w0 .* targetwindow.^2,2),'valid')-2*conv2(w1 .* sourceimage,rot90(w0 .* targetwindow,2),'valid') + conv2(w1.* sourceimage.^2,rot90(w0,2),'valid');
pixvalues = matcherrors<= max([0,min(matcherrors(:))])*(1+errthresh);
end