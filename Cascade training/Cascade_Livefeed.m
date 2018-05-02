clear all; clc; close all;
%%
addpath('Mex');

KinectHandles=mxNiCreateContext();

figure; %open figure
detector = vision.CascadeObjectDetector('brickDetector.xml'); %fix xml document
I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]); %define the kinect and take picture + resize
bbox = step(detector,I); %create box object with right size
detectedImg = insertObjectAnnotation(I,'rectangle',bbox,'Box'); %box it up
h1=imshow(detectedImg); %show first time
    
for i=1:10000
    bbox = step(detector,I);
    detectedImg = insertObjectAnnotation(I,'rectangle',bbox,'Box');
    
    I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
    set(h1,'CDATA',detectedImg);
    drawnow; 
end

mxNiDeleteContext(KinectHandles);