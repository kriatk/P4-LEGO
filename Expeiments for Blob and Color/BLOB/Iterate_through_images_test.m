%% This is a script to detect one blob on a black surface
clear all; close all; clc;
% addpath('./functions/');
myFolder = 'C:\Users\Stefan_Na\OneDrive\MOE\P4\P4-LEGO\Expeiments for Blob and Color\close bricks_10'; % Define your working folder

maximumSize= 15000; % 
minimumSize= 500; % 
thresholdHist = 36 %for Red

% maximumSize= 5000; % for Red
% minimumSize= 1000; % for Red
% maximumSize= 11000; % for Gray
% minimumSize= 9000; % for Gray

% maximumSize= 11000; % for BlueCar
% minimumSize= 9500; % for BlueCar

% thresholdHist = 100; %for Red
% thresholdHist = 52; %for Gray
% thresholdHist = 41; %for BlueCar


filePattern = fullfile(myFolder, '*.jpg');
pictures = dir(filePattern);
picturesfull= {};
Number_of_blobs=0;
blobMeasurements=struct([]);
FileNames={};
touching_blobs=struct([]);
 
% figure;
for k = 1:length(pictures)
    baseFileName = pictures(k).name;
  fullFileName=fullfile(myFolder, baseFileName);
  FileNames=[FileNames;fullfile(myFolder, baseFileName)];
  picturesfull = [picturesfull;fullfile(myFolder, baseFileName)];

  I= imread(char(fullFileName));
  Igray=rgb2gray(I);
  Number_of_blobs=0;
%   thresholdHist = 33;
 
% while Number_of_blobs <9
  [binaryImage, Number_of_blobs]=histogram_binarymap(I, thresholdHist,minimumSize,maximumSize,0);
%   thresholdHist=thresholdHist+1
  Number_of_blobs
figure; imshow(binaryImage)
%   if thresholdHist >40
%       touching_blobs(k).file=baseFileName;
%       touching_blobs(k).thresh=thresholdHist;
%       touching_blobs(k).blobs=Number_of_blobs;
%       break;
%   else
      touching_blobs(k).file=baseFileName;
      touching_blobs(k).thresh=thresholdHist;
      touching_blobs(k).blobs=Number_of_blobs;
%   end
%       
% end
%   drawnow;
%   pause(2);
  %% get Blob measurements

labeledImage = bwlabel(binaryImage, 8);
% quickfix but removal of small blocs does not work
blobMeasurements= struct([blobMeasurements;regionprops(binaryImage, Igray, 'all')]);
% blobMeasurements= struct([blobMeasurements;regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity')]); %for specific measurments
numberOfBlobs = size(blobMeasurements, 1);
  %% get color
%   Pixelcolors = find(binaryImage);
	
end

%% drop too samll blobs and adjust binary

% allBlobAreas = [blobMeasurements.Area];
% allowableBlobs = allBlobAreas > 300; % Take the big objects.
% keeperIndexes = find(allowableBlobs);
% keeperBlobsImage = ismember(labeledImage, keeperIndexes);
% % figure; imshow(keeperBlobsImage)
% binaryImage=keeperBlobsImage;
%% remove the small blobs from blobmeasurements
% allBlobAreas = [blobMeasurements.Area];
% notallowableBlobs = allBlobAreas < minimumSize; % Take the small objects.
% notallowableBlobs1 = allBlobAreas > maximumSize;
% notallowableBlobs=notallowableBlobs | notallowableBlobs1;
% dropBlobs = find(notallowableBlobs);
% 
% for i=length(dropBlobs):-1:1
% blobMeasurements(dropBlobs(i))=[];
% end

% blobMeasurments = struct2table(blobMeasurements);
