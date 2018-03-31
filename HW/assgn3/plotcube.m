function [] = plotcube(coor,color)
vertices = coor;
faces = [1 2 3 4;3 4 5 6;6 7 2 3;1 4 5 8;5 6 7 8;7 8 1 2];
patch('Faces',faces,'Vertices',vertices,'FaceColor',color)
end