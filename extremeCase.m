function [stats_res] = extremeCase(datafile, nbFiles)
%
% FORMAT [stats_res] = extremeCase(datafile, nbFiles)
%
% Performs the analysis but substitute the extimated S/W cycles with either
% 'all sleep', 'all wake', and 'random s/w'.
%
% INPUT
% - datafile : list of files to process
% - nbFiles  : number of files
%
% OUTPUT
% - stats_res : structure with the results
%   . allWakeErrorRates, 
%   . allWakeSensitivities, 
%   . allWakeSpecificities, 
%   . allWakePrecision, 
%   . allSleepErrorRates, 
%   . allSleepSensitivities, 
%   . allSleepSpecificities, 
%   . allSleepPrecisions, 
%   . allRandomErrorRates, 
%   . allRandomSensitivities, 
%   . allRandomSpecificities, 
%   . allRandomPrecisions
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium
constantes;

allWakeErrorRates = zeros(1, nbFiles);
allWakeSensitivities = zeros(1, nbFiles);
allWakeSpecificities = zeros(1, nbFiles);
allWakePrecisions = zeros(1, nbFiles);

allSleepErrorRates = zeros(1, nbFiles);
allSleepSensitivities = zeros(1, nbFiles);
allSleepSpecificities = zeros(1, nbFiles);
allSleepPrecisions = zeros(1, nbFiles);

allRandomErrorRates = zeros(1, nbFiles);
allRandomSensitivities = zeros(1, nbFiles);
allRandomSpecificities = zeros(1, nbFiles);
allRandomPrecisions = zeros(1, nbFiles);

for ifile = 1:nbFiles
    
    %Get raw data from the file    
    file = datafile(ifile, :);
    [fileName, ACTI, nbDays, sleepToWake, wakeToSleep, resolution, startTime, t] = getData(file); %#ok<*ASGLU>
    nbDataPerDays = nbSecPerDays / resolution;
    [trueSW, trueBedDate, trueUpDate, trueSleepDate, trueWakeDate] = getTrueValues(fileName, ACTI, startTime, nbDataPerDays);
    
    %Sometime, all the nights weren't scored manually, so they need
    %to be removed from ACTI and trueSW
    [ACTI, trueSW, startTime, t] = modifyLength(ACTI, trueSW, startTime, t, resolution);
    
    allSleepSW = zeros(1, length(ACTI));
    allWakeSW = ones(1, length(ACTI));
    allRandomSW = rand(1, length(ACTI));
    allRandomSW(allRandomSW>0.5) = 1;
    allRandomSW(allRandomSW<=0.5) = 0;
    
    allWakeConfusionMatrix = confusionmat(~allWakeSW, ~trueSW);
    allWakeErrorRate = sum(allWakeSW ~= trueSW) / length(trueSW);
    allWakeSensitivity = allWakeConfusionMatrix(1, 1) / sum(allWakeConfusionMatrix(1, :));
    allWakeSpecificity = allWakeConfusionMatrix(2, 2) / sum(allWakeConfusionMatrix(2, :));
    allWakePrecision = allWakeConfusionMatrix(1, 1) / sum(allWakeConfusionMatrix(:, 1));
    
    allWakeErrorRates(ifile) = allWakeErrorRate;
    allWakeSensitivities(ifile) = allWakeSensitivity;
    allWakeSpecificities(ifile) = allWakeSpecificity;
    allWakePrecisions(ifile) = allWakePrecision;

    allSleepConfusionMatrix = confusionmat(~allSleepSW, ~trueSW);
    allSleepErrorRate = sum(allSleepSW ~= trueSW) / length(trueSW);
    allSleepSensitivity = allSleepConfusionMatrix(1, 1) / sum(allSleepConfusionMatrix(1, :));
    allSleepSpecificity = allSleepConfusionMatrix(2, 2) / sum(allSleepConfusionMatrix(2, :));
    allSleepPrecision = allSleepConfusionMatrix(1, 1) / sum(allSleepConfusionMatrix(:, 1));
    
    allSleepErrorRates(ifile) = allSleepErrorRate;
    allSleepSensitivities(ifile) = allSleepSensitivity;
    allSleepSpecificities(ifile) = allSleepSpecificity;
    allSleepPrecisions(ifile) = allSleepPrecision;
    
    allRandomConfusionMatrix = confusionmat(~allRandomSW, ~trueSW);
    allRandomErrorRate = sum(allRandomSW ~= trueSW) / length(trueSW);
    allRandomSensitivity = allRandomConfusionMatrix(1, 1) / sum(allRandomConfusionMatrix(1, :));
    allRandomSpecificity = allRandomConfusionMatrix(2, 2) / sum(allRandomConfusionMatrix(2, :));
    allRandomPrecision = allRandomConfusionMatrix(1, 1) / sum(allRandomConfusionMatrix(:, 1));
    
    allRandomErrorRates(ifile) = allRandomErrorRate;
    allRandomSensitivities(ifile) = allRandomSensitivity;
    allRandomSpecificities(ifile) = allRandomSpecificity;
    allRandomPrecisions(ifile) = allRandomPrecision;
end;

stats_res = struct( ...
    'allWakeErrorRates', allWakeErrorRates, ...
    'allWakeSensitivities', allWakeSensitivities, ...
  	'allWakeSpecificities', allWakeSpecificities, ...
    'allWakePrecision', allWakePrecision, ... 
    'allSleepErrorRates', allSleepErrorRates, ...
    'allSleepSensitivities', allSleepSensitivities, ...
    'allSleepSpecificities', allSleepSpecificities, ...
    'allSleepPrecisions', allSleepPrecisions, ...
    'allRandomErrorRates', allRandomErrorRates, ...
    'allRandomSensitivities', allRandomSensitivities, ...
    'allRandomSpecificities', allRandomSpecificities, ...
    'allRandomPrecisions', allRandomPrecisions);

end