function [errorRate, sensitivity, specificity, kappa, meanWakeError, stdWakeError, meanSleepError, stdSleepError] = individual(datafile, nbFiles, mode, displayPlot)

constantes;

for ifile = 1:nbFiles
    
    trueSW = [];
    trueBedDate = [];
    trueUpDate = [];
    trueSleepDate = [];
    trueWakeDate = [];
    
    %Get raw data from the file  
    file = datafile(ifile, :);
    [fileName ACTI nbDays resolution startTime t] = getData(file);
    nbDataPerDays = nbSecPerDays / resolution;
    
    if mode == INDIVIDUAL
        %Sometimes the signal begins "too early" with a lot of 0 values -> they
        %are removed
        [ACTI startTime t] = preprocessing(ACTI, startTime, t, resolution);
    else
        %Retrieves the values from the manual scoring
        [trueSW trueBedDate trueUpDate trueSleepDate trueWakeDate] = getTrueValues(fileName, ACTI, startTime, nbDataPerDays);
        
        %Sometime, all the nights weren't scored manually, so they need
        %to be removed from ACTI and trueSW
        [ACTI trueSW startTime t] = modifyLength(ACTI, trueSW, startTime, t, resolution);
    end;
    
    %Remove "long zeros" (actigraph removed by the subject)
    ACTI = removeZeros(ACTI);
    %Preprocessing stage
    [SW x xf y1] = crespoPreprocessing(ACTI, resolution);
    %plotSW(fileName, ACTI, SW, trueSW, resolution, t);
    %Processing stage
    [SW] = learning(ACTI, SW, resolution);
    
    
    [sleepDate wakeDate] = getNights(SW, startTime, nbDataPerDays); %s
%     bedDate = getBedTime(ACTI, sleepDate, startTime, nbDataPerDays); %s
%     upDate = getUpTime(ACTI, wakeDate, startTime, nbDataPerDays); %s
%     assumedSleepDate = upDate - bedDate;
%     actualSleepDate = wakeDate - sleepDate;
%     actualSleep = actualSleepDate ./ assumedSleepDate;
%     actualWakeDate = assumedSleepDate - actualSleepDate;
%     actualWake = actualWakeDate ./ assumedSleepDate;
    
%     sleepDuration = getDuration(sleepDate, wakeDate);
sleepDuration = 0;


    %saveData(fileName, sleepTime, wakeTime, bedTime, upTime, assumedSleepTime, actualSleepTime, actualSleep, actualWakeTime, actualWake, sleepDuration, meanDuration, stdDev);
    
    if displayPlot == true
        %Plots the data in a linear way
        plotSW(fileName, ACTI, SW, trueSW, resolution, t);
        %Plots the data on a circle
        plotCircle(SW, trueSW, startTime, nbDataPerDays);
    end;
    
    %Computes some stats
    [errorRate sensitivity specificity kappa meanWakeError stdWakeError meanSleepError stdSleepError] = stats(SW, wakeDate, sleepDate, sleepDuration, trueSW, trueWakeDate, trueSleepDate, displayPlot);
        
    
    %saveas(gcf, '~/sleep', 'png');
    %saveXLS(wakeDate, sleepDate);
    
end;

end