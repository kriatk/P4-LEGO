clear all; close all; clc; 
% This code is an example of how to predict class of an extracted blob
%Load feature space and test image
load Feature_space;
img = imread('testImage.jpg');

% This image filetring is bad, but can be exchanged with some Stefan code
% or cascade classifier.
img_gray = rgb2gray(img);
level = graythresh(img_gray);
img_bw = imbinarize(img_gray,'global');
img_bw = imfill(img_bw, 'holes');
imshow(img_bw);

%Extract some info about the blobs & remove not allowable blobs
stats = regionprops(img_bw, img_gray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity');

minimumSize = 8000;
maximumSize = 11000;

allBlobAreas = [stats.Area];
notallowableBlobs = allBlobAreas < minimumSize; % Take the small objects.
notallowableBlobs1 = allBlobAreas > maximumSize;
notallowableBlobs=notallowableBlobs | notallowableBlobs1;
dropBlobs = find(notallowableBlobs);

for i=length(dropBlobs):-1:1
stats(dropBlobs(i))=[];
end

blobs = struct2table(stats);

%Train the classifier and make predcitions. %Quadratic SVM classifier function
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

[trainedClassifier, validationAccuracy] = trainClassifier(feature_space) 
yfit = trainedClassifier.predictFcn(blobs) 
