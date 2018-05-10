%% This is a script to detect one blob on a black surface

myFolder = 'C:\Users\Stefan_Na\OneDrive\MOE\P4\Pictures\Black'; % Define your working folder

filePattern = fullfile(myFolder, '*.png');
pictures = dir(filePattern);
picturesfull= {};

blobMeasurements=struct([]);
FileNames={};
figure;
for k = 1:length(pictures)
    baseFileName = pictures(k).name;
  fullFileName=fullfile(myFolder, baseFileName);
  FileNames=[FileNames;fullfile(myFolder, baseFileName)];
  picturesfull = [picturesfull;fullfile(myFolder, baseFileName)];

  I= imread(char(fullFileName));
  Igray=rgb2gray(I);

  thresholdValue = 100.5;
  
  
  binaryImage=histogram_binarymap(I, thresholdValue,1);
%   drawnow;
  
  %% get Blob measurements

labeledImage = bwlabel(binaryImage, 8);
% quickfix but removal of small blocs does not work
blobMeasurements= struct([blobMeasurements;regionprops(binaryImage, Igray, 'all')]);
numberOfBlobs = size(blobMeasurements, 1);
  
end

%% drop too samll blobs and adjust binary

allBlobAreas = [blobMeasurements.Area];
allowableBlobs = allBlobAreas > 300; % Take the big objects.
keeperIndexes = find(allowableBlobs);
keeperBlobsImage = ismember(labeledImage, keeperIndexes);
% figure; imshow(keeperBlobsImage)
binaryImage=keeperBlobsImage;
%% remove the small blobs from blobmeasurements
allBlobAreas = [blobMeasurements.Area];
notallowableBlobs = allBlobAreas < 300; % Take the small objects.
dropBlobs = find(notallowableBlobs);

for i=length(dropBlobs):-1:1
blobMeasurements(dropBlobs(i))=[];
end


