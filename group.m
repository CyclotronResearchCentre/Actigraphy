function group(datafile, nbFiles)
%
% FORMAT [] = group(datafile, nbFiles)
%
% Performa group analysis, i.e.
%   - analysze a series of actigraphic files
%   - perform some group level analysis
%   - compare these results with 'extrem' cases, i.e. "all sleep", "all
%     wake" or "random sleep/wake" cycles
%
% INPUT
% - datafile : list of files to process
% - nbFiles  : number of files
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

% constantes;
strline = '--------------------------';

errorRates = zeros(1, nbFiles);
sensitivities = zeros(1, nbFiles);
specificities = zeros(1, nbFiles);
kappas = zeros(1, nbFiles);

% Does the scoring for every file in the group and retrieves some useful
% date
for ifile = 1:nbFiles
    file = datafile(ifile, :);
    [stat_res] = individual(file, 1, 'COMPARISON', false);
    % no plotting & requires the 'ground truth' .xls files!
    
    errorRates(ifile) = stat_res.errorRate;
    sensitivities(ifile) = stat_res.sensitivity;
    specificities(ifile) = stat_res.specificity;
    kappas(ifile) = stat_reskappa;
end;

% Retrieves some data for extreme cases (all the records set sleep, set to
% wake, randomly scored)

[stats_res_extr] = extremeCase(datafile, nbFiles);

%% Display results for the algorithm

displayResults(errorRates, sensitivities, specificities);

fprintf('%s \n', strline);
fprintf('Kappa moyen : %f \n', mean(kappas));
fprintf('Kappa max : %f \n', max(kappas));
fprintf('Kappa min : %f \n', min(kappas));
fprintf('%s \n \n', strline);

%% Display results for all wake

fprintf('%s \n', strline);
fprintf('All the minutes are set to wake : \n');

displayResults(stats_res_extr.allWakeErrorRates, ...
    stats_res_extr.allWakeSensitivities, ...
    stats_res_extr.allWakeSpecificities);

%% Display results for all sleep

fprintf('%s \n', strline);
fprintf('All the minutes are set to sleep : \n');

displayResults(stats_res_extr.allSleepErrorRates, ...
    stats_res_extr.allSleepSensitivities, ...
    stats_res_extr.allSleepSpecificities);

%% Display results for random scoring

fprintf('%s \n', strline);
fprintf('All the minutes are randomly set to wake or sleep : \n');
displayResults(stats_res_extr.allRandomErrorRates, ...
    stats_res_extr.allRandomSensitivities, ...
    stats_res_extr.allRandomSpecificities);


end