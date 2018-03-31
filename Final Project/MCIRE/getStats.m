function [m_x,std_x,m_y,std_y] = getStats(x,y)
m_x = mean(x,1);
std_x = std(x,1);
m_y = mean(y,1);
std_y = std(y,1);
save('stats','m_x','std_x','m_y','std_y');
end