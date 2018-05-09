function binarymap = histogram_binarymap(I, thresholdValue)

Igray=rgb2gray(I);
captionFontSize = 14;
% Igray=rgb2gray(rgb2ycbcr(I));
[pixelCount, grayLevels] = imhist(Igray);

subplot(2, 1, 1);
bar(pixelCount);
title('Histogram of original image', 'FontSize', captionFontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

% thresholdValue = 73;
% thresholdValue = 62.5;

binaryHist = Igray > thresholdValue; % Bright objects will be chosen if you use >.

% Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
binarymap = imfill(binaryHist, 'holes');

% edge_corr= zeros(size(binaryHist));
% for row=2:1:size(binaryHist,1)-1
%     for col=2:1:size(binaryHist,2)-1
%         if sum(sum(binaryHist(row-1:row+1,col-1:col+1))) ~=9 && binaryHist(row,col) == 1
%             edge_corr(row,col)=1;
% %             binaryHist(row,col)=0;
%                
%         end
%         
%     end
% end
% 
% binaryHist=not(edge_corr) & binaryHist;

hold on;
maxYValue = ylim;
line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% Place a text label on the bar chart showing the threshold.
annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
% For text(), the x and y need to be of the data class "double" so let's cast both to double.
text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);

hold off;


subplot(2, 1, 2);
imshow(binaryHist)


end