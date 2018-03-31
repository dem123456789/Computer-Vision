function [x_norm] = normalize(x,m_x,std_x)
tmp = bsxfun(@minus,x,m_x);
x_norm =  bsxfun(@rdivide,tmp,std_x);
end