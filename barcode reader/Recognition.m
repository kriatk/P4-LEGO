function [Code, Conf] = Recognition(Center, Width, ...
    Sequence, NumSeq, LGCode, LCode, GCode, RCode, ...
    LCodeRev, GCodeRev, RCodeRev) 
% Function RECOGNITION recognizes the barcode.

% Parameters
UPSAMPLE_RATE = int32(16);

% Constant values
% MID_MODULE is the distance between the first '101' pattern and the middle
% '101' pattern.
MID_MODULE  = int32(46); 
% LAST_MODULE is the distance between the first '101' pattern and the last
% '101' pattern.
LAST_MODULE = int32(92);
% numBinInSym is the number of bins in a symbol
numBinInSym = int32(7 * UPSAMPLE_RATE);

numScanline = numel(NumSeq);
maxNumBar = size(Center, 1);
mapCenter = single(zeros(1, maxNumBar));
mapWidth = single(zeros(1, maxNumBar));
barBin = zeros([1, LAST_MODULE*UPSAMPLE_RATE], 'int32');
    
% Recognize the strings
bestConf = int32(0);
bestCode = zeros([13, 1], 'int32');
codeAll = zeros([13, 1], 'int32');

Center = Center / single(LAST_MODULE);
Width = Width / single(LAST_MODULE);
expCenter = single([0; MID_MODULE; LAST_MODULE]);

for iScanline = 1: numScanline
    for iSequence = 0: NumSeq(iScanline)-1
        dataMx = zeros([3, 3], 'single');
        for iSep = 1: 3
            iBar = Sequence(3*iSequence+iSep, iScanline);
            %loc = mean(bar(1, startBar: startBar+2));
            avgCenter = (Center(iBar, iScanline) ...
                + Center(iBar+1, iScanline) ...
                + Center(iBar+2, iScanline)) / single(3);
            dataMx(iSep, :) = [avgCenter^2, avgCenter, 1];
        end

        coeff = inv(dataMx) * expCenter;

        for iBar = Sequence(3*iSequence+1, iScanline) + 3 ...
                 : Sequence(3*iSequence+3, iScanline) - 1
            mapCenter(iBar) = coeff' * ...
                [Center(iBar, iScanline)^2; Center(iBar, iScanline); 1];
            mapWidth(iBar)  = coeff(1:2)' ...
                * [2*Width(iBar, iScanline); 1] * Width(iBar, iScanline);
        end

        val = int32(-1);
        for iBar = Sequence(3*iSequence+1, iScanline) + 3 ...
                 : Sequence(3*iSequence+3, iScanline) - 1
            left = (mapCenter(iBar) - mapWidth(iBar) / 2) ...
                   * single(UPSAMPLE_RATE);
            right = left + mapWidth(iBar) * single(UPSAMPLE_RATE);
            left = max(left, 1);
            right = min(right, single(LAST_MODULE*UPSAMPLE_RATE));
            for idx = round(left): round(right)
                barBin(idx) = val;
            end
            val = -val;
        end

        leftBin = int32(round(1.5 * UPSAMPLE_RATE));
        rightBin = int32(round(48.5 * UPSAMPLE_RATE));
        
        % Assuming left to right scanline order, recognize digits
        % 8 to 13.
        [rcodeFwd, rconfFwd] = RecognizeHalfCode(RCode, barBin, ...
            rightBin, numBinInSym, false);

        % Assuming right to left scanline order, recognize digits
        % 8 to 13.
        [rcodeRev, rconfRev] = RecognizeHalfCode(RCodeRev, ...
            barBin, leftBin, numBinInSym, true);
        
        % Use the scanline direction (left to right or right to left),
        % find out the potential match for digits 2 to 7.
        if sum(rconfFwd) > sum(rconfRev)
            [lcodeRec, lconfRec] = RecognizeHalfCode(LCode, barBin, ...
                leftBin, numBinInSym, false);
            [gcodeRec, gconfRec] = RecognizeHalfCode(GCode, barBin, ...
                leftBin, numBinInSym, false);
            codeAll(8:13) = rcodeFwd;
            confAll = int32(sum(rconfFwd));
        else
            [lcodeRec, lconfRec] = RecognizeHalfCode(LCodeRev, barBin, ...
                rightBin, numBinInSym, true);
            [gcodeRec, gconfRec] = RecognizeHalfCode(GCodeRev, barBin, ...
                rightBin, numBinInSym, true);
            codeAll(8:13) = rcodeRev;
            confAll = int32(sum(rconfRev));
        end
        
        % Recognize digits 1 to 7.
        [codeLeft, confLeft] = RecognizeFirstHalfCode(LGCode, ...
            lcodeRec, lconfRec, gcodeRec, gconfRec);
        codeAll(1:7) = codeLeft;
        confAll = confAll + confLeft(1);

        if bestConf < confAll
            bestCode = codeAll;
            bestConf = confAll;
        end
    end
end

% Normalize the confidence to [0 1].
Conf = single(bestConf) / single(12*7*UPSAMPLE_RATE);
Code = bestCode;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recognize the first 7 digits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [code, conf] = ...
    RecognizeFirstHalfCode(LGCode, lcode, lconf, gcode, gconf)
codeComb = [lcode, gcode];
confComb = [lconf, gconf];
code = zeros([7, 1], 'int32');
conf = zeros([7, 1], 'int32');

bestCode = 1;
bestSum = sum(confComb(LGCode(bestCode, :)));
for idx = 2: 10
    curSum = sum(confComb(LGCode(idx, :)));
    if bestSum < curSum
        bestCode = idx;
        bestSum = curSum;
    end
end

code(1) = bestCode - int32(1);
conf(1) = bestSum;
code(2:7) = codeComb(LGCode(bestCode, :));
conf(2:7) = confComb(LGCode(bestCode, :));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recognize half of the barcode by comparing them with a codebook
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [code, conf] = RecognizeHalfCode(codebook, barBin, ...
    firstBin, numBinInSym, isReverse)
code = zeros([6, 1], 'int32');
conf = zeros([6, 1], 'int32');

iSym = 1;
step = 1;
if isReverse
    iSym = 6;
    step = -1;
end

startBin = firstBin;
for idx = 1: 6
    bestCode = int32(0);
    bestSum = -2*numBinInSym;
    for iCode = int32(1): int32(10)
        sum = int32(0);
        for jdx = 1: numBinInSym
            sum = sum + barBin(startBin+jdx-1) * codebook(iCode, jdx);
        end
        
        if bestSum < sum
            bestSum = sum;
            bestCode = iCode;
        end
    end
    code(iSym) = bestCode - int32(1);
    conf(iSym) = bestSum;
    iSym = iSym + step;
    startBin = startBin + numBinInSym;
end
end
