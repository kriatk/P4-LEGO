obj = videoinput('winvideo', 1, 'MJPG_1280x720');
set(obj,'ReturnedColorSpace','rgb');
preview(obj);