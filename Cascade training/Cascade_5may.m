clc; close all; clear all;
%% Creating the different tables for each type of bricky
load('labeled00to56.mat');
Black = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,1)];
Car = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,2)];
Yellow = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,3)];
LongRed = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,4)];
Red = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,5)];
Gray = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,6)];
Green = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,7)];
SmallBlue = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,8)];
Brown = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,9)];
Blue = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,10)];
%% Training the classifiers 
%Tried with "Haar" and "LBG" but they are super shit. Go with "HOG".
imDir=fullfile('C:\Program Files\MATLAB\R2017b\toolbox\vision\visiondata\BrickTrainingData\Training');
addpath(imDir);
negativeFolder=fullfile('C:\Program Files\MATLAB\R2017b\toolbox\vision\visiondata\BrickTrainingData\Negative');
negativeImages=imageDatastore(negativeFolder); %converts negative images to datastore
%Black
trainCascadeObjectDetector('Black.xml',Black, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%Car
trainCascadeObjectDetector('Car.xml',Car, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%Yellow
trainCascadeObjectDetector('Yellow.xml',Yellow, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%LongRed
trainCascadeObjectDetector('LongRed.xml',LongRed, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%Red
trainCascadeObjectDetector('Red.xml',Red, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%Gray
trainCascadeObjectDetector('Gray.xml',Gray, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%Green
trainCascadeObjectDetector('Green.xml',Green, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%SmallBlue
trainCascadeObjectDetector('SmallBlue.xml',SmallBlue, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%Brown
trainCascadeObjectDetector('Brown.xml',Brown, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%Blue
trainCascadeObjectDetector('Blue.xml',Blue, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%% Testing phase
AllXMLFiles = {'Black.xml';'Car.xml';'Yellow.xml';'LongRed.xml';'Red.xml'; ...
    'Gray.xml';'Green.xml';'SmallBlue.xml';'Brown.xml';'Blue.xml'}; %puts all the xml files together in one cell
img = imread('Train_0.png'); %picture to test with
bbox = cell(10,1);
for i = 1:10 %runs through all xml files and saves the location of the brick
    detector = vision.CascadeObjectDetector(cell2mat(AllXMLFiles(i))); %classifier to test with
    bbox1 = step(detector,img); %find object that matches in picture
    sb = size(bbox1); %checks if any bricks were found
    if sb(1) == 1
        bbox{i} = step(detector,img);
    else
        bbox{i} = 0;
    end
end
bbox2 = bbox;
bbox2(cellfun(@(x) ~x(1),bbox2(:,1)),:) = []; %converting
bbox2 = cell2mat(bbox2); %converting
NumberOfBricks = size(bbox2); NumberOfBricks1 = NumberOfBricks(1);
if bbox2 %if there are bricks found - show the pictures and save which bricks were found
    subplot(1,2,1);
    detectedImg = insertObjectAnnotation(img,'rectangle',bbox2,'This is a brick'); %drawing boxes around the bricks
    imshow(detectedImg);
    title(['Bricks found in picture: ', num2str(NumberOfBricks1)]);
    subplot(1,2,2);
    bbox_withcolors = [bbox,AllXMLFiles];
    bbox_withcolors(cellfun(@(x) ~x(1),bbox_withcolors(:,1)),:) = [];
    text(.3,0.6,bbox_withcolors(:,2))
    title('Bricks found in picture: ');
else %if no bricks were found - print this
    disp('No boxes found in le picture <3');
end
%% To be deleted
% img = imread('Train_0 - Copy.png'); %picture to test with
% detector = vision.CascadeObjectDetector('LongRed.xml'); %classifier to test with
% bbox = cell(2,1);
% bbox{1} = step(detector,img); %find object that matches in picture
% a = size(bbox); a1 = a(1); %the output of a1 is the number of boxes detected
% detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Box'); %drawing boxes around the bricks
% figure; %open new figure
% imshow(detectedImg);
% hold on;
% detector = vision.CascadeObjectDetector('Black.xml'); %classifier to test with
% bbox{2} = step(detector,img); %find object that matches in picture
% bbox = cell2mat(bbox);
% a = size(bbox); a2 = a(1); %the output of a1 is the number of boxes detected
% detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Brick'); %drawing boxes around the bricks
% imshow(detectedImg);
% a = size(bbox); a2 = a(1); %the output of a1 is the number of boxes detected