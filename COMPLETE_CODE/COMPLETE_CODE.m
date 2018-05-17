clc;
clear all;
close all;
addpath('./functions/');
%% Settings
tic;
%camerasettings
% obj = videoinput('winvideo', 3, 'MJPG_640x480'); 
% set(obj,'ReturnedColorSpace','rgb');

% src_obj = getselectedsource(obj); 
% src_obj.Exposure = -3;
% src_obj.Contrast = 15;
% src_obj.Brightness = 10;
% src_obj.ExposureMode = 'manual';
% src_obj.BacklightCompensation = 'off';
% src_obj.Sharpness = 100;
% src_obj.Saturation = 50;

%% Bar Scanner init
%Create video object for scanner and set parameters
% scan_obj = videoinput('winvideo', 1, 'RGB24_320x240'); 
% scan_obj.TriggerRepeat = Inf;
% scan_obj.FrameGrabInterval = 10;
% set(scan_obj,'ReturnedColorSpace','rgb');
% 
% src_scan_obj = getselectedsource(obj); 
% 
% %Read video paraemters and setup according to the resolution
% get(src_scan_obj); 
% vidRes = get(scan_obj, 'VideoResolution'); 
% nBands = get(scan_obj, 'NumberOfBands'); 
% hImage = image( zeros(vidRes(2), vidRes(1), nBands) );  
% FinalCode1=0;

%%
% binary image settings
maximumSize= 15000; 
minimumSize= 400; 
thresholdHist = 50; 

% % UR5 settings
% ipAddress='192.168.1.13';
% tcpPose=[0,0,0,0,0,0];
% toolPayload=0.5;
% 
% robotMonitor=URmonitor(ipAddress);
% robotControl=URcontrol(ipAddress,tcpPose,toolPayload);
% 
% %Coordinates
% StartPose=[-0.0442   -1.4493    1.7641   -1.8809   -1.5670    0.7125];
% Pose1=[-0.7126   -1.2732    1.5578   -1.8527   -1.5657    0.0998];
% PoseGrab=[-0.7127   -1.2350    1.6360   -1.9690   -1.5661    0.1005];
% PoseBarcode=[-0.0442   -1.4493    1.7641   -1.8809   -1.5670    0.7125];
% PoseRecognition=[0.3243   -0.8805    0.9512   -1.6426   -1.5687   -0.4554];
% Pose2=[0.3464   -1.1174    1.3282   -1.7827   -1.5689   -0.4325];
% Pose3=[0.4797   -1.4883    1.8087   -1.8917   -1.5695   -0.2988];
% Pose4=[-0.0157   -1.4308    1.6685   -1.8279   -1.5428   -0.3813];
% Pose5=[-0.4038   -1.3514    1.5637   -1.8133   -1.5417   -0.4430];
% PoseFinish1=[0.5301   -1.4721    1.8850   -1.9839   -1.5694   -0.2932];
% PoseFinish=[0.5178   -1.4569    1.9286   -2.0507   -1.5472   -0.3051];
% PoseFinishLetGo=[0.5247   -1.4516    1.9227   -2.0440   -1.5599   -0.2982];
% PosePostFinish=[0.5161   -1.5283    1.7942   -1.8481   -1.5432   -0.3080];

% BarcodeReader=0;
% LegoIdentification=0;

% load classifier data and train
% load Feature_space.mat;
% load Feature_space_classifier.mat;
% feature_space = importdata('feature_space_extended_allsides.mat');
% feature_space = importdata('feature_space_fullset_faceup.mat');

%[trainedClassifier, validationAccuracy] = trainClassifier(feature_space) 
% [trainedClassifier, validationAccuracy] = trainClassifier_svm_fg(feature_space)

load mdl.mat;

% create class label library
% 1-blue_med;
% 2-blue_small;
% 3-car;
% 4-gray;
% 5-green_plate; 
% 6-red;
% 7-red_long;
% 8-white;
% 9-yellow_long;
% 10-yellow_round;

basic_set = ["blue_6x2";"blue_2x1";"blue_car";"gray_26";"green_4x4";"red_8x4";"red_8x1";"white2x2";"yellow_10x1";"yellow_round"];
extended_set = ["beige_4x2";"beige_8x1";"orange_4x2";"orange_round";"Prop";"red_4x2";"red_round";"violet_4x2";"white_4x2";"yellow_4x2"];
label_library = [basic_set;extended_set];

toc

%% move tray using UR5
% input('If tray is ready, press enter to start the process')
% pause(2);
% URcontrol.moveLinear(robotControl,'joint',StartPose);
% pause(2);
% URcontrol.gripperAction(robotControl,'open');
% pause(1);
% input('If tray is ready, press enter')
% 
% URcontrol.moveLinear(robotControl,'joint',Pose1,1,1);
% pause(3);
% URcontrol.moveLinear(robotControl,'joint',PoseGrab,1,1);
% pause(1);
% URcontrol.gripperAction(robotControl,'close');
% pause(1);
% URcontrol.moveLinear(robotControl,'joint',Pose1,1,1);
% pause(1);
% URcontrol.moveLinear(robotControl,'joint',PoseBarcode,1,1);
% input('barcode scan done, press enter')
% pause(1);

%% scan tag of box

