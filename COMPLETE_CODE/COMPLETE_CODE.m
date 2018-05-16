clc;
clear all;
close all;
addpath('./functions/');
%% Settings
tic;
%camerasettings
% obj = videoinput('winvideo', 2, 'MJPG_640x480'); 
% set(obj,'ReturnedColorSpace','rgb');

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
minimumSize= 400; 
thresholdHist = 50; 

% load classifier data and train
% load Feature_space.mat;
% load Feature_space_classifier.mat;
 feature_space = importdata('feature_space_extended_allsides.mat');

%[trainedClassifier, validationAccuracy] = trainClassifier(feature_space) 
[trainedClassifier, validationAccuracy] = trainClassifier_svm_fg(feature_space)

% create class label library
% 1-blue_med;
% 2-blue_small;
% 3-car;
% 4-gray;
% 5-green_plate; 
% 6-red;
% 7-red_long;
% 8-white;
% 9-yellow_long;
% 10-yellow_round;

basic_set = {'blue_6x2';'blue_2x1';'blue_car';'gray_26';'green_4x4';'red_8x4';'red_8x1';'white2x2';'yellow_10x1';'yellow_round'};
extended_set = {'beige_4x2';'beige_8x1';'orange_4x2';'orange_round';'Prop';'red_4x2';'red_round';'violet_4x2';'white_4x2';'yellow_4x2'}
label_library = [basic_set;extended_set]

toc
%% scan tag of box

%% get present set from ID
% for now defining the set manualy, but something like this should come out from the barcode fucntion (OBS do NOT name the variabel 'set'.. )
brick_set = [1 2 3 4 5 6 7 8 9 10];
brick_set';

%% move tray using UR5
%          bricks are placed on tray and spread by hand
 
%% Take picture
% I = getsnapshot(obj);sound(100);
% I=imread('C:\Users\Stefan_Na\OneDrive\MOE\P4\Pictures\Set_10_bricks\2.jpg');
I=imread('D:\Google Drev\AAU\4 semester\P4\Pictures\Training pictures\Testing_Sets\20_brick_tops\10.jpg');
Igray=rgb2gray(I);

%% identify Blobs
tic;
% get binary image
binaryImage=histogram_binarymap(I, thresholdHist,minimumSize,maximumSize,1);

%get blob measurements
[labeledImage,numObjects] = bwlabel(binaryImage, 8);
blobMeasurements= regionprops(labeledImage, Igray, 'all');
% blobMeasurements= regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity'); %for specific measurments
numberOfBlobs = size(blobMeasurements, 1);

toc
%% identify color
color.r=struct2cell(regionprops(labeledImage, I(:,:,1), 'PixelValues'))';
color.g=struct2cell(regionprops(labeledImage, I(:,:,2), 'PixelValues'))';
color.b=struct2cell(regionprops(labeledImage, I(:,:,3), 'PixelValues'))';

for i=1:length(color.r)
    blobMeasurements(i).color=[mean(color.r{i}),mean(color.g{i}),mean(color.b{i})];
    blobMeasurements(i).colorLabel=colornames('MATLAB',blobMeasurements(i).color/255);
end

%% run classifier over blobs and identify present blobs
tic
%           also identify blobs that should not be there

stats = regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity'); %for specific measurments
stats = struct2table(stats);
    
predictor = trainedClassifier.predictFcn(stats);
toc
%% show outlines of blobs (new method with labels)
tic;
%now with classification and named labels
for i=1:length(blobMeasurements);
pos(i,:) = blobMeasurements(i).BoundingBox;
end

% retrieve corresponding label names for the set 
% set can be defined of labels in a random order from the barcode, as long as it is
% in the label library it can look it up
for i = 1:length(predictor);
    label_idx = predictor(i);
    label = label_library(label_idx);
    blobMeasurements(i).label=label;
    label_str(i,1) = label;
end

label_outline = insertObjectAnnotation(I,'rectangle',pos,label_str,'TextBoxOpacity',0.7,'FontSize',10);
figure
imshow(label_outline)
title('Annotated bricks');
toc
%% compare present bricks from the picture to set list
%           output status of the set
tic;
brick_set = sort(brick_set);
predictor = sort(predictor);

if isequal(predictor,brick_set)
    print('Prediction  match the defined set')
end

% save box status with Scancode in Database
toc;
%% UR5 move tray away

