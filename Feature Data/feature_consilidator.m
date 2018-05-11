clear all; close all; clc;

% These were aquired with Iterate_through_images.m code 11/05/2018
red = importdata('Red_features.mat');
gray = importdata('Gray_features.mat');
car = importdata('Car_features.mat');

% Conssilidate the table to aquire complete feature space
feature_space = [red;gray;car];

% Add class labels for supervised learning
label = zeros(1, height(feature_space));
for i=1:height(red)+1
    label(i) = 1;
end
for i=i:(i+height(gray))
    label(i) = 2;
end
for i=i:(i+height(car))-1
    label(i) = 3;
end
label = label'
feature_space.Label = label;



