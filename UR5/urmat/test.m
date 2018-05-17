clear;
%% Specify robot parameters
ipAddress='192.168.1.13';
tcpPose=[0,0,0,0,0,0];
toolPayload=0.5;

%% Create Robot Objects
robotMonitor=URmonitor(ipAddress);

robotControl=URcontrol(ipAddress,tcpPose,toolPayload);


%% Open Gripper
URcontrol.gripperAction(robotControl,'open')

startingPoint=URmonitor.getRobotInfo(robotMonitor,'jointState');

%% Testing moveCircular
display('Testing moveCircular and teaching mode')

input('Drive robot to via point of circular movement end press enter')
wayPoint=URmonitor.getRobotInfo(robotMonitor,'jointState');

input('Drive robot to final point of circular movement end press enter')
finalPoint=URmonitor.getRobotInfo(robotMonitor,'jointState');

URcontrol.moveLinear(robotControl,'joint',startingPoint);
pause(2);
URcontrol.moveCircular(robotControl,wayPoint,finalPoint);
pause(3);
%% Close Gripper
URcontrol.gripperAction(robotControl,'close')

%% Testing moveLinear joint space with pose
initialPose=URmonitor.getRobotInfo(robotMonitor,'gripperPose');
input('Drive robot to target pose of linear movemet end press enter')
targetPose=URmonitor.getRobotInfo(robotMonitor,'gripperPose');
tic;
while toc<15
URcontrol.moveLinear(robotControl,'joint',initialPose);
URmonitor.waitForExecution(robotMonitor);
URcontrol.moveLinear(robotControl,'joint',targetPose);
URmonitor.waitForExecution(robotMonitor);
end

%% Testing linear movement in tool space
initialPose=URmonitor.getRobotInfo(robotMonitor,'gripperPose');

input('Drive robot to target pose of linear movemet end press enter')
targetPose=URmonitor.getRobotInfo(robotMonitor,'gripperPose');
tic;
while toc<15
URcontrol.moveLinear(robotControl,'tool',initialPose);
pause(3);
URcontrol.moveLinear(robotControl,'tool',targetPose);
pause(3);
end

%% Testing servoing
startingPoint=URmonitor.getRobotInfo(robotMonitor,'jointState');
input('Drive to target')
target=URmonitor.getRobotInfo(robotMonitor,'jointState');
URcontrol.moveLinear(robotControl,'joint',startingPoint);
pause(3);
URcontrol.servoToTarget(robotControl,target,20)
URmonitor.waitForExecution(robotMonitor);

%% Testing follow joint Trajectory (requires RVC Toolbox)
close all
mdl_UR5;

%% Make the waypoints and poses

q0=URmonitor.getRobotInfo(robotMonitor,'jointState');
input('');
q1 =URmonitor.getRobotInfo(robotMonitor,'jointState');


%trajectory
[pos,vel,acc] = mtraj(@lspb,q0,q1,50);
%% Offline testing

ur5.plot(q0);

pause
ur5.plot(q1);

pause
ur5.plot(pos);


%% Online testing
URcontrol.moveLinear(robotControl,'joint',q0);
URmonitor.waitForExecution(robotMonitor);
URcontrol.followJointTrajectory(robotControl,pos)
URmonitor.waitForExecution(robotMonitor);
%% Close connection
URmonitor.closeConnections(robotMonitor,robotControl);

