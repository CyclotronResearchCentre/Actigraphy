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


            ACTI = preprocessing(ACTI);

            %Determine if the subject is awake or asleep at each period of
            %time
            SW = getSW(ACTI, wakeToSleep, sleepToWake);
            
            %The epochs of sleep or being awake that are too small are
            %removed
            SW = modifySW(SW);
            
            [trueSW trueBedDate trueUpDate trueSleepDate trueWakeDate] = getTrueValues(fileName, ACTI, startTime, nbDataPerDays);
            
            %Sometime, all the nights weren't scored manually so SW has to
            %be modified the remove these nights
            SW = modifySWLength(SW, trueSW);

            
            [sleepDate wakeDate] = getNights(SW, startTime, nbDataPerDays); %s
            bedDate = getBedTime(ACTI, sleepDate, startTime, nbDataPerDays); %s
            upDate = getUpTime(ACTI, wakeDate, startTime, nbDataPerDays); %s
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


            plotSW(fileName, ACTI, SW, trueSW);
            %plotCircle(SW, startTime, nbDataPerDays);
            
            stats(SW, trueSW, sleepDate, trueSleepDate, wakeDate, trueWakeDate);

            
            %saveas(gcf, '~/sleep', 'png');
            
        end;
    
end;


end
