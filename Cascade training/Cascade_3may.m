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
%and no ROBERT - the computer did not let me save in the matlab folder so
%had to do it here...
imDir=fullfile('C:\Users\Frede\Desktop\Cascader\3may\Training'); %change this directory to your own
addpath(imDir);

negativeFolder=fullfile('C:\Users\Frede\Desktop\Cascader\3may\Negative'); %change this directory to your own

negativeImages=imageDatastore(negativeFolder);

%Black
trainCascadeObjectDetector('Black.xml',Black, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%Car
trainCascadeObjectDetector('Car.xml',Car, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%Yellow
trainCascadeObjectDetector('Yellow.xml',Yellow, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%LongRed
trainCascadeObjectDetector('LongRed.xml',LongRed, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%Red
trainCascadeObjectDetector('Red.xml',Red, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%Gray
trainCascadeObjectDetector('Gray.xml',Gray, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%Green
trainCascadeObjectDetector('Green.xml',Green, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%SmallBlue
trainCascadeObjectDetector('SmallBlue.xml',SmallBlue, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%Brown
trainCascadeObjectDetector('Brown.xml',Brown, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%Blue
trainCascadeObjectDetector('Blue.xml',Blue, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',10);
%% Testing phase
img = imread('Train_0.png'); %picture to test with
detector = vision.CascadeObjectDetector('LongRed.xml'); %classifier to test with
bbox = step(detector,img); %find object that matches in picture
a = size(bbox); a1 = a(1) %the output of a1 is the number of boxes detected
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Box'); %drawing boxes around the bricks
figure; 
imshow(detectedImg);