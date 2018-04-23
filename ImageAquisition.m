%April 23
%Save figure as a video to use it later without hooking up to a camera
%Added pushbutton while loop 

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



while (ishandle(H));
    cam_image=mxNiPhoto(KinectHandles);cam_image=permute(cam_image,[3 2 1]);
    %disp(clock);
    
    h1=imshow(cam_image);
        
    set(h1,'CDATA',cam_image);
    
    drawnow;
end


mxNiDeleteContext(KinectHandles);