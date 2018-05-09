clc; close all; clear all;
%% Creating one big table with all the labels
load('labeled00to56.mat');
Sources = [gTruth.DataSource.Source(:,:)];
Sources1 = repmat(Sources,10,1);
%labels
T1 = [gTruth.LabelData(:,1)];
T2 = [gTruth.LabelData(:,2)];
T3 = [gTruth.LabelData(:,3)];
T4 = [gTruth.LabelData(:,4)];
T5 = [gTruth.LabelData(:,5)];
T6 = [gTruth.LabelData(:,6)];
T7 = [gTruth.LabelData(:,7)];
T8 = [gTruth.LabelData(:,8)];
T9 = [gTruth.LabelData(:,9)];
T10 = [gTruth.LabelData(:,10)];
T11 = table2cell(T1(:,1));
T22 = table2cell(T2(:,1));
T33 = table2cell(T3(:,1));
T44 = table2cell(T4(:,1));
T55 = table2cell(T5(:,1));
T66 = table2cell(T6(:,1));
T77 = table2cell(T7(:,1));
T88 = table2cell(T8(:,1));
T99 = table2cell(T9(:,1));
T1010 = table2cell(T10(:,1));
Labels = [T11;T22;T33;T44;T55;T66;T77;T88;T99;T1010];
Data = [Sources1(:,1),Labels(:,1)];
Data1 = cell2table(Data);
%% Training the classifier
imDir=fullfile('C:\Program Files\MATLAB\R2017b\toolbox\vision\visiondata\BrickTrainingData');
addpath(imDir);
negativeFolder=fullfile('C:\Program Files\MATLAB\R2017b\toolbox\vision\visiondata\BrickTrainingData\Negative');
negativeImages=imageDatastore(negativeFolder); %converts negative images to datastore

trainCascadeObjectDetector('CascadeClassifier.xml',Data1, ...
   negativeImages,'FalseAlarmRate',0.1,'NumCascadeStages',10,'FeatureType','HOG');
%% One xml file run
detector = vision.CascadeObjectDetector('CascadeClassifier.xml');
img = imread('Train_0.png');
bbox = step(detector,img);
a = size(bbox); a1 = a(1)
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Box');
figure; 
imshow(detectedImg);
title(['Bricks found in picture: ', num2str(a1)]);