clear;
%% Specify robot parameters
ipAddress='192.168.1.13';
tcpPose=[0,0,0,0,0,0];
toolPayload=0.5;

%% Create Robot Objects
robotMonitor=URmonitor(ipAddress);

robotControl=URcontrol(ipAddress,tcpPose,toolPayload);

%%
StartPose=[-0.0442   -1.4493    1.7641   -1.8809   -1.5670    0.7125];
Pose1=[-0.7126   -1.2732    1.5578   -1.8527   -1.5657    0.0998];
PoseGrab=[-0.7127   -1.2350    1.6360   -1.9690   -1.5661    0.1005];
PoseBarcode=[-0.0442   -1.4493    1.7641   -1.8809   -1.5670    0.7125];
PoseRecognition=[0.3243   -0.8805    0.9512   -1.6426   -1.5687   -0.4554];
Pose2=[0.3464   -1.1174    1.3282   -1.7827   -1.5689   -0.4325];
Pose3=[0.4797   -1.4883    1.8087   -1.8917   -1.5695   -0.2988];
Pose4=[-0.0157   -1.4308    1.6685   -1.8279   -1.5428   -0.3813];
Pose5=[-0.4038   -1.3514    1.5637   -1.8133   -1.5417   -0.4430];
PoseFinish1=[0.5301   -1.4721    1.8850   -1.9839   -1.5694   -0.2932];
PoseFinish=[0.5178   -1.4569    1.9286   -2.0507   -1.5472   -0.3051];
PoseFinishLetGo=[0.5247   -1.4516    1.9227   -2.0440   -1.5599   -0.2982];
PosePostFinish=[0.5161   -1.5283    1.7942   -1.8481   -1.5432   -0.3080];
%% Process
pause(2);
URcontrol.moveLinear(robotControl,'joint',StartPose);
pause(2);
URcontrol.gripperAction(robotControl,'open');
pause(1);
input('If tray is ready, press enter')

URcontrol.moveLinear(robotControl,'joint',Pose1,1,1);
pause(3);
URcontrol.moveLinear(robotControl,'joint',PoseGrab,1,1);
pause(1);
URcontrol.gripperAction(robotControl,'close');
pause(1);
URcontrol.moveLinear(robotControl,'joint',Pose1,1,1);
pause(1);
URcontrol.moveLinear(robotControl,'joint',PoseBarcode,1,1);
input('barcode scan done, press enter')
pause(1);
URcontrol.moveLinear(robotControl,'joint',PoseRecognition,1,1);
input('control done, press enter')
pause(1);
URcontrol.moveLinear(robotControl,'joint',Pose2,1,1);
pause(2);
URcontrol.moveLinear(robotControl,'joint',Pose3,1,1);
pause(2);

URcontrol.moveLinear(robotControl,'joint',PoseFinish1,1,1);
pause(2);
URcontrol.moveLinear(robotControl,'joint',PoseFinishLetGo,1,1);
pause(1);
URcontrol.gripperAction(robotControl,'open');
pause(1);


URcontrol.moveLinear(robotControl,'joint',PosePostFinish,1,1);

%% Putting it back to start

URcontrol.moveLinear(robotControl,'joint',PoseFinishLetGo,1,1);
pause(2);

URcontrol.gripperAction(robotControl,'close');
pause(1);
URcontrol.moveLinear(robotControl,'joint',PosePostFinish,1,1);
pause(1.5);
URcontrol.moveLinear(robotControl,'joint',Pose4,1,1);
pause(1.5);
URcontrol.moveLinear(robotControl,'joint',Pose5,1,1);
pause(1.5);
URcontrol.moveLinear(robotControl,'joint',Pose1,1,1);
pause(1.5);
URcontrol.moveLinear(robotControl,'joint',PoseGrab,1,1);
pause(1);
URcontrol.gripperAction(robotControl,'open');
pause(1);
URcontrol.moveLinear(robotControl,'joint',Pose1,1,1);
pause(1);


