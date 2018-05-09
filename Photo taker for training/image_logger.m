obj = videoinput('winvideo', 2, 'MJPG_1024x768'); 
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
for i=1:100
    img = getsnapshot(obj);
    imagesc(img);
    
    imwrite(img,sprintf('%d.jpg',i))
    pause(0.5);
end