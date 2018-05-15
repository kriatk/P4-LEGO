%% This is a script to detect one blob on a black surface
clear all; close all; clc;
addpath('./functions/');

myFolder = 'C:\Users\Stefan_Na\OneDrive\MOE\P4\Pictures\Set_10_bricks'; % Define your working folder

maximumSize= 15000; % 
minimumSize= 500; % 
thresholdHist = 50; %keep at 50 for all features to have the same precondition

filePattern = fullfile(myFolder, '*.jpg');
pictures = dir(filePattern);
picturesfull= {};

blobMeasurements=struct([]);
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

  binaryImage=histogram_binarymap(I, thresholdHist,minimumSize,maximumSize,1);
%   drawnow;
%   pause(2);
  %% get Blob measurements

labeledImage = bwlabel(binaryImage, 8);
% quickfix but removal of small blocs does not work
blobMeasurements= struct([blobMeasurements;regionprops(binaryImage, Igray, 'all')]);
% blobMeasurements= struct([blobMeasurements;regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity')]); %for specific measurments
numberOfBlobs = size(blobMeasurements, 1);
  %% get color
r=regionprops(labeledImage, I(:,:,1), 'PixelValues');
g=regionprops(labeledImage, I(:,:,2), 'PixelValues');
b=regionprops(labeledImage, I(:,:,3), 'PixelValues');
    for i=1:length(r)
    rgb(i,1).test=1;
    end 
rgb=mergestruct(rgb,r);
[rgb.r] = rgb.PixelValues;
rgb = rmfield(rgb,'PixelValues');
rgb=mergestruct(rgb,g);
[rgb.g] = rgb.PixelValues;
rgb = rmfield(rgb,'PixelValues');
rgb=mergestruct(rgb,b);
[rgb.b] = rgb.PixelValues;
rgb = rmfield(rgb,'PixelValues');
rgb = rmfield(rgb,'test');
allcolor=struct([allcolor;rgb]);
rgb=[];
end


