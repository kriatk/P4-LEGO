clc
clear


maximumSize= 15000; 
minimumSize= 400; 
thresholdHist = 50;

% create class label library
basic_set = ["blue_6x2";"blue_2x1";"blue_car";"gray_26";"green_4x4";"red_8x4";"red_8x1";"white2x2";"yellow_10x1";"yellow_round"];
extended_set = ["beige_4x2";"beige_8x1";"orange_4x2";"orange_round";"Prop";"red_4x2";"red_round";"violet_4x2";"white_4x2";"yellow_4x2"];
label_library = [basic_set;extended_set];

%% set classifier
% load('trainedModelKNN');
load('Feature_space_hue.mat')

%[trainedClassifier, validationAccuracy] = trainClassifier(feature_space) 
%[trainedClassifier, validationAccuracy] = trainClassifier_svm_fg(feature_space)
t = templateSVM('Standardize',1,'KernelFunction','gaussian','KernelScale',0.79);
% 
mdl=fitcecoc(feature_space,'Label','Learners',t,'FitPosterior',1);
%% get blobs

I=imread('C:\Users\Stefan_Na\OneDrive\MOE\P4\P4-LEGO\Expeiments for Blob and Color\COLOR\Same_Brick_different_color\2.jpg');
Igray=rgb2gray(I);

% get binary image
binaryImage=histogram_binarymap(I, thresholdHist,minimumSize,maximumSize,0);
[labeledImage,numObjects] = bwlabel(binaryImage, 8);
blobMeasurements= regionprops(labeledImage, Igray, 'all');

stats = regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity'); %for specific measurments

  %% get color
hsv=rgb2hsv(I);
hue=hsv(:,:,1);
color=regionprops(labeledImage, hue, 'PixelValues');

    for i=1:length(color)
    stats(i).meanHue=mean(color(i).PixelValues);
    end 

stats = struct2table(stats);

%% classify    
% predictor = trainedModelKNN.predictFcn(stats);
[predictor,NegLoss,PBScore,Posterior] = predict(mdl, stats);
% [label,score,cost] = predict(mdl,stats)
% predictor=label
%% show outlines of blobs (new method with labels)

%now with classification and named labels
for i=1:length(blobMeasurements);
pos(i,:) = blobMeasurements(i).BoundingBox;
end

% retrieve corresponding label names for the set 
% set can be defined of labels in a random order from the barcode, as long as it is
% in the label library it can look it up
for i = 1:length(predictor)
    label_idx = predictor(i);
    label = label_library(label_idx);
    blobMeasurements(i).label=label;
    label_str(i,1) = cellstr(label);
end

label_outline = insertObjectAnnotation(I,'rectangle',pos,label_str,'TextBoxOpacity',0.7,'FontSize',10);
figure
imshow(label_outline)
title('Annotated bricks');