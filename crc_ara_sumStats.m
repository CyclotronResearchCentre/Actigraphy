function [stat_res] = crc_ara_sumStats(wakeDate, sleepDate, sleepDuration)
%
% Estimate and display some summary statistics about the analyzed
% actigraphy data.
% 
% INPUT
%
% OUTPUT
% stat_res : structure with the following fields
%  . meanWakeTime      \
%  . medianWakeTime    -- mean/median/std Wake time
%  . stdWakeTime       /
%  . meanSleepTime     \
%  . medianSleepTime   -- mean/median/std Sleep time
%  . stdSleepTime      /
%  . meanDuration      \
%  . medianDuration    -- mean/median/std Sleep duration
%  . stdDuration       /
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

% constantes;
strline = '--------------------------';

wakeTime = mod(wakeDate, 1); %Get the time out of the date
sleepTime = mod(sleepDate, 1);

sleepTime(sleepTime>0.5) = sleepTime(sleepTime>0.5) - 1;

meanWakeTime = mean(wakeTime);
medianWakeTime = median(wakeTime);
stdWakeTime = std(wakeTime);
meanSleepTime = mean(sleepTime);
medianSleepTime = median(sleepTime);
stdSleepTime = std(sleepTime);
meanDuration = mean(sleepDuration);
medianDuration = median(sleepDuration);
stdDuration = std(sleepDuration);

meanWakeTimeStr = datestr(meanWakeTime, 'HH:MM');
medianWakeTimeStr = datestr(medianWakeTime, 'HH:MM');
stdWakeTimeStr = datestr(stdWakeTime, 'HH:MM');
meanSleepTimeStr = datestr(meanSleepTime, 'HH:MM');
medianSleepTimeStr = datestr(medianSleepTime, 'HH:MM');
stdSleepTimeStr = datestr(stdSleepTime, 'HH:MM');

% Display, mean, median, std
fprintf('%s \n', strline);
fprintf('Wake Time  : median %s, mean %s, std %s \n', ...
    medianWakeTimeStr,meanWakeTimeStr,stdWakeTimeStr);
fprintf('Sleep Time : median %s, mean %s, std %s \n', ...
    medianSleepTimeStr,meanSleepTimeStr,stdSleepTimeStr);
fprintf('%s \n', strline);
% Display estimated times
wakeTimeStr = datestr(wakeTime, 'HH:MM');
sleepTimeStr = datestr(sleepTime, 'HH:MM');
for ii=1:numel(sleepTime)
    fprintf('\tDay #%2d : %s - %s\n',ii,sleepTimeStr(ii,:),wakeTimeStr(ii,:))
end
fprintf('%s \n \n', strline);

stat_res = struct( ...
    'meanWakeTime', meanWakeTime, ...
    'medianWakeTime', medianWakeTime, ...
    'stdWakeTime', stdWakeTime, ...
    'meanSleepTime', meanSleepTime, ...
    'medianSleepTime', medianSleepTime, ...
    'stdSleepTime', stdSleepTime, ...
    'meanDuration', meanDuration, ...
    'medianDuration', medianDuration, ...
    'stdDuration', stdDuration);

end