%% This is a script to detect one blob on a black surface
% clear all; close all; clc;

myFolder = 'C:\Users\Stefan_Na\OneDrive\MOE\P4\TRAIN\20'; % Define your working folder
lab=20
maximumSize= 15000; % 
minimumSize= 500; % 
thresholdHist = 50; %keep at 50 for all features to have the same precondition

filePattern = fullfile(myFolder, '*.jpg');
pictures = dir(filePattern);
picturesfull= {};

% blobMeasurements=struct([]);
allcolor=struct([]);
FileNames={};
figure;
for k = 1:length(pictures)
    baseFileName = pictures(k).name;
  fullFileName=fullfile(myFolder, baseFileName);
  FileNames=[FileNames;fullfile(myFolder, baseFileName)];
  picturesfull = [picturesfull;fullfile(myFolder, baseFileName)];

  I= imread(char(fullFileName));
  Igray=rgb2gray(I);

  binaryImage=histogram_binarymap(I, thresholdHist,minimumSize,maximumSize,0);
%   drawnow;
%   pause(2);
  %% get Blob measurements

labeledImage = bwlabel(binaryImage, 8);
blobMeasurements_pre=regionprops(labeledImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity');

hsv=rgb2hsv(I);
hue=hsv(:,:,1);
color=regionprops(labeledImage, hue, 'PixelValues');

    for i=1:length(color)
    blobMeasurements_pre(i).meanHue=mean(color(i).PixelValues);
    blobMeasurements_pre(i).Label=lab;
    end 
if size(blobMeasurements_pre) ~=0
blobMeasurements= struct([blobMeasurements;blobMeasurements_pre]);
% blobMeasurements= struct([blobMeasurements;regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity')]); %for specific measurments
end
numberOfBlobs = size(blobMeasurements, 1);
  
end


