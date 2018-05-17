obj = videoinput('winvideo', 3, 'MJPG_640x480'); 
set(obj,'ReturnedColorSpace','rgb');

src_obj = getselectedsource(obj); 
src_obj.Exposure = -3;
src_obj.Contrast = 15;
src_obj.Brightness = 10;
src_obj.ExposureMode = 'manual';
src_obj.BacklightCompensation = 'off';
src_obj.Sharpness = 100;
src_obj.Saturation = 50;
%%
for i=15:25
    img = getsnapshot(obj);sound(100);
     imagesc(img);
    i = i+1;
     imwrite(img,sprintf('%d.jpg',i))
    
    pause(4);
    
end