close all; clear all; clc;

%Create video object and set parameters
obj = videoinput('winvideo', 1, 'MJPG_320x240'); 
obj.TriggerRepeat = Inf;
obj.FrameGrabInterval = 4;
set(obj,'ReturnedColorSpace','rgb');

%Create video source object specific to the camera
src_obj = getselectedsource(obj); 
src_obj.Exposure = -9;
src_obj.Zoom = 1;

%Read video paraemters and setup according to the resolution
get(src_obj); 
vidRes = get(obj, 'VideoResolution'); 
nBands = get(obj, 'NumberOfBands'); 
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );  
FinalCode1=0;

figure;
start(obj);

while (FinalCode1==0)
    %Read camera and show feed
    ip_im = getdata(obj,1);
    imshow(ip_im);
    drawnow
    
      %filter
      fi_im=imsharpen(ip_im);
      % Convert from RGB to Gray
      gray_im= rgb2gray(fi_im);
      %Threshold Image to black and white
      J = im2bw(gray_im, graythresh(gray_im));
      %Resize and process
      J=imresize(J,[240 320]);
      %Scanlines
      Row = [80 120 160]';
      %Transforms pixels in given rows into a feature vector.
      [R,F] = Feature(J, Row);
      %BAR detects bars from barcode feature signal.
      [Center, Width, Num] = Bar(F);
      %DETECTION returns sequence of indices to barcode guard bars
      [Sequence, Num] = Detection(Width, Num, 2);
      %CODEBOOK generats the look-up table for GTIN-13.
      [LGCode, LCode, GCode, RCode, LCodeRev, GCodeRev, RCodeRev] = Codebook;
      %Decode the barcode
      [Code, Conf] = Recognition(Center, Width, Sequence, Num, LGCode, LCode, GCode, RCode, LCodeRev, GCodeRev, RCodeRev);
      %Validation
      OddSum= Code(1:1)+Code(3:3)+Code(5:5)+Code(7:7)+Code(9:9)+Code(11:11)+Code(13:13);
      EvenSum = Code(2:2)+Code(4:4)+Code(6:6)+Code(8:8)+Code(10:10)+Code(12:12);
      Checksums = OddSum + 3*EvenSum;
      Valid = and((not(mod(Checksums,10))),(Conf >= 0.7));
      FinalCode=uint64(0);
      
      for i = 1 :13
          FinalCode=FinalCode*10 + uint64(Code(i:i));
      end
      if and(Valid ,(FinalCode ~= FinalCode1))
          Code'
          sprintf('%013i',FinalCode)
          FinalCode1 = FinalCode';
      end
end
%Need to close the feed
stop(obj)
