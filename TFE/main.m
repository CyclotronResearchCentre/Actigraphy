function [] = main(option)

constantes

if ~nargin
    option = spm_input('Action : ',1,'m','Individual|Group',[1,2],0); %Individual : option = 1, Group : option = 2
end;

close all;

origdir = '/home/miguel/Cours/TFE/';
datadir = fullfile(origdir, 'Actigraphy_TMS');


switch(option)
    case 1
        %Select the files to be analysed
        datafile = spm_select(Inf, '.+\.AWD$', 'Select files ...', [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
        if(isempty(datafile))
            nbFiles = 0;
        else
            nbFiles = size(datafile, 1);
        end;
        
        
        for ifile = 1:nbFiles
            
            %Get raw data from thefile 
            [fileName ACTI nbDays sleepToWake wakeToSleep resolution startTime t] = getData(datafile, ifile);
            nbDataPerDays = nbSecPerDays / resolution;
            [trueSW trueBedDate trueUpDate trueSleepDate trueWakeDate] = getTrueValues(fileName, ACTI, startTime, nbDataPerDays);
            
            %Sometime, all the nights weren't scored manually, so they need
            %to be removed from ACTI and trueSW
            [ACTI trueSW startTime t] = modifyLength(ACTI, trueSW, startTime, t, resolution);
            
            
            %ACTI = preprocessing(ACTI);

            
            %Determine if the subject is awake or asleep at each period of
            %time
            %SW = getSW(ACTI, wakeToSleep, sleepToWake);
            
            %The epochs of sleep or being awake that are too small are
            %removed
            %SW = modifySW(SW);
            
            %Preprocessing stage
            [SW x xf y1] = crespoPreprocessing(ACTI, resolution);
            %plotPreprocessing(fileName, ACTI, SW, x, xf, y1, resolution, t);
            plotSW(fileName, ACTI, SW, trueSW, resolution, t); %Show the results after the preprocessing stage only
            
            %Processing stage
            %SW = crespoProcessing(ACTI, SW, resolution);
            [SW] = processing(ACTI, SW, resolution);
            
            
            [sleepDate wakeDate] = getNights(SW, startTime, nbDataPerDays); %s
%             bedDate = getBedTime(ACTI, sleepDate, startTime, nbDataPerDays); %s
%             upDate = getUpTime(ACTI, wakeDate, startTime, nbDataPerDays); %s
%             assumedSleepTime = upTime - bedTime;
%             actualSleepTime = wakeTime - sleepTime;
%             actualSleep = actualSleepTime ./ assumedSleepTime;
%             actualWakeTime = assumedSleepTime - actualSleepTime;
%             actualWake = actualWakeTime ./ assumedSleepTime;
%             [sleepDuration meanDuration stdDev] = getDuration(sleepTime, wakeTime, resolution, nbDataPerDays);
%             
%             saveData(fileName, sleepTime, wakeTime, bedTime, upTime, assumedSleepTime, actualSleepTime, actualSleep, actualWakeTime, actualWake, sleepDuration, meanDuration, stdDev);
%             
%             figure;
%             hold on;
%             x = meanDuration-5*stdDev:1:meanDuration+5*stdDev;
%             y = gaussmf(x, [stdDev, meanDuration]);
%             plot(x / 3600, y);

            plotSW(fileName, ACTI, SW, trueSW, resolution, t);
            %plotCircle(SW, trueSW, startTime, nbDataPerDays);
            
            %stats(SW, trueSW, wakeDate, trueWakeDate, sleepDate, trueSleepDate);

            
            %saveas(gcf, '~/sleep', 'png');
            %saveXLS(wakeDate, sleepDate);
            
        end;
    
end;


end