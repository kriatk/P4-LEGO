%April 23
%Added pushbutton while loop 

clc;
close all;
clear all;
addpath('Mex')


KinectHandles=mxNiCreateContext();
DlgH = figure;
H = uicontrol('Style', 'PushButton', ...
                    'String', 'Break', ...
                    'Callback', 'delete(gcbf)');

cam_image=mxNiPhoto(KinectHandles); 
cam_image=permute(cam_image,[3 2 1]);

subplot(1,2,1), h1=imshow(cam_image);



while (ishandle(H));
     cam_image=mxNiPhoto(KinectHandles);cam_image=permute(cam_image,[3 2 1]);
    B=rgb2gray(cam_image); 
 corners=detectBRISKFeatures(B);
 strongest=selectStrongest(corners,500);
 [vector, vis]=extractFeatures(B,strongest,'Method','SURF');
 

 
 
 subplot(1,2,2), h2=imshow(B);
 hold on;
 plot(vis);
 
 hold off;
    
    %set(h1,'CDATA',cam_image);
    
    drawnow; 
end


mxNiDeleteContext(KinectHandles);