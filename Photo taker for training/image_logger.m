obj = videoinput('winvideo', 2, 'MJPG_640x480'); 
set(obj,'ReturnedColorSpace','rgb');

src_obj = getselectedsource(obj); 
src_obj.Exposure = -9;

counter = 0;

while(1)
    img = getsnapshot(obj);
    imagesc(img);
    
    imwrite(img,(sprintf('Yellow_%d',counter');
    counter = counter + 1;
    pause(5);
end