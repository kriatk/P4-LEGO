%April 23
%Added pushbutton while loop 

clc;
close all;
clear all;
% addpath('Mex')
% 
% 
% KinectHandles=mxNiCreateContext();
% %DlgH = figure;
% H = uicontrol('Style', 'PushButton', ...
%                     'String', 'Break', ...
%                     'Callback', 'delete(gcbf)');
% 
% cam_image=mxNiPhoto(KinectHandles); 
% cam_image=permute(cam_image,[3 2 1]);
% 
% %subplot(1,2,1), h1=imshow(cam_image);
% 
% 
% 
% while (ishandle(H))
%      cam_image=mxNiPhoto(KinectHandles);cam_image=permute(cam_image,[3 2 1]);
%      cam_image=imadjust(cam_image,stretchlim(cam_image));


%% Import and RGB
cam_image =imread('lego_own.jpg');
rmat=cam_image(:,:,1);
gmat=cam_image(:,:,2);
bmat=cam_image(:,:,3);

figure;
subplot(2,2,1), imshow(rmat);
title('Red Plane');
subplot(2,2,2), imshow(gmat);
title('Green Plane');
subplot(2,2,3), imshow(bmat);
title('Blue Plane');
subplot(2,2,4), imshow(cam_image);
title('Original RGB Image');

levelr = 0.59;
levelg = 0.48;
levelb = 0.40;
ri1=imbinarize(rmat,levelr);
gi2=imbinarize(gmat,levelg);
bi3=imbinarize(bmat,levelb);
RGBsum = (ri1&gi2&bi3);

figure;
subplot(2,2,1), imshow(ri1);
title('Red Plane');
subplot(2,2,2), imshow(gi2);
title('Green Plane');
subplot(2,2,3), imshow(bi3);
title('Blue Plane');
subplot(2,2,4), imshow(RGBsum);
title('Sum of all the planes');

%%  HSV     
     
     cam_image_hsv=rgb2hsv(cam_image);
     
     H=cam_image_hsv(:,:,1);
     S=cam_image_hsv(:,:,2);
     V=cam_image_hsv(:,:,3);
     
figure;
subplot(2,2,1), imshow(H);
title('H Plane');
subplot(2,2,2), imshow(S);
title('S Plane');
subplot(2,2,3), imshow(V);
title('V Plane');
subplot(2,2,4), imshow(cam_image_hsv);
title('Original HSV Image');

levelh = 0.5; %higher more black
levelh2 =0.7;
levels = 0.7; %higher more withe
levelv = 0.6; %higher more black, lower less black
hi1=imbinarize(H,levelh) ;%& not(imbinarize(H,levelh2));
si2=imbinarize(S,levels);
vi3=imbinarize(V,levelv);
HSVsum = (hi1 | si2 );%| not(bi3));

figure;
% Plot the data
subplot(2,2,1), imshow(hi1);
title('H Plane');
subplot(2,2,2), imshow(si2);
title('S Plane');
subplot(2,2,3), imshow(vi3);
title('V Plane');
subplot(2,2,4), imshow(HSVsum);
title('Sum of all the planes');

%% Complement Image and Fill in holes
Icomp = imcomplement(HSVsum);
Ifilled = imfill(HSVsum,'holes');
figure, imshow(Ifilled);


%% Gray
     gray=rgb2gray(cam_image);
     
     C=cam_image_hsv(:,:,1);
     D=cam_image_hsv(:,:,2);
     
    
     regions_sat=detectMSERFeatures(D);
     regions_hue=detectMSERFeatures(C);
     regions_gray=detectMSERFeatures(gray)
     %corners=detectSURFFeatures(B);
     %strongest=selectStrongest(corners,100);
     %[vector, vis]=extractFeatures(B,strongest,'Method','SURF');
 

 figure;
 subplot(2,2,1), h1=imshow(C);title('MSER feature detection on Hue');
 hold on;
 plot(regions_hue,'showPixelList',true,'showEllipses',false);
 hold off;
 
 subplot(2,2,2), h2=imshow(D);title('on Saturation');
 hold on;
 plot(regions_sat,'showPixelList',true,'showEllipses',false);
 hold off;
 
 subplot(2,2,3), h3=imshow(gray);title('on gray image');
 hold on;
 plot(regions_gray,'showPixelList',true,'showEllipses',false);
 hold off;
 
 subplot(2,2,4),h4=imshow(cam_image);title('cam image');
    
    %set(h4,'CDATA',cam_image);
    
    drawnow; 
% end


% mxNiDeleteContext(KinectHandles);