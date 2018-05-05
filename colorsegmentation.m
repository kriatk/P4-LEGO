load('Lots_ofBlocks.mat','cam_image_cropped');
I=cam_image_cropped;
% I = imread('black_separated_light.png');
% I = imread('lego_own.jpg'); 
I=imresize(I,3);
imshow(I);


% Idea:
% -feed real colors of blocks and create classes
% - use gaussian to compare each pixel within a blob to the classes#
% - if blobs have two very different colors within, there must be 2 blobs
