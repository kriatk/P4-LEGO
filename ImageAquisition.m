%April 23
%Added pushbutton while loop 

clc;
close all;
clear all;
addpath('Mex')


KinectHandles=mxNiCreateContext();
%DlgH = figure;
H = uicontrol('Style', 'PushButton', ...
                    'String', 'Break', ...
                    'Callback', 'delete(gcbf)');

cam_image=mxNiPhoto(KinectHandles); 
cam_image=permute(cam_image,[3 2 1]);

%subplot(1,2,1), h1=imshow(cam_image);



while (ishandle(H))
     cam_image=mxNiPhoto(KinectHandles);cam_image=permute(cam_image,[3 2 1]);
     cam_image=imadjust(cam_image,stretchlim(cam_image));
     
     B=rgb2hsv(cam_image);
     
     gray=rgb2gray(cam_image);
     
     C=B(:,:,1);
     D=B(:,:,2);
     
    
     regions_sat=detectMSERFeatures(D);
     regions_hue=detectMSERFeatures(C);
     regions_gray=detectMSERFeatures(gray)
     %corners=detectSURFFeatures(B);
     %strongest=selectStrongest(corners,100);
     %[vector, vis]=extractFeatures(B,strongest,'Method','SURF');
 

 
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
    
end


mxNiDeleteContext(KinectHandles);