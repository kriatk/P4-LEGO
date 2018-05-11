clear all; close all; clc;

red = importdata('Red_features.mat');
gray = importdata('Gray_features.mat');
car = importdata('Car_features.mat');

feature_space = [red;gray;car];
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



