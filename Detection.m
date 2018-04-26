%% Color Based Segmentation
% This example preprocesses and image with color based segmentation in the RGB color space.  
% After segmenting the image, region properties are extracted to count and label the objects. 

% Copyright 2014 The MathWorks, Inc.


%% Read in image
%I = imread('image.jpg');
I = imread('black_separated_light.png');
I=imresize(I,4);
imshow(I);

%% Solution:  Thresholding the image on each color pane
%Im=double(img)/255;
Im=I;

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

levelh = 0.26; %higher more black
levels = 0.1; %higher more withe
levelv = 0.10; %higher more black, lower less black
i1=imbinarize(NT,levelh) ;%& not(imbinarize(H,levelh2));
i2=imbinarize(S,levels);
i3=imbinarize(C,levelv);
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

%% Complement Image and Fill in holes
Icomp = imcomplement(not(Isum));
Ifilled = imfill(Icomp,'holes');
figure, imshow(Ifilled);

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


