clear all; close all; clc;

% These were aquired with Iterate_through_images.m code 11/05/2018
% Full features for our first 10 brick set #1
blue_med = importdata('Blue_medium_features.mat');
blue_small = importdata('Blue_small_features.mat');
car = importdata('Car_features.mat');
gray = importdata('Gray_features.mat');
green_plate = importdata('Green_plate_features.mat');
red = importdata('Red_features.mat');
red_long = importdata('Red_long_features.mat');
white = importdata('White_features.mat');
yellow_long = importdata('Yellow_long_features.mat');
yellow_round = importdata('Yellow_round_features.mat');

% Conssilidate the table to aquire complete feature space
feature_space = [blue_med;blue_small;car;gray;green_plate; red;red_long;white;yellow_long;yellow_round;]
% Add class labels for supervised learning
label = zeros(1, height(feature_space));

for i=1:height(blue_med)+1
        label(i) = 1;
end
for i=i:i+height(blue_small)
        label(i) = 2;
end
for i=i:i+height(car)
       label(i) = 3;
end
for i=i:i+height(gray)
        label(i) = 4;
end
for i=i:i+height(green_plate)
        label(i) = 5;
end
for i=i:i+height(red)
        label(i) = 6;
end
for i=i:i+height(red_long)
        label(i) = 7;
end
for i=i:i+height(white)
        label(i) = 8;
end
for i=i:i+height(yellow_long)
        label(i) = 9;
end
for i=i:i+height(yellow_round)-1
        label(i) = 10;
end

label = label';
feature_space.Label=label;




