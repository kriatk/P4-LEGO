%April 23
%Save figure as a video to use it later without hooking up to a camera
%Added pushbutton while loop 


close all;
clear all;
addpath('Mex')

KinectHandles=mxNiCreateContext();
%DlgH = figure;
%H = uicontrol('Style', 'PushButton', ...
%                   'String', 'Break', ...
%                  'Callback', 'delete(gcbf)');

cam_image=mxNiPhoto(KinectHandles); 
cam_image=permute(cam_image,[3 2 1]);

%while (ishandle(H));
counter=0;
for i=1:2000
    cam_image=mxNiPhoto(KinectHandles);cam_image=permute(cam_image,[3 2 1]);
    
    %disp(clock);
    %cam_image=imadjust(cam_image,stretchlim(cam_image));
    
    h1=imshow(cam_image);
    
   
    set(h1,'CDATA',cam_image);
    
    
    drawnow;
    if mod(i,100)==0
        
        export_fig(gcf,('C:\Users\rober\Documents\4th Semester\P4\Training photos\Test'),(sprintf('white_%d',counter)),'-native')
counter=counter+1;
    end 
end

    
mxNiDeleteContext(KinectHandles);