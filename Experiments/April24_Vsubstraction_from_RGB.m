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
     A=rgb2hsv(cam_image);
     B=round(cam_image);
     
     
     imshow(B);
     
     
     
    
    
    drawnow; 
end


mxNiDeleteContext(KinectHandles);