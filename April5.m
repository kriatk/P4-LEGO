close all;
clear all;
addpath('Mex')

KinectHandles=mxNiCreateContext();

figure;
cam_image=mxNiPhoto(KinectHandles); 
cam_image=permute(cam_image,[3 2 1]);
subplot(1,2,1), h1=imshow(cam_image);


for i=1:1000
    cam_image=mxNiPhoto(KinectHandles);cam_image=permute(cam_image,[3 2 1]);
    gray=rgb2gray(cam_image);
    diff=imsubtract(cam_image(:,:,1), gray);
    diff=medfilt2(diff,[3 3]);
    diff=im2bw(diff,graythresh(diff));
    diff=bwareaopen(diff, 300);
    
    bw=bwlabel(diff);
    
    stats=regionprops(bw,'BoundingBox', 'Centroid');
    subplot(1,2,2), h2=imshow(diff);

    hold on
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    
    hold off
    
    set(h1,'CDATA',cam_image);
    
    drawnow; 
   
end

mxNiDeleteContext(KinectHandles);