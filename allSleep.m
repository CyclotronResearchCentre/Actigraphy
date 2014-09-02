function allSleep(option)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium
constantes;
strline = '--------------------------';

close all;

origdir = '/home/miguel/Cours/TFE/';
datadir = fullfile(origdir, 'Actigraphy_TMS');

%Select the files to be analysed
datafile = spm_select(Inf, '.+\.AWD$', 'Select files ...', [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
if(isempty(datafile))
    nbFiles = 0;
else
    nbFiles = size(datafile, 1);
end;

errorRates = zeros(1, nbFiles);

for ifile = 1:nbFiles
    
    %Get raw data from the file    
    file = datafile(ifile, :);
    [fileName, ACTI, nbDays, sleepToWake, wakeToSleep, resolution, startTime, t] = getData(file);
    nbDataPerDays = nbSecPerDays / resolution;
    [trueSW, trueBedDate, trueUpDate, trueSleepDate, trueWakeDate] = getTrueValues(fileName, ACTI, startTime, nbDataPerDays); %#ok<*ASGLU>
    
    %Sometime, all the nights weren't scored manually, so they need
    %to be removed from ACTI and trueSW
    [ACTI, trueSW, startTime, t] = modifyLength(ACTI, trueSW, startTime, t, resolution);
    
    SW = zeros(1, length(ACTI)); %All minutes = ASLEEP
    
    errorRate = sum(SW ~= trueSW) / length(SW);
    errorRates(ifile) = errorRate;
end;

fprintf('%s \n', strline);
fprintf('Erreur moyenne : %f \n', mean(errorRates));
fprintf('Erreur max : %f \n', max(errorRates));
fprintf('Erreur min : %f \n', min(errorRates));
fprintf('%s \n \n', strline);

end