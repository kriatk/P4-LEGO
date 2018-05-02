clc; close all; clear all;
%Step 1: load positive sample data from .mat file. 
%Default value for TruePositiveRate is 0.995

load('Blue&RedClassifiedBricks.mat');

positiveInstances=Blue&RedClassifiedBricks(:,1:2);

imDir=fullfile(C:\Users\rober\Documents\4th Semester\P4\Training photos\Black);
addpath(imDir);

negativeFolder=fullfile(C:\Users\rober\Documents\4th Semester\P4\Training photos\Background);

negativeImages=imageDatastore(negativeFolder);

trainCascadeObjectDetector('brickDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5);
