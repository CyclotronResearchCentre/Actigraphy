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
%
% Reference:
% Crespo, C.; Aboy, M.; Fernández, J. R. & Mojón,
% A. Automatic identification of activity-rest periods based on actigraphy 
% Med. Biol. Engineering and Computing, 2012, 50, 329-340
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

ASLEEP = crc_ara_get_defaults('sw.ASLEEP');
AWAKE = crc_ara_get_defaults('sw.AWAKE');

% Should be done for the true Crespo preprocessing but is useless due to 
% our own "pre-preprocessing" done in crc_ara_processIndiv.m

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
Lw30 = round(30 * winAlpha * (60 / resolution));
xp = zeros(1, length(x) + 2 * Lw30); %x padded
m = max(ACTI);
xp(1:Lw30) = m;
xp(Lw30+1:end-Lw30) = x;
xp(end-Lw30+1:end) = m;

%% (padded) x is filtered by a median operator

xf = zeros(1, length(ACTI));

Lw = -Lw30:Lw30;
for ii = 1:numel(x)
    medWin = xp(ii+Lw30+Lw);
    xf(ii) = median(medWin);
end

%% y1 is computed

p = crc_percentile(xf, percentile);
y1 = zeros(1, length(xf));
y1(xf>p) = AWAKE;
y1(xf<=p) = ASLEEP;

%% Opening - closing
% Lp = (60 + 1) * (60 / resolution); % Opening-closing by a window of 61 minutes
Lp = (180 + 1) * (60 / resolution); % Opening-closing by a window of 181 minutes
morphWindow = linspace(AWAKE, AWAKE, Lp);
y = imopen(imclose(y1, morphWindow), morphWindow); % Wake and rest periods of less than 60 minutes are removed

SW = y;


end