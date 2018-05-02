clc; close all; clear all;
%%
load('BlueClassified.mat');

positiveInstances = [gTruth.DataSource.Source(:,:),gTruth.LabelData(:,:)];

imDir=fullfile('C:\Users\Frede\Desktop\Cascader\Black');
addpath(imDir);

negativeFolder=fullfile('C:\Users\Frede\Desktop\Cascader\Background');

negativeImages=imageDatastore(negativeFolder);

trainCascadeObjectDetector('brickDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',6);
%%
detector = vision.CascadeObjectDetector('brickDetector.xml');
img = imread('white_45.png');
bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Box');
figure; 
imshow(detectedImg);