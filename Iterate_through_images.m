%% This is a script to detect one blob on a black surface

myFolder = 'C:\Users\Stefan_Na\OneDrive\MOE\P4\Pictures\Black'; % Define your working folder

filePattern = fullfile(myFolder, '*.png');
pictures = dir(filePattern);
picturesfull= {};

blobMeasurements={};
figure;
for k = 1:length(pictures)
    baseFileName = pictures(k).name;
  fullFileName=fullfile(myFolder, baseFileName)
  picturesfull = [picturesfull;fullfile(myFolder, baseFileName)];

  I= imread(char(fullFileName));
  Igray=rgb2gray(I);

  thresholdValue = 100.5;
  
  
  binaryImage=histogram_binarymap(I, thresholdValue);
  drawnow;
  
  %% get Blob measurements

labeledImage = bwlabel(binaryImage, 8);
% quickfix but removal of small blocs does not work
blobMeasurements= [blobMeasurements;regionprops(binaryImage, Igray, 'all')];
numberOfBlobs = size(blobMeasurements, 1);
  
end

%% drop too samll blobs and adjust binary

allBlobAreas = [blobMeasurements.Area];
allowableBlobs = allBlobAreas > 300; % Take the small objects.
keeperIndexes = find(allowableBlobs);
keeperBlobsImage = ismember(labeledImage, keeperIndexes);
% figure; imshow(keeperBlobsImage)
binaryImage=keeperBlobsImage;



