% This function mxNiPhoto, takes the Current-Photo (movie) frame from 
%   the Kinect-Stream, and makes it available as matlab variable
%
% 	I = mxNiPhoto(KinectHandles);
%
% inputs,
%   KinectHandles : Array with pointers to kinect node objects generated by
%          mxNiCreateContext, such as main, image, IR, Depth and User node.
%
% outputs,
%   I : A matrix of type Uint8 with sizes [sizex sizey 3] with the 
%       current RGB photo of the camera stream
%
% note,
%	To go the next movie-frame use mxNiUpdateContext(KinectHandles)
%
%
% See also mxNiCreateContext, mxNiUpdateContext, mxNiDepth, 
%		mxNiInfrared, mxNiSkeleton, mxNiDeleteContext
%
% Mex-Wrapper is written by D.Kroon Focal 2.0 (June 2013)  

