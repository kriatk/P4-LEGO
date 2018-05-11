clear all; close all; clc; 

load Feature_space;
img = imread('testImage.jpg');

img_gray = rgb2gray(img);
level = graythresh(img_gray);
img_bw = imbinarize(img_gray,'global');
img_bw = imfill(img_bw, 'holes');
imshow(img_bw);

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

[trainedClassifier, validationAccuracy] = trainClassifier(feature_space) %Quadratic SVM classifier function
yfit = trainedClassifier.predictFcn(blobs) % 1 Red; 2 Gray; 3 Car;
