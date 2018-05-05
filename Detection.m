%% Detection of Blocks with Blob detection
tic; % Start timer.
clc; % Clear command window.
clearvars; % Get rid of variables from prior run of this m-file.
fprintf('Running Detection.m...\n'); % Message sent to command window.
workspace; % Make sure the workspace panel with all the variables is showing.
imtool close all;  % Close all imtool figures.
format long g;
format compact;
captionFontSize = 14;



%% Read in image
load('Lots_ofBlocks.mat','cam_image_cropped');
I=cam_image_cropped;
% I = imread('black_separated_light.png');
% I = imread('lego_own.jpg'); 
I=imresize(I,3);
[rows, columns, numberOfColorChannels] = size(I); 
imshow(I);

%% Histogram
Igray=rgb2gray(I);
Intsc=rgb2ntsc(I);
[pixelCount, grayLevels] = imhist(Igray(:,:,1));
figure;
subplot(2, 1, 1);
bar(pixelCount);
title('Histogram of original image', 'FontSize', captionFontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

hold on;
maxYValue = ylim;
line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% Place a text label on the bar chart showing the threshold.
annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
% For text(), the x and y need to be of the data class "double" so let's cast both to double.
text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);


thresholdValue = 62.5;
binaryImage = Igray > thresholdValue; % Bright objects will be chosen if you use >.
% ========== IMPORTANT OPTION ============================================================
% Use < if you want to find dark objects instead of bright objects.
%   binaryImage = originalImage < thresholdValue; % Dark objects will be chosen if you use <.

% Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
binaryImage = imfill(binaryImage, 'holes');

edge_corr= zeros(size(binaryImage));
for row=2:1:size(binaryImage,1)-1
    for col=2:1:size(binaryImage,2)-1
        if sum(sum(binaryImage(row-1:row+1,col-1:col+1))) ~=9 && binaryImage(row,col) == 1
            edge_corr(row,col)=1;
%             binaryImage(row,col)=0;
               
        end
        
    end
end

% for row=1:1:size(edge_corr,1)
%     for col=1:1:size(edge_corr,2)
%         if edge_corr(row,col)== 1
%             binaryImage(row,col)=0;
%         end
%     end
% end

binaryImage=not(edge_corr) & binaryImage;

subplot(2, 1, 2);
imshow(binaryImage)



%% Solution:  Thresholding the image on each color pane
%Im=double(img)/255;
Im=I;
%h= fspecial('gaussian',[5,5] , 2);
%I= imfilter(I,h);
rmat=Im(:,:,1);
gmat=Im(:,:,2);
bmat=Im(:,:,3);

subplot(2,2,1), imshow(rmat);
title('Red Plane');
subplot(2,2,2), imshow(gmat);
title('Green Plane');
subplot(2,2,3), imshow(bmat);
title('Blue Plane');
subplot(2,2,4), imshow(I);
title('Original Image');

%%
% levelr = 0.59;
% levelg = 0.48;
% levelb = 0.40;
% i1=im2bw(rmat,levelr);
% i2=im2bw(gmat,levelg);
% i3=im2bw(bmat,levelb);
% Isum = (i1&i2&i3);
% 
% % Plot the data
% subplot(2,2,1), imshow(i1);
% title('Red Plane');
% subplot(2,2,2), imshow(i2);
% title('Green Plane');
% subplot(2,2,3), imshow(i3);
% title('Blue Plane');
% subplot(2,2,4), imshow(Isum);
% title('Sum of all the planes');

%% NTSC

cam_image_ntsc=rgb2ntsc(I);
     
     NT=cam_image_ntsc(:,:,1);
     S=cam_image_ntsc(:,:,2);
     C=cam_image_ntsc(:,:,3);
     
figure(1);
subplot(2,2,1), imshow(NT);
title('NT Plane');
subplot(2,2,2), imshow(S);
title('S Plane');
subplot(2,2,3), imshow(C);
title('C Plane');
subplot(2,2,4), imshow(cam_image_ntsc);
title('Original NTSC Image');

levelnt = 0.28; %higher more black
levels = 0.60; %lower more withe
levelc = 0.15; %higher more black, lower less black
i1=imbinarize(NT,levelnt) ;%& not(imbinarize(H,levelh2));
i2=imbinarize(S,levels);
i3=imbinarize(C,levelc);
Isum = (i1 | i2 | i3 );

figure(2);
% Plot the data
subplot(2,2,1), imshow(i1);
title('N Plane');
subplot(2,2,2), imshow(i2);
title('T Plane');
subplot(2,2,3), imshow(i3);
title('SC Plane');
subplot(2,2,4), imshow(Isum);
title('Sum of all the planes');

%% EDGE detection
% I=cam_image_cropped;
% I=imresize(I,3);
% I_ycbcr= rgb2ycbcr(I);
% I_edge=edge(rgb2gray(I_ycbcr),'canny',0.24);
% figure;
% imshow(I_edge);
% size_binary=size(I_edge)
% edge_corr= zeros(size_binary);
% for row=1:size_binary(1);
%    for col=1:size_binary(2);
%        if I_edge(row,col)==1;
%           edge_corr(row-1:row+1,col-1:col+1)=1;
%        end
%    end
% end
% 
% figure;
% imshow(edge_corr);   
% 
% figure;
% imshow(not(edge_corr) & Isum);
% Isum=not(edge_corr) & Isum;

%% edgefiltering
% I_range=rangefilt(I);
% I_range_ntsc=rgb2ntsc(I_range);
% I_range_ntsc_gray=rgb2gray(I_range_ntsc);
% I_range_bin=imbinarize(I_range_ntsc_gray,0.02);
% figure;imshow(I_range_bin);

%% Complement Image and Fill in holes
Icomp = imcomplement(not(Isum));
Ifilled = imfill(Icomp,'holes');
figure; imshow(Ifilled);

%%
se = strel('disk', 1);
Iopenned = imopen(Ifilled,se);
% figure,imshowpair(Iopenned, I);
imshow(Iopenned);

%% Extract features

Iregion = regionprops(Iopenned, 'centroid');
[labeled,numObjects] = bwlabel(Iopenned,4);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];



%% Use feature analysis to count skittles objects
idxOfSkittles = find(eccentricities);
statsDefects = stats(idxOfSkittles);

figure, imshow(I);
hold on;
for idx = 1 : length(idxOfSkittles)
        h = rectangle('Position',statsDefects(idx).BoundingBox,'LineWidth',2);
        set(h,'EdgeColor',[.75 0 0]);
        hold on;
end
if idx > 10
title(['There are ', num2str(numObjects), ' objects in the image!']);
end
hold off;


