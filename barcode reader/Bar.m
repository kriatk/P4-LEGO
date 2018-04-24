function [Center, Width, Num] = Bar(F)
% Function BAR detects bars from barcode feature signal.

MAX_BAR_NUM = 200;
[numFeature, lenFeature] = size(F);
Center = zeros([MAX_BAR_NUM, numFeature], 'single');
Width = zeros([MAX_BAR_NUM, numFeature], 'single');
Num = zeros([1, numFeature], 'int32');

for iFeature = 1: numFeature
    iBar = 0;
    iPix = 1;
    
    % First, try to find a black bar.
    % If it is not there, the first bar has zero width.
    while iPix <= lenFeature && iBar < MAX_BAR_NUM
        % Find a black bar.
        % A contiguous sequence of pixels with zero or positive feature
        % value is considered a black bar.
        curWidth  = zeros(1, 'single');
        curCenter = zeros(1, 'single');
        while iPix <= lenFeature && F(iFeature, iPix) >= 0
            curWidth  = curWidth + F(iFeature, iPix);
            curCenter = curCenter + F(iFeature, iPix) * iPix;
            iPix = iPix + 1;
        end

        iBar = iBar + 1;
        if curWidth > 0
            Center(iBar, iFeature) = curCenter / curWidth;
            Width(iBar, iFeature) = curWidth;
        end

        % Find a white bar.
        % A contiguous sequence of pixels with negative feature
        % value is considered a white bar.
        curWidth  = zeros(1, 'single');
        curCenter = zeros(1, 'single');
        while iPix <= lenFeature && F(iFeature, iPix) < 0
            curWidth  = curWidth + F(iFeature, iPix);
            curCenter = curCenter + F(iFeature, iPix) * iPix;
            iPix = iPix + 1;
        end

        if curWidth < 0 && iBar < MAX_BAR_NUM
            iBar = iBar + 1;
            Center(iBar, iFeature) = curCenter / curWidth;
            Width(iBar, iFeature) = -curWidth;
        end
    end
    Num(1, iFeature) = iBar;
end
