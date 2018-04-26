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
    cam_image_ntsc=rgb2ntsc(cam_image);
     
    NT=cam_image_ntsc(:,:,1);
    S=cam_image_ntsc(:,:,2);
    C=cam_image_ntsc(:,:,3);
     
%figure;
subplot(4,2,1), imshow(NT); title('NT Plane');
subplot(4,2,2), imshow(S); title('S Plane');
subplot(4,2,3), imshow(C); title('C Plane');
subplot(4,2,4), imshow(cam_image_ntsc); title('Original NTSC Image');

levelh = 0.26; %higher more black
levels = 0.1; %higher more withe
levelv = 0.10; %higher more black, lower less black

nti=imbinarize(NT,levelh) ;%& not(imbinarize(H,levelh2));
si=imbinarize(S,levels);
ci=imbinarize(C,levelv);
NTSCsum = (nti | si | ci );

%figure(2);
% Plot the data
subplot(4,2,5), imshow(nti);
title('N Plane');
subplot(4,2,6), imshow(si);
title('T Plane');
subplot(4,2,7), imshow(ci);
title('SC Plane');
subplot(4,2,8), imshow(NTSCsum);
title('Sum of all the planes');
drawnow;
end


mxNiDeleteContext(KinectHandles);