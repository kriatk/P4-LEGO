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
    A=cam_image;
    bw=rgb2gray(A);
    HSV=rgb2hsv(cam_image); 
    h=HSV(:,:,1);
    s=HSV(:,:,2);
    v=HSV(:,:,3);
    
    hs=imadd(h,s);
    r=A(:,:,1);
    g=A(:,:,2);
    b=A(:,:,3);
    r=double(r);
    hv=imadd(h,v);
    
    %ghs=imsubtract(g,hs);
    %bhs=imsubtract(b,hs);
    %rghs=imadd(rhs,ghs);
    %rgbhs=imadd(rghs,bhs);
   
    mask=v< 0.3;
    %h(mask)=0;
    %s(mask)=0;
    %v(mask)=1;
    %hsv=cat(3,h,s,v);
    %newRGB=hsv2rgb(hsv);
    BW=activecontour(bw,mask,100,'Chan-Vese');
    
    subplot(2,2,1), imshow(BW);
    %subplot(2,2,2), imshow(s);
    %subplot(2,2,3), imshow(v);
    %subplot(2,2,4), imshow(hs);
    
    drawnow; 
    
end


mxNiDeleteContext(KinectHandles);