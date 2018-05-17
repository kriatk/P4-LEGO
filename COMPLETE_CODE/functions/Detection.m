function [Sequence, Num] = Detection(Width, NumBar, WidthVar)
% DETECTION returns sequence of indices to barcode guard bars

% Parameters
WIDTH_VAR_DETECT = WidthVar;
BAR_VAR_NUM = 1;

% Maximum signal dimensions
MAX_SEP_NUM = 50; % max number of guard patterns (separators)
MAX_SEQ_NUM = 30; % max number of sequences of guard patterns

% Constant values
BAR_END2END_NUM = 56; % count of both black and white bars
BAR_END2MID_NUM = 28;

numScanline = numel(NumBar);
separator = zeros([1, MAX_SEP_NUM], 'int32');
Sequence = zeros([3*MAX_SEQ_NUM, numScanline], 'int32');
Num = zeros([1, numScanline], 'int32');

for iScanline = 1: numScanline
    % Calculate sequence and its length
    firstBar = 1;
    % Skip the first bar if it's invalid
    if Width(firstBar) == 0
        firstBar = firstBar + 2;
    end

    % Find out all possible separators
    numSep = 0;
    while firstBar <= NumBar(iScanline)-2
        [avgWidth, devWidth] = Statistics(Width, iScanline, firstBar, 3);
        if numSep < MAX_SEP_NUM && devWidth < WIDTH_VAR_DETECT; % * dis_mean
            numSep = numSep + 1;
            separator(numSep) = firstBar;
        end
        firstBar = firstBar + 2;
    end

    % Find out sequences of bars that may form a valid barcode string
    iSequence = 0;
    iStart = 1;
    lastStartSep = NumBar(iScanline) - BAR_END2END_NUM + 2 * BAR_VAR_NUM;
    while iSequence < MAX_SEQ_NUM ...
            && iStart <= numSep-2 && separator(iStart) <= lastStartSep
        firstMidSep = separator(iStart) + BAR_END2MID_NUM - 2 * BAR_VAR_NUM;
        lastMidSep  = firstMidSep + 4 * BAR_VAR_NUM;
        firstEndSep = separator(iStart) + BAR_END2END_NUM - 2 * BAR_VAR_NUM;
        lastEndSep  = firstEndSep + 4 * BAR_VAR_NUM;
        
        % Skip the first part
        iMid = iStart + 1;
        while iMid <= numSep-1 && separator(iMid) < firstMidSep
            iMid = iMid + 1;
        end

        while iSequence < MAX_SEQ_NUM ...
                && iMid <= numSep-1 && separator(iMid) <= lastMidSep
            % Skip the first part
            iEnd = iMid + 1;
            while iEnd <= numSep && separator(iEnd) < firstEndSep
                iEnd = iEnd + 1;
            end

            while iSequence < MAX_SEQ_NUM ...
                    && iEnd <= numSep && separator(iEnd) <= lastEndSep
                avgWidth = zeros(1, 'single');
                for iBar = separator(iStart): separator(iStart)+2
                    avgWidth = avgWidth + Width(iBar, iScanline);
                end
                for iBar = separator(iEnd): separator(iEnd)+2
                    avgWidth = avgWidth + Width(iBar, iScanline);
                end
                avgWidth = avgWidth / single(6);

                devWidth = zeros(1, 'single');
                for iBar = separator(iMid)-1: separator(iMid)+3
                    difWidth = abs(Width(iBar, iScanline) - avgWidth);
                    if devWidth < difWidth
                        devWidth = difWidth;
                    end
                end

                if devWidth < WIDTH_VAR_DETECT; % * dis_mean_exp
                    Sequence(3*iSequence+1, iScanline) = separator(iStart);
                    Sequence(3*iSequence+2, iScanline) = separator(iMid);
                    Sequence(3*iSequence+3, iScanline) = separator(iEnd);
                    iSequence = iSequence + 1;
                end
                iEnd = iEnd + 1;
            end
            iMid = iMid + 1;
        end

        iStart = iStart + 1;
    end
    Num(iScanline) = iSequence;
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the average and deviation of the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [avg, dev] = Statistics(data, col, first, Num)
avg = zeros(1, 'single');
for idx = first: first+Num-1
    avg = avg + data(idx, col);
end
avg = avg / Num;

dev = zeros(1, 'single');
for idx = first : first+Num-1
    dif = abs(data(idx, col) - avg);
    if dev < dif
        dev = dif;
    end
end
end