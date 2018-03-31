function [] = plotpenta(coor,C,color)
patch(coor(:,1),coor(:,2),coor(:,3),color)
vertices = [coor;C];
faces = [1 2 5;2 3 5; 3 4 5;4 1 5];
patch('Faces',faces,'Vertices',vertices,'FaceColor',color)
end