function [x] = denormalize(x_norm,m_x,std_x)
tmp = bsxfun(@times,x_norm,std_x);
x = bsxfun(@plus,tmp,m_x);
end