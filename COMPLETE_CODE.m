clc 
clear

%% Settings
%camerasettings
% obj = videoinput('winvideo', 2, 'MJPG_640x480'); 
% set(obj,'ReturnedColorSpace','rgb');
% 
% src_obj = getselectedsource(obj); 
% src_obj.Exposure = -3;
% src_obj.Contrast = 15;
% src_obj.Brightness = 10;
% src_obj.ExposureMode = 'manual';
% src_obj.BacklightCompensation = 'off';
% src_obj.Sharpness = 100;
% src_obj.Saturation = 50;

% binary image settings
maximumSize= 15000; 
minimumSize= 500; 
thresholdHist = 50; 


%% scan tag of box

%% get present set from ID

%% move tray using UR5
%          bricks are placed on tray and spread by hand
 
%% Take picture
% I = getsnapshot(obj);sound(100);
I=imread('C:\Users\Stefan_Na\OneDrive\MOE\P4\Pictures\Set_10_bricks\2.jpg');
Igray=rgb2gray(I);

%% identify Blobs
% get binary image
binaryImage=histogram_binarymap(I, thresholdHist,minimumSize,maximumSize,1);

%get blob measurements
labeledImage = bwlabel(binaryImage, 8);
blobMeasurements= regionprops(labeledImage, Igray, 'all');
% blobMeasurements= struct([blobMeasurements;regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity')]); %for specific measurments
numberOfBlobs = size(blobMeasurements, 1);

% identify blobs

%% identify color

%% run classifier over blobs and identify present blobs
%           also identify blobs that should not be there

%% compare present bricks from the picture to set list
%           output status of the set

% save box status with Scancode in Database

%% UR5 move tray away