% figure;
% start(scan_obj);
% while (FinalCode1==0)
%     %Read camera and show feed
%     ip_im = getdata(scan_obj,1);
%     imshow(ip_im);
%     drawnow
%     
%       %filter
%       fi_im=imsharpen(ip_im);
%       % Convert from RGB to Gray
%       gray_im= rgb2gray(fi_im);
%       %Threshold Image to black and white
%       J = im2bw(gray_im, graythresh(gray_im));
%       %Resize and process
%       J=imresize(J,[240 320]);
%       %Scanlines
%       Row = [80 120 160]';
%       %Transforms pixels in given rows into a feature vector.
%       [R,F] = Feature(J, Row);
%       %BAR detects bars from barcode feature signal.
%       [Center, Width, Num] = Bar(F);
%       %DETECTION returns sequence of indices to barcode guard bars
%       [Sequence, Num] = Detection(Width, Num, 2);
%       %CODEBOOK generats the look-up table for GTIN-13.
%       [LGCode, LCode, GCode, RCode, LCodeRev, GCodeRev, RCodeRev] = Codebook;
%       %Decode the barcode
%       [Code, Conf] = Recognition(Center, Width, Sequence, Num, LGCode, LCode, GCode, RCode, LCodeRev, GCodeRev, RCodeRev);
%       %Validation
%       OddSum= Code(1:1)+Code(3:3)+Code(5:5)+Code(7:7)+Code(9:9)+Code(11:11)+Code(13:13);
%       EvenSum = Code(2:2)+Code(4:4)+Code(6:6)+Code(8:8)+Code(10:10)+Code(12:12);
%       Checksums = OddSum + 3*EvenSum;
%       Valid = and((not(mod(Checksums,10))),(Conf >= 0.7));
%       FinalCode=uint64(0);
%       
%       for i = 1 :13
%           FinalCode=FinalCode*10 + uint64(Code(i:i));
%       end
%       if and(Valid ,(FinalCode ~= FinalCode1))
%           Code'
%           sprintf('%013i',FinalCode)
%           FinalCode1 = FinalCode';
%       end
% end
% %Need to close the feed
% stop(scan_obj)
% lego_box_id=FinalCode;
lego_box_id=1101;


%% get present set from ID
% for now defining the set manualy, but something like this should come out from the barcode fucntion (OBS do NOT name the variabel 'set'.. )
lego_set_id = read_set_id(lego_box_id);
parameters_of_set = parameters_of_set_id(lego_set_id);

brick_set = [1 2 3 4 5 6 7 8 9 10];
brick_set';


%% Move Tray to picture taking area (To use, needs to have stated somewhere BarcodeReader=1)
% if BarcodeReader=1
%     URcontrol.moveLinear(robotControl,'joint',PoseRecognition,1,1);
%     pause(1.5);
% end
%% Take picture
% I = getsnapshot(obj);sound(100);
I=imread('C:\Users\Stefan_Na\OneDrive\MOE\P4\Pictures\Set_10_bricks\2.jpg');
% I=imread('D:\Google Drev\AAU\4 semester\P4\Pictures\Training pictures\Testing_Sets\20_brick_tops\10.jpg');
Igray=rgb2gray(I);

%% identify Blobs
tic;
% get binary image
binaryImage=histogram_binarymap(I, thresholdHist,minimumSize,maximumSize,1);

%get blob measurements
[labeledImage,numObjects] = bwlabel(binaryImage, 8);
blobMeasurements= regionprops(labeledImage, Igray, 'all');
% blobMeasurements= regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity'); %for specific measurments
numberOfBlobs = size(blobMeasurements, 1);

toc
%% identify color
color.r=struct2cell(regionprops(labeledImage, I(:,:,1), 'PixelValues'))';
color.g=struct2cell(regionprops(labeledImage, I(:,:,2), 'PixelValues'))';
color.b=struct2cell(regionprops(labeledImage, I(:,:,3), 'PixelValues'))';

for i=1:length(color.r)
    blobMeasurements(i).color=[mean(color.r{i}),mean(color.g{i}),mean(color.b{i})];
    blobMeasurements(i).colorLabel=colornames('MATLAB',blobMeasurements(i).color/255);
end

%% run classifier over blobs and identify present blobs
tic
%           also identify blobs that should not be there

stats = regionprops(binaryImage, Igray, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'ConvexArea', 'Eccentricity', 'EquivDiameter', 'Perimeter', 'Solidity', 'MeanIntensity'); %for specific measurments
stats = struct2table(stats);
    
%predictor = trainedClassifier.predictFcn(stats);
[predictor,NegLoss,PBScore,Posterior] = predict(
,stats);
toc
%% show outlines of blobs (new method with labels)
tic;
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
toc
%% compare present bricks from the picture to set list
%           output status of the set
status_of_set = update_status(label_library,predictor,lego_box_id,parameters_of_set);%labels=
stats_labels=[label_library';status_of_set]


tic;
brick_set = sort(brick_set);
predictor = sort(predictor);

if isequal(predictor,brick_set)
    print('Prediction  match the defined set')
end

% save box status with Scancode in Database
toc;

%% UR5 move tray away (To use, needs to have stated somewhere LegoIdentification=1)
% if LegoIdentification==1
%     URcontrol.moveLinear(robotControl,'joint',Pose2,1,1);
%     pause(1.5);
%     URcontrol.moveLinear(robotControl,'joint',Pose3,1,1);
%     pause(1.5);
% 
%     URcontrol.moveLinear(robotControl,'joint',PoseFinish1,1,1);
%     pause(1.5);
%     URcontrol.moveLinear(robotControl,'joint',PoseFinishLetGo,1,1);
%     pause(1);
%     URcontrol.gripperAction(robotControl,'open');
%     pause(1);
% 
%     URcontrol.moveLinear(robotControl,'joint',PosePostFinish,1,1);
% end