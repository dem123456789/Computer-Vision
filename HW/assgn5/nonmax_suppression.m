function Co=nonmax_suppression(C)
SE = strel('square',3);
Co = imdilate(C,SE);
end