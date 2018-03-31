function synthim = SynthTexture(sourceimage, w, synthdims)
maxerrthresh = 0.3;
seedsize = 3;
targetimage = zeros(synthdims);
seedpatch = sourceimage(5:7,4:6);
[imagesizex,imagesizey] = size(sourceimage);
halfwindow = (w-1)/2;
imagesizecentered = [(imagesizex - w + 1) (imagesizey - w + 1)];
seedrows = ceil(synthdims(1)/2)-ceil(seedsize/2)+1:ceil(synthdims(1)/2)+(seedsize-ceil(seedsize/2));
seedcols = ceil(synthdims(2)/2)-ceil(seedsize/2)+1:ceil(synthdims(2)/2)+(seedsize-ceil(seedsize/2));
targetimage(seedrows,seedcols) = seedpatch;
nfilled = seedsize * seedsize;
nfailed = 0; 
npixels = prod(synthdims);
G = fspecial('gaussian',w, w/6.4);
filled = false(synthdims); 
filled(seedrows, seedcols) = true;
while nfilled < npixels
    stuck =false;
    SE = strel('square',w);
    neighbour_bool = imdilate(filled,SE)-filled;
    [neighbourrow, neighbourcol] = find(neighbour_bool);
    filledcounts = colfilt(filled, [w w], 'sliding', @sum); 
    num_filled_neighbors = filledcounts(sub2ind(size(filled),neighbourrow, neighbourcol)); 
    [~, sortindex] = sort(num_filled_neighbors, 1, 'descend');    
    neighbourrow = neighbourrow(sortindex); 
    neighbourcol = neighbourcol(sortindex); 
    for i = 1:length(neighbourrow)
        pixelrow = neighbourrow(i);
        pixelcol = neighbourcol(i);       
        rowspan = pixelrow-halfwindow:pixelrow+halfwindow;
        colspan = pixelcol-halfwindow:pixelcol+halfwindow;
        rowbound = rowspan < 1 | rowspan > synthdims(1);
        colbound = colspan < 1 | colspan > synthdims(2); 
        if any(rowbound)||any(colbound) 
            saferow = rowspan(~rowbound); 
            safecol = colspan(~colbound); 
            temp = zeros(w, w); 
            temp(~rowbound, ~colbound) = targetimage(saferow, safecol); 
            validmask = false([w w]); 
            validmask(~rowbound, ~colbound) = filled(saferow, safecol); 
        else
            temp = targetimage(rowspan, colspan);
            validmask = filled(rowspan, colspan); 
        end  
        [pixvalues, matcherrors] = FindMatches(temp, validmask, sourceimage, G);
        matchidx = find(pixvalues);
        perm = randperm(length(matchidx));
        matchidx_sampled = matchidx(perm(1));
        matcherror = matcherrors(matchidx_sampled);
        if matcherror < maxerrthresh 
            [matchrow, matchcol] = ind2sub(imagesizecentered, matchidx_sampled);
            matchrow_corrected = matchrow + halfwindow;
            matchcol_corrected = matchcol + halfwindow;
            targetimage(pixelrow, pixelcol) = sourceimage(matchrow_corrected, matchcol_corrected);
            filled(pixelrow, pixelcol) = true;  
            nfilled = nfilled + 1; 
        else
            stuck = true;
            nfailed = nfailed + 1; 
        end
    end
    if(stuck)
        maxerrthresh= maxerrthresh*1.1;
    end
end
synthim = targetimage;
end