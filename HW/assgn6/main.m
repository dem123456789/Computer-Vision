I1 = imread('./data/cheetah.jpg');
I2 = imread('./data/tiger.jpg');
I1 = im2gray(I1);
I2 = im2gray(I2);
sigma1 = 2;
sigma2 = 5;
G1d1 = gauss1d(sigma1);
G1d2 = gauss1d(sigma2);
[h1,w1] = freqz(G1d1);
[h2,w2] = freqz(G1d2);
figure
hold on
plot(w1/pi,abs(h1),'.-')
plot(w1/pi,1-abs(h1),'.-')
plot(w1/pi,abs(h2),'.-')
plot(w1/pi,1-abs(h2),'.-')
grid on
xlabel('Normalized frequency')
legend(sprintf('low-pass \\sigma = %0.1f',sigma1),sprintf('high-pass \\sigma = %0.1f',sigma1),sprintf('low-pass \\sigma = %0.1f',sigma2),sprintf('high-pass \\sigma = %0.1f',sigma2))

I1 = imresize(I1,[480 640]);
I2 = imresize(I2,[480 640]);
sigma1 = 2;
sigma2 = 5;
G2d1 = gauss2d(sigma1);
G2d2 = gauss2d(sigma2);
I_hybrid1 = conv2(I1,G2d1,'same')+(I2-conv2(I2,G2d1,'same'));
I_hybrid2 = conv2(I1,G2d2,'same')+(I2-conv2(I2,G2d2,'same'));
figure
imshow(I_hybrid1)
title(sprintf('hybrid image \\sigma = %0.1f',sigma1))
figure
imshow(I_hybrid2)
title(sprintf('hybrid image \\sigma = %0.1f',sigma2))