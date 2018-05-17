classdef URcontrol
    %URCONTROL class for controlling the UR robots.
    %   Conatins methods for setting a traget pose, joint configuration.
    %   trajectory, open/close gripper etc on the UR robots. The  commands 
    %   are given through the secondary
    %   30002 port.
    
    properties
         connection
    end
    
    properties (Access='private')
       
        receivedPacket
        
    end
    
    methods
        function controlObj=URcontrol(ipAdress,tcpPose,payload)
        % Constructor
        % ipAdress the address of the robot
        % tcpPose the tool center pose of the gripper mm and rad
        % payload the weight of the gipper
             controlObj.connection = tcpip(ipAdress,30003,'InputBufferSize',1024,'OutputBufferSize',10000,'ByteOrder','littleEndian');
              % close connection in case that it as left open
        if strcmp( controlObj.connection.Status,'open')
             fclose(controlObj.connection);
        end
        % Open connection and check for incoming packets
        fopen( controlObj.connection);
        pause(0.3)
        controlObj.receivedPacket = uint8(fread(controlObj.connection)'); %% Read packet's header
       
        if isempty(controlObj.receivedPacket)
            error('The received packet is empty. Check IP adress and connection')
        end
         
          %Activate gripper
         controlObj.activateGripper(controlObj);
         controlObj.setTCP(controlObj,tcpPose);
         controlObj.setPayload(controlObj,payload);
        end
       
    end
    methods (Static)
        
        function moveCircular(controlObj,wayPoint,targetPoint,acc,vel)
            %moveCircular: Move to position (circular in tool-space)
            %TC moves on the circular arc segment from current pose, through
            %wayPoint. Accelerates to and moves with constant tool speed
            %
            %Inputs(Obligatory):      
            % controlObj         --> the robotControl object
            % wayPoint     --> 1-by-6 array Path point,can be joint conf in rads or pose in mm
            % targetPoint  --> 1-by-6 array The target joint conf (rads) or pose (mm)
            % 
            %Optional
            % acc   -->  tool acceleration, default value is 1.2 m/s^2
            % vel   -->  tool velocity,  default value is 0.26 m/sec
            %
            
            %The URscripts has to be given as strings through the
            %connection
            narginchk(3, 5);
            urScript='movec(';
            if nargin >= 3
                 commanndCell{1,1}=wayPoint;
                 commanndCell{1,2}=targetPoint;
            end
            if nargin >= 4
                commanndCell{1,3}=acc;
                
            end
            if nargin == 5
               commanndCell{1,4}=vel;
                
            end
             commandString=controlObj.createCommandString(commanndCell,urScript,controlObj);
              fprintf(controlObj.connection,commandString);
         
        end
        
        function moveLinear(controlObj,space,targetPoint, acc, vel, time)
        %moveLinerar: Move to position (linear in joint-space).
        %When using this command, the
        %robot must be at standstill or come from another moveLinear.
        %The speed and acceleration parameters controls the trapezoid
        %speed profile of the move. The $t$ parameters can be used in stead to
        %set the time for this move. Time setting has priority over speed and
        %acceleration settings. The blend radius can be set with the $r$
        %parameters, to avoid the robot stopping at the point. However, if he
        %blend region of this mover overlaps with previous or following regions,
        %this move will be skipped, and an â€™Overlapping Blendsâ€™ warning
        %message will be generated.
        %
        %Inputs (Obligatory): 
        % controlObj         --> the robotControl object
        %
        %  space        --> a string specifying whether the linear motion is in
        %                  joint or tool space e.g. 'joint' or 'tool'
        %
        %
        % targetPoint  --> 1-by-6 array. The traget of the movement. Can be the desirable
        %                  joint configuration (rad) or tool pose (mm and rad)
        %
        %
        %Optional Inputs
        % acc --> joint acceleration, default is 1.4 rad/s^2
        % vel --> joint velocities,  default is 1 rad/s
        % time -> execution time (sec). In case it is given, it overides acc and vel 
        
        narginchk(3, 6);
            if nargin >= 3
                commanndCell{1,1}=targetPoint;
               
            end
            if nargin >= 4
                commanndCell{1,2}=acc;
            end
            if nargin >= 5
           
                commanndCell{1,3}=vel;
                               
            end
            if nargin == 6
                commanndCell{1,4}=time;   
            end
            
              switch space
                  case 'joint'
                       urScript='movej(';
                  case 'tool'
                       urScript='movel(';
                  otherwise
                      error('Unknown space parameter for linear move');
              end
                  commandString=controlObj.createCommandString(commanndCell,urScript,controlObj);
              
            
                 fprintf(controlObj.connection,commandString);
           
        end
        function followJointTrajectory(controlObj,pos)
            %Follows the trajectory specified by pos,vel,acc
            %controlObj -> The control object
            %jointConfig        -> n-by-6 matrix. Joints' configuration for each
            %              trajectory point n
       
           
            urScript='movej(';
            concatCell={};
            for i=1:size(pos,1)
            commanndCell{1,1}=pos(i,:)+0.001;

             
            concatCell{1,end+1}=controlObj.createCommandString(commanndCell,urScript,controlObj);
            concatCell{1,end+1}='\n';
            end
            commandString=strjoin(concatCell,'');
         
            
            fprintf(controlObj.connection,commandString);
            
            
        end
        function moveProcess (controlObj,targetPoint,acc,vel)
            % Blend circular (in tool-space) and move linear (in tool-space) to
            % position. Accelerates to and moves with constant tool speed v.
            %
            %INPUTS (obligatory)
            % targetPoint  --> 1-by-6 array. The traget of the movement. Can be the desirable
            %                  joint configuration (rad) or tool pose (mm and rad)
            % controlObj         --> the robotControl object
            %
            %Optional Inputs
            % acc --> joint acceleration, default is 1.4 rad/s^2
            % vel --> joint velocities,  default is 1 rad/s
            
            narginchk(2, 4);
             urScript='movep(';
            if nargin >= 2
               
                commanndCell{1,1}=targetPoint;
            end
            if nargin >= 3
       
                commanndCell{1,2}=acc;
                
            end
            if nargin == 4
             
                commanndCell{1,3}=vel;
                
            end
          
             commandString=controlObj.createCommandString(commanndCell,urScript,controlObj);
           
              % Open connection and send command
            
              fprintf(controlObj.connection,commandString);
             
        end
        function servoToTarget (controlObj,targetPoint,time)
            %servoToTarget Servo to position. 
            % Accelerates to and moves
            % with constant tool speed v
            % If space ='tool' the servoing is circular in tool-space. 
            % if space ='joint' the servoing is linear in joint-space
            %
            %INPUTS (obligatory)
            % targetPoint  --> 1-by-6 array. The traget of the movement. Can be the desirable
            %                  joint configuration (rad) or tool pose (mm and rad)
            % controlObj         --> the robotControl object
            % 
            %time          --> servoing time
            
           
              commanndCell{1,1}=targetPoint;
               
              commanndCell{1,2}=1;
              commanndCell{1,3}=1;
              commanndCell{1,4}=time;
                
              urScript='servoj(';
                         
              commandString=controlObj.createCommandString(commanndCell,urScript,controlObj);
              display(commandString)
              % Open connection and send command
           
              fprintf(controlObj.connection,commandString);
             
         end
        function moveWithVelocity(controlObj,space,vel,acc,t_min)
             %moveWithVelocity Accelerate to and move with constant joint speed
             % The space parameter specifies whether the movement is on
             % tool or joints' space
            %INPUTS (obligatory)
            % 
            % controlObj         --> the robotControl object
            % space        --> a string specifying whether the velocity motion is in
            %                  joint or tool space e.g. 'joint' or 'tool'
            % vel --> 1-by-6 array target velocities,  For joints rad/s for tool m/s (spatial vector)
            % acc --> 1-by-6 array acceleration. For joints rad/s^2 for tool m/s^2
            % t_min --> time of the movement
             
                temp=sprintf('%s,',vel(1,1:end-1));
                commanndCell{1,2}=strcat('[',temp,num2str(vel(1,end)),']');
            
            
                temp=sprintf('%s,',acc(1,1:end-1));
                commanndCell{1,2}=strcat('[',temp,num2str(acc(1,end)),']');
          
           
                commanndCell{1,5}=',';
                commanndCell{1,6}=num2str(t_min);
                
             switch space
                  case 'joint'
                       commanndCell{1,1}='speedj(';
                  case 'tool'
                      commanndCell{1,1}='speedl(';
                  otherwise
                      error('Unknown space parameter for servoing');
             end
               commanndCell{1,end+1}=')';
              commandString=strjoin(commanndCell);
              % Open connection and send command
            
              fprintf(controlObj.connection,commandString);
             
             
         end
        function stopMovement(controlObj,space,acc)
             %moveWithVelocity Accelerate to and move with constant joint speed
             % The space parameter specifies whether the movement is on
             % tool or joints' space
            %INPUTS (obligatory)
            % 
            % controlObj--> the robotControl object
            % space --> a string specifying whether the stop takes place
            %                  e.g. 'joint' or 'tool'
            % acc --> 1-by-6 array acceleration. For joints rad/s^2 for tool m/s^2
         
             
                temp=sprintf('%s,',acc(1,1:end-1));
                commanndCell{1,2}=strcat('[',temp,num2str(acc(1,end)),']');
                          
             switch space
                  case 'joint'
                       commanndCell{1,1}='stopj(';
                  case 'tool'
                      commanndCell{1,1}='stopl(';
                  otherwise
                      error('Unknown space parameter for servoing');
             end
               commanndCell{1,end+1}=')';
              commandString=strjoin(commanndCell);
              %send command
             
              fprintf(controlObj.connection,commandString);
         
             
             end
         
             %%DOES NOT WORK FIX ME
%       function teachingMode(controlObj,status)
%              %tSet robot in teach mode. In this mode the robot can be moved around
%              %by hand in the same way as by pressing the â€?teachâ€? button. The robot
%              %will not be able to follow a trajectory (eg. a movej) in this mode.
%             %INPUTS (obligatory)
%             % 
%             % controlObj--> the robotControl object
%             % status --> logical true or false. Specifies if the robot gets
%             % in teaching mode (true) or exits teaching mode (false)
%          
%              switch status
%                   case true
%                       commandString='teach_mode()';
%                   case false
%                      commandString='end_teach_mode()';
%                   otherwise
%                       error('Unknown robot status parameter');
%              end
%              
%               % Open connection and send command
%               fopen(controlObj.connection);
%               
%               fprintf(controlObj.connection,commandString);
%                fclose(controlObj.connection);
%              
%              
%       end
      function gripperAction(controlObj,action)
          %gripperAction contols the robot's gripper. 
          % The action term is a string specifying whether to open or close
          % the gripper
          %INPUTS (obligatory)
          % 
          % controlObj--> the robotControl object
          % action --> srtng 'open' or 'close'
          switch action
              case 'open'
            
              pause(0.1)
              fprintf(controlObj.connection,'set_digital_out(1,False)');
               pause(0.1)
              fprintf(controlObj.connection,'set_digital_out(2,True)');
               pause(0.1)
            
              case 'close'
                 
              pause(0.1)
                  fprintf(controlObj.connection,'set_digital_out(1,True)');
                pause(0.1)
              fprintf(controlObj.connection,'set_digital_out(2,False)');
                pause(0.1)
           
                  
          end
      
      
      
      end
    end
    methods(Static,Access ='private')
        function setTCP(controlObj,tcpPose)
            %convert to meters
             tcpPose(1:3)=tcpPose(1:3)./1000;
             urScript='set_tcp(';
        
               
                commanndCell{1,1}=tcpPose;
             commandString=controlObj.createCommandString(commanndCell,urScript,controlObj);
           
              % Open connection and send command
           
              fprintf(controlObj.connection,commandString);
         
        end
        
        function setPayload(controlObj,payload)
             urScript='set_payload(';
        
               
                commanndCell{1,1}=payload;
             commandString=controlObj.createCommandString(commanndCell,urScript,controlObj);
           
              % Open connection and send command
             
              fprintf(controlObj.connection,commandString);
             
        end
        
        
         function activateGripper(controlObj)
             %Turns on the gripper connected to digital out 0;
             %Called at constructor
     
              % Open connection and send command
       
              fprintf(controlObj.connection,'set_digital_out(0,True)');
              pause(0.1);
              fprintf(controlObj.connection,'set_digital_out(1,False');
              pause(0.1);
              fprintf(controlObj.connection,'set_digital_out(2,False)');
            
             
         end
         function type=getPointType(point)
             % Determines if a movement point is a joint configuration or
             % pose
             
             if (point(1:3)<5)
                 type='joint';
             else
                 type='pose' ;            
             end
         end
         function commandString=createCommandString(functionInputs,urScript,controlObj)
             % Creates the string that has to be send via the connection
             % functionInputs A cell array contatining the inputs with the same order as given to the function 
             % pointType A string specifying the type of target points (joints or pose)
             % urScript   String specifying the URscript function
             commandCell{1,1}=urScript;
            for i=1:size(functionInputs,2)
              
                if size(functionInputs{1,i},2)==6
                    point=functionInputs{1,i};
                    % Check if it is a pose or joint config
                    pointType=controlObj.getPointType(point);
                        if strcmp(pointType,'pose')
                        commandCell{1,size(commandCell,2)+1}='p';
                        % Convert to meters
                        point(1:3)=point(1:3)./1000;
                        temp=sprintf('%s,',point(1,1:end-1));
                        commandCell{1,size(commandCell,2)+1}=strcat('[',temp,num2str(point(1,end)),']');
                        else
                        temp=sprintf('%s,',point(1,1:end-1));
                        commandCell{1,size(commandCell,2)+1}=strcat('[',temp,num2str(point(1,end)),']');
                        end
                    
                else
                    commandCell{1,size(commandCell,2)+1}=num2str(functionInputs{1,i});
                    
                end
                if i< size(functionInputs,2)
                commandCell{1,size(commandCell,2)+1}=',';
                end
            end
            commandCell{1,size(commandCell,2)+1}=')';
          
            commandString=strjoin(commandCell,'');
         end
      
        
    end
    
end

