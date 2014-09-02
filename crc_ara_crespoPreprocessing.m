function [SW, x, xf, y1] = crc_ara_crespoPreprocessing(ACTI, resolution)
%
% FORMAT [SW, x, xf, y1] = crc_ara_crespoPreprocessing(ACTI, resolution)
%
% Performs the 'Crespo' analysis.
%
% INPUT:
% - ACTI        : actigraphic time series
% - resolution  : temporal resolution
%
% OUTPUT:
% - SW  : Sleep/wake time series
% - x   : time series processed, ACTI or some processed ACTI 
% - xf  : filtered time series
% - y1  : sleep/wake time series before morphological operation
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

ara_def = crc_ara_get_defaults('crespo');
winAlpha = ara_def.winAlpha;
percentile = ara_def.percentile;
% z = ara_def.a;
% za = ara_def.za;
% zr = ara_def.zr;
% Lp = ara_def.Lp;
% Lw = ara_def.Lw;
% hs = ara_def.hs;

ASLEEP = crc_ara_get_defaults('acti.ASLEEP');
AWAKE = crc_ara_get_defaults('acti.AWAKE');

% Should be done for the true Crespo preprocessing but is useless due to our
% own "pre-preprocessing" done in individual.m

% %% Apply F{.}
% i = 1;
% a = [];
% while i <= length(ACTI)
%     consecZeroes = 0;
%     while i <= length(ACTI) && ACTI(i) == 0
%         consecZeroes = consecZeroes + 1;
%         i  = i + 1;
%     end;
%     
%     %If z consecutives minutes are equal to zero
%     if consecZeroes * (resolution / 60) >= z
%         a = [a, i-consecZeroes:i-1];
%     elseif consecZeroes == 0
%         i = i + 1;
%     end;
% end;
% 
% %% Compute x
% 
% st = prctile(ACTI, percentile); % 33% percentile
% x = zeros(1, length(ACTI));
% index = 1;
% 
% for i = 1:length(ACTI)
%     if index < length(a) && i == a(index) %If i is in a
%         x(i) = st;
%         index = index + 1;
%     else
%         x(i) = ACTI(i);
%     end;
% end;

x = ACTI;

%% x is padded

xp = zeros(1, length(x) + 2 * 30 * winAlpha * (60 / resolution)); %x padded
m = max(ACTI);
xp(1:30*winAlpha*(60/resolution)) = m;
xp(30*winAlpha*(60/resolution)+1:end-30*winAlpha*(60/resolution)) = x;
xp(end-30*winAlpha*(60/resolution)+1:end) = m;

%% x is filtered by a median operator

xf = zeros(1, length(ACTI));

Lw = 60 * winAlpha * (60 / resolution); %The median window has a length of 60 * alpha minutes
for i = 1:length(ACTI)
    medianWindow = xp(i:i+Lw);
    xf(i) = median(medianWindow);
end;

%% y1 is computed

p = prctile(xf, percentile);
y1 = zeros(1, length(xf));
for i = 1:length(xf)
    if xf(i) > p
        y1(i) = AWAKE;
    else
        y1(i) = ASLEEP;
    end;
end;


%% Opening - closing

%Lp = (60 + 1) * (60 / resolution); %Opening-closing by a window of 61 minutes
Lp = (180 + 1) * (60 / resolution);
morphWindow = linspace(AWAKE, AWAKE, Lp);
y = imopen(imclose(y1, morphWindow), morphWindow); %Wake and rest periods of less than 60 minutes are removed

SW = y;


end