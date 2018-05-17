function [R, F] = Feature(I, Row)
% This function transforms pixels in a given row into a feature vector.

RATIO_STD = single(0.4); % Parameter

% h is a Gaussian filter. It is used to smooth the image gradient which
% indentifies barcode region.
h = single([0.022191, 0.045589, 0.079811, 0.119065, 0.151361, 0.163967, ...
            0.151361, 0.119065, 0.079811, 0.045589, 0.022191]);

% Make sure all scanlines are in valid range.
R = Row;
numRow = size(I, 1);
for idx = 1: numel(R)
    if R(idx) < 1
        R(idx) = 1;
    elseif R(idx) >= numRow
        R(idx) = numRow;
    end
end

F = single(I(R, :));
len = numel(F);

% gradient of the scanlines
gradient = zeros(size(F), 'single');
gradient(2:end-1) = abs(F(3:end) - F(1:end-2));
gradient = conv2(gradient, h, 'same');

% mask consists of most pixels in the barcode region.
mask = (gradient > mean(mean(gradient)));
numPix = single(sum(sum(mask)));
f_mean = single(sum(sum(F .* mask))) / numPix;

% Calculate the mean value and standard deviation for the pixels in the 
% barcode region.
f_std = zeros(1, 'single');
for idx = 1: len
    if mask(idx)
        dif = F(idx) - f_mean;
        f_std = f_std + dif * dif;
    end
end
f_std = sqrt(f_std / numPix);

% Estimate the range of pixel intensity values in the barcode region.
% Values larger than f_high and values smaller than f_low will be saturated.
f_high = f_mean + f_std * RATIO_STD;
f_low  = f_mean - f_std * RATIO_STD;

% Calculate the feature for all pixels in the scanlines. A pixel is 
% classified as black if its value is f_low or less. Black pixels are set
% to 1. A pixel is classified as white if its value is f_high or larger.
% White pixels are set to -1. The remaining pixels are proportionally set 
% to values between -1 and 1.
scale = single(2) / (f_high - f_low);
for iPix = 1: len
    if F(iPix) > f_low && F(iPix) < f_high
        F(iPix) = (f_high - F(iPix)) * scale - single(1);
    elseif F(iPix) <= f_low
        F(iPix) = single(1);
    else
        F(iPix) = single(-1);
    end
end

% Conver the coordinates of from 1-based to 0-based.
R = R - 1;
