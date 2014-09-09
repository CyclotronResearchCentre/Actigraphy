function crc_ara_extremeCase(trueSW)
% 
% FORMAT crc_ara_extremeCase(trueSW)
% 
% Simple way of comparing the true SW scoring with aither 'all sleep', 'all
% wake' or 'random' scoring.
% 
% INPUT:
% - trueSW : cell array of true scores from the manual scoring
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

strline = '--------------------------';
nbFiles = numel(trueSW);

CMs_sleepAll = zeros(2,2,nbFiles);
erRates_sleepAll = zeros(1, nbFiles);
sens_sleepAll = zeros(1, nbFiles);
spec_sleepAll = zeros(1, nbFiles);
kapp_sleepAll = zeros(1, nbFiles);

CMs_wakeAll = zeros(2,2,nbFiles);
erRates_wakeAll = zeros(1, nbFiles);
sens_wakeAll = zeros(1, nbFiles);
spec_wakeAll = zeros(1, nbFiles);
kapp_wakeAll = zeros(1, nbFiles);

CMs_randAll = zeros(2,2,nbFiles);
erRates_randAll = zeros(1, nbFiles);
sens_randAll = zeros(1, nbFiles);
spec_randAll = zeros(1, nbFiles);
kapp_randAll = zeros(1, nbFiles);

for ii=1:nbFiles
    trueSW_ii = trueSW{ii};
    nbBins = numel(trueSW_ii);
    
    % Generate fake SW scores
    SW_sleepAll = zeros(1,nbBins);
    SW_wakeAll = ones(1,nbBins);
    SW_randAll = round(rand(1,nbBins));
    
    % Get the stats from the comparison
    stat_cResSleepAll = crc_ara_compScStat(SW_sleepAll, trueSW_ii, false);
    stat_cResWakeAll  = crc_ara_compScStat(SW_wakeAll, trueSW_ii, false);
    stat_cResRandAll  = crc_ara_compScStat(SW_randAll, trueSW_ii, false);
    
    % Extract key parameters
    erRates_sleepAll(ii) = stat_cResSleepAll.errorRate;
    sens_sleepAll(ii)    = stat_cResSleepAll.sensitivity;
    spec_sleepAll(ii)    = stat_cResSleepAll.specificity;
    kapp_sleepAll(ii)    = stat_cResSleepAll.kappa;
    tmp = stat_cResSleepAll.CM;
    CMs_sleepAll(:,:,ii) = tmp/sum(tmp(:));

    erRates_wakeAll(ii) = stat_cResWakeAll.errorRate;
    sens_wakeAll(ii)    = stat_cResWakeAll.sensitivity;
    spec_wakeAll(ii)    = stat_cResWakeAll.specificity;
    kapp_wakeAll(ii)    = stat_cResWakeAll.kappa;
    tmp = stat_cResWakeAll.CM;
    CMs_wakeAll(:,:,ii) = tmp/sum(tmp(:));

    erRates_randAll(ii) = stat_cResRandAll.errorRate;
    sens_randAll(ii)    = stat_cResRandAll.sensitivity;
    spec_randAll(ii)    = stat_cResRandAll.specificity;
    kapp_randAll(ii)    = stat_cResRandAll.kappa;
    tmp = stat_cResRandAll.CM;
    CMs_randAll(:,:,ii) = tmp/sum(tmp(:));
end

% Display results
fprintf('%s \n', strline);
fprintf('All scores set to ''SLEEP'' : \n');
crc_ara_displayResults(erRates_sleepAll, sens_sleepAll, spec_sleepAll, ...
      kapp_sleepAll);
fprintf('%s \n', strline);
fprintf('All scores set to ''WAKE'' : \n');
crc_ara_displayResults(erRates_wakeAll, sens_wakeAll, spec_wakeAll, ...
      kapp_wakeAll);
fprintf('%s \n', strline);
fprintf('All scores set to ''RANDOM'' : \n');
crc_ara_displayResults(erRates_randAll, sens_randAll, spec_randAll, ...
      kapp_randAll);

end

