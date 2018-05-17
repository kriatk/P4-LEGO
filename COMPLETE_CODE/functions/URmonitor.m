classdef URmonitor 
    %   A class for monitoring the state of UR robot
    %   URmonitor provides functions for receiving information about joint
    %   state, gripper pose and robot state . The monitoring is executed using
    %   the RealTime Interface of UR at port 30003
    
     properties
         monitorConnection   % The tcpip object includes properties of the connection         
     end
    
    
    properties (GetAccess='protected')
        
        receivedPacket
        robotStatus
       
        
    end
    
    methods 
        function obj=URmonitor(ipAdress)
        % The constructor initializes the robot's monitor object
        % INPUTS  
        % Name      Type          Description
        %---------------------------------------------------------------
        % ipAdress  string        The ipAdress of the robot. Can be found
        %                         from the teaching pendant
        %
        %% Set connection properties
        obj.monitorConnection = tcpip(ipAdress,30003,'InputBufferSize',1044,'ByteOrder','littleEndian');
        
        %% Check if the connection works
        
        % close connection in case that it as left open
        if strcmp( obj.monitorConnection.Status,'open')
             fclose(connection);
        end
        %% Open connection and check for incoming packets
        fopen( obj.monitorConnection);
        pause(0.3)
        obj.receivedPacket = uint8(fread( obj.monitorConnection)'); %% Read packet's header
        fclose( obj.monitorConnection);
        if isempty(obj.receivedPacket)
            error('The received packet is empty. Check IP adress and connection')
        end
         
         
         stateValue=obj.getRobotInfo(obj,'robotStatus');
         
         %% Check if the robot is ready for programming
         if (stateValue~=7)
              error('Robot is not ready for programming. Check that it is activated ')
         end
         
        end
       
    end
    methods (Static)        
        function value=getRobotInfo(obj,property)
        % Returns the joint state in radians
        % property is a string eg
        %'jointState' the state of the joints in rads
        %'gripperPose', the pose of end-effector (melimeters & rad)
        %'robotStatus'  the status of the robot
        
        value=obj.readPacket(obj,property);
        
            if (strcmp(property,'gripperPose'))
            value(1,1:3)=value(1,1:3).*1000; %% Convert to mm 
            end
        end
        function closeConnections(monitorObj,controlObj)
            fclose(monitorObj.monitorConnection);
            fclose(controlObj.connection);
        end
        function waitForExecution(obj)
        % Pause Matlab until the execution of a movement is performed
        %  NOT RELIABLE
        currentConf = obj.getRobotInfo(obj,'jointState');
        targetConf  = obj.getRobotInfo(obj,'targetConf');
       
        while (sum(abs(currentConf-targetConf)> 0.01)>=1)
            
        currentConf = obj.getRobotInfo(obj,'jointState');
        targetConf  = obj.getRobotInfo(obj,'targetConf');
        end
    end
    end
    
    methods (Static,Access ='private')
        function value=readPacket(obj,robotProperty)
        % Reads the received packet and returns the requested state of
        % the robot
        %
        % INPUTS  
        % Name            Type          Description
        %---------------------------------------------------------------
        % obj   robotMonitor object    object of the class
        %
        % robotProperty   string       Specifies the requested property of
        %                              the robot e.g. 'jointState','gripperPose'
        %                              'gripperStatus','robotStatus'
         
        %% Open connection and check for incoming packets
       fopen( obj.monitorConnection);
        pause(0.3)
        obj.receivedPacket = uint8(fread(obj.monitorConnection)'); %% Read packet
        fclose( obj.monitorConnection);
       
        if isempty(obj.receivedPacket)
            error('The received packet is empty. Check IP adress and connection')
        end
        
        %% TODO Check if packet is corrupted for all versions of Polyscope
        %%packetSize=obj.unpackBinaryData( obj.receivedPacket,4,1,'uint32');
        %%if (packetSize~=obj.monitorConnection.InputBufferSize)
        %%    error('Received packet is corupted')   
        %% end
        
        %% Unpack the data
        switch robotProperty
            
            case 'jointState'
                  firstByteLocation=253;
                  byteSize=48;
                  dataFormat='double';
                  
            case 'gripperPose'
                  firstByteLocation=445;
                  byteSize=48;
                  dataFormat='double';
                
            case 'robotStatus'
                firstByteLocation=757;
                  byteSize=8;
                  dataFormat='double';
                  
            case 'targetConf'
                firstByteLocation=13;
                  byteSize=48;
                  dataFormat='double';
            otherwise 
                error('Unknown robot property')
              
        end
        value=obj.unpackBinaryData( obj.receivedPacket ,byteSize,firstByteLocation,dataFormat);
        end
             
        function unpackedValues=unpackBinaryData(data,byteSize,firstByteLocation,dataFormat)
        % Unpacks the Bnary data
        %
        unFormated =data(1,firstByteLocation:firstByteLocation+byteSize-1);
         unpackedValues=typecast(fliplr(unFormated),dataFormat);
         unpackedValues=fliplr(unpackedValues);
        
        end
    
    
    end
end


