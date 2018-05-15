clear all; close all; clc;

% These were aquired with Iterate_through_images.m code 11/05/2018
% Full features for our first 10 brick set #1
Beige4x2 = importdata('Beige_4x2.mat');
Beige8x1 = importdata('Beige_8x1.mat');
Orange4x2 = importdata('Orange_4x2.mat');
Orange_round = importdata('Orange_Round.mat');
Propeller = importdata('Propeller.mat');
Red4x2 = importdata('Red_4x2.mat');
Red_round = importdata('Red_Round.mat');
Violet4x2 = importdata('Violet_4x2.mat');
White4x2 = importdata('White_4x2.mat');
Yellow4x2 = importdata('Yellow_4x2.mat');

% Conssilidate the table to aquire complete feature space
feature_space = [Beige4x2;Beige8x1;Orange4x2;Orange_round;Propeller; Red4x2;Red_round;Violet4x2;White4x2;Yellow4x2;]
% Add class labels for supervised learning
label = zeros(1, height(feature_space));

for i=1:height(Beige4x2)+1
        label(i) = 11;
end
for i=i:i+height(Beige8x1)
        label(i) = 12;
end
for i=i:i+height(Orange4x2)
       label(i) = 13;
end
for i=i:i+height(Orange_round)
        label(i) = 14;
end
for i=i:i+height(Propeller)
        label(i) = 15;
end
for i=i:i+height(Red4x2)
        label(i) = 16;
end
for i=i:i+height(Red_round)
        label(i) = 17;
end
for i=i:i+height(Violet4x2)
        label(i) = 18;
end
for i=i:i+height(White4x2)
        label(i) = 19;
end
for i=i:i+height(Yellow4x2)-1
        label(i) = 20;
end

label = label';
feature_space.Label=label;




