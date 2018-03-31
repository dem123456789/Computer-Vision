% load('./data/corners.mat')
% [M,T,X] = AffineFactorization(corners);
% figure;
% plot3(X(:,1),X(:,2),X(:,3),'.');
% grid on;
% axis equal;
% n = size(X,1);
% m = size(T,2);
% tmp_1 = 0;
% for i = 1:m
%     tmp_1 = tmp_1 + sum((corners(:,:,i)'-(M((i-1)*2+1:i*2,:)*X'+repmat(T(:,i),1,n))).^2,2);
% end
% rms_1 = sqrt(tmp_1/(m*n));
%%
% [M_up,X_up] = Upgrade(M,X);
% figure;
% plot3(X_up(:,1),X_up(:,2),X_up(:,3),'.');
% axis equal;
% grid on;
% tmp_2 = 0;
% for i = 1:m
%     tmp_2 = tmp_2 + sum((corners(:,:,i)'-(M_up((i-1)*2+1:i*2,:)*X_up'+repmat(T(:,i),1,n))).^2,2);
% end
% rms_2 = sqrt(tmp_2/(m*n));
%%
im = imread('./data/Cameraman_PeriodicNoise.tif');
[N,M] = size(im);
[X,Y] = meshgrid(1:M,1:N);
centered_im = (-1).^(X+Y).*double(im);
F = fft2(centered_im);
tmp_F = F;
tmp_F(M/2+1,N/2+1)=0;
mag_F = abs(tmp_F);
% figure;
% imshow(mag_F,[])
% title('DFT of the image')
D0 = 91;
w = 10;
D = @(u,v) ((u-(M/2+1)).^2 + (v-(N/2+1)).^2).^(1/2);
H = @(u,v,D0,w) 1 - exp(-1/2*((D(u,v).^2-D0^2)./(w*D(u,v))).^2);
[U,V] = meshgrid(1:size(F,1),1:size(F,2));
Z = H(U,V,D0,w);
% figure;
% surf(U,V,Z)
% title('transfer function')
%%c
F_p = F.*Z;
I = ifft2(F_p);
decentered_I =(-1).^(X+Y).*real(I);
A = mat2gray(decentered_I);
B = mat2gray(im);
diff_inten = A-B;
% figure;
% subplot(2,2,1)
% imshow(im,[]);
% title('corrupted image')
% subplot(2,2,2)
% imshow(Z,[]);
% title(sprintf('transfer function as image,D_0=%d,w=%d',D0,w))
% subplot(2,2,3)
% imshow(A,[]);
% title('filtered image')
% subplot(2,2,4)
% imshow(diff_inten,[]);
% title('intensity difference')
%%
% delta = zeros(N,M);
% delta(1,1) = 1;
% centered_delta = (-1).^(X+Y).*double(delta);
% F_delta = fft2(centered_delta);
% F_delta_p = F_delta.*Z;
% I_delta = ifft2(F_delta_p);
% decentered_I_delta =(-1).^(X+Y).*real(I_delta);
% ir = mat2gray(decentered_I_delta);
% tmp_ir = ir;
% tmp_ir(1,1) = 0;
% % figure;
% % imshow(tmp_ir,[]);
%%
w = [20 40];
for i=1:length(w)
    Z = H(U,V,D0,w(i));
    F_p = F.*Z;
    I = ifft2(F_p);
    decentered_I =(-1).^(X+Y).*real(I);
    A = mat2gray(decentered_I);
    B = mat2gray(im);
    diff_inten = A-B;
    figure;
    subplot(2,2,1)
    imshow(im,[]);
    title('corrupted image')
    subplot(2,2,2)
    imshow(Z,[]);
    title(sprintf('transfer function as image,D_0=%d,w=%d',D0,w(i)))
    subplot(2,2,3)
    imshow(A,[]);
    title('filtered image')
    subplot(2,2,4)
    imshow(diff_inten,[]);
    title('intensity difference')
end