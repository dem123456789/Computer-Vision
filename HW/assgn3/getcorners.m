function corners = getcorners(im)
[m,n,~]=size(im);
corners = [1,1,1;1,m,1;n,m,1;n,1,1]';
end % end function getC