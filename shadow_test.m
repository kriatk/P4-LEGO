I = imread('black_separated_light.png');
Iblur = imgaussfilt(I, 20);
%Display all results for comparison.

subplot(1,2,1)
imshow(I)
title('Original Image');
subplot(1,2,2)
imshow(Iblur)
title('Gaussian filtered image, \sigma = 2')