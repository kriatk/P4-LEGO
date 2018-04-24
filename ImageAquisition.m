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
     
     C=B(:,:,1);
     D=B(:,:,2);
     
     %C=im2bw(C,graythresh(C));
     regions_sat=detectMSERFeatures(D);
     regions_hue=detectMSERFeatures(C);
 %corners=detectSURFFeatures(B);
 %strongest=selectStrongest(corners,100);
 %[vector, vis]=extractFeatures(B,strongest,'Method','SURF');
 

 
 subplot(1,2,1), h1=imshow(C);title('MSER feature detection on Hue');
 hold on;
 plot(regions_hue,'showPixelList',true,'showEllipses',false);
 hold off;
 subplot(1,2,2), h2=imshow(D);title('on Saturation');
 hold on;
 plot(regions_sat,'showPixelList',true,'showEllipses',false);
 
 hold off;
    
    %set(h1,'CDATA',cam_image);
    
    drawnow; 
end


mxNiDeleteContext(KinectHandles);