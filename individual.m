function [stat_res] = individual(datafile, nbFiles, mode, displayPlot)
%
% FORMAT [stat_res] = individual(datafile, nbFiles, mode, displayPlot)
%
% Processes a series of actigraphy files and displaying the results.
% Possibly comparing each to some true scoring, provided in a separate .xls
% file in the same directory.
%
% INPUT
% - datafile    : list of files (array) to process
% - nbFiles     : #files to process
% - mode        : compare with reference scoring (2) or not (1, def.)
% - displayPlot : diplay result plor, or not.
%
% OUTPUT
% - stat_res : a structure containing the following information
%       errorRate
%       sensitivity
%       specificity
%       kappa
%       meanWakeError
%       stdWakeError
%       meanSleepError
%       stdSleepError
% 
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

nbSecPerDays = 24*60*60;
ara_def = crc_ara_get_defaults('mode');

for ifile = 1:nbFiles
    
    trueSW = [];
    trueSleepDate = [];
    trueWakeDate = [];
    
    %Get raw data from the file  
    file = deblank(datafile(ifile, :));
    [fileName, ACTI, nbDays, resolution, startTime, t] = getData(file); %#ok<*ASGLU>
    nbDataPerDays = nbSecPerDays / resolution;
    
    if mode == ara_def.INDIVIDUAL
        % Sometimes the signal begins "too early" with a lot of 0 values
        %  -> they are removed
        [ACTI, startTime, t] = preprocessing(ACTI, startTime, t, resolution);
    else
        %Retrieves the values from the manual scoring
        [trueSW, trueBedDate, trueUpDate, trueSleepDate, trueWakeDate] = getTrueValues(fileName, ACTI, startTime, nbDataPerDays);
        
        %Sometime, all the nights weren't scored manually, so they need
        %to be removed from ACTI and trueSW
        [ACTI, trueSW, startTime, t] = modifyLength(ACTI, trueSW, startTime, t, resolution);
    end;
    
    %Remove "long zeros" (actigraph removed by the subject)
    ACTI = removeZeros(ACTI);
    %Preprocessing stage
    [SW, x, xf, y1] = crespoPreprocessing(ACTI, resolution); %#ok<*NASGU>
    % plotSW(fileName, ACTI, SW, trueSW, resolution, t);
    % Processing stage
    [SW] = learning(ACTI, SW, resolution);
    
    
    [sleepDate, wakeDate] = getNights(SW, startTime, nbDataPerDays); %s
%     bedDate = getBedTime(ACTI, sleepDate, startTime, nbDataPerDays); %s
%     upDate = getUpTime(ACTI, wakeDate, startTime, nbDataPerDays); %s
%     assumedSleepDate = upDate - bedDate;
%     actualSleepDate = wakeDate - sleepDate;
%     actualSleep = actualSleepDate ./ assumedSleepDate;
%     actualWakeDate = assumedSleepDate - actualSleepDate;
%     actualWake = actualWakeDate ./ assumedSleepDate;
    
%     sleepDuration = getDuration(sleepDate, wakeDate);
    sleepDuration = 0;


    % saveData(fileName, sleepTime, wakeTime, bedTime, upTime, assumedSleepTime, actualSleepTime, actualSleep, actualWakeTime, actualWake, sleepDuration, meanDuration, stdDev);
    
    if displayPlot == true
        %Plots the data in a linear way
        plotSW(fileName, ACTI, SW, resolution, t, trueSW);
        %Plots the data on a circle
        plotCircle(SW, startTime, nbDataPerDays, trueSW);
    end;
    
    % Computes some stats
    [errorRate, sensitivity, specificity, kappa, meanWakeError, stdWakeError, meanSleepError, stdSleepError] = stats(SW, wakeDate, sleepDate, sleepDuration, trueSW, trueWakeDate, trueSleepDate, displayPlot);
        
    stat_res = struct( ...
        'errorRate',      errorRate, ...
        'sensitivity',    sensitivity, ...
        'specificity',    specificity, ...
        'kappa',          kappa, ...
        'meanWakeError',  meanWakeError, ...
        'stdWakeError',   stdWakeError, ...
        'meanSleepError', meanSleepError, ...
        'stdSleepError',  stdSleepError ...
        );
    % saveas(gcf, '~/sleep', 'png');
    % saveXLS(wakeDate, sleepDate);
    
end;

end