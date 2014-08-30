function group(datafile, nbFiles)

constantes;

errorRates = zeros(1, nbFiles);
sensitivities = zeros(1, nbFiles);
specificities = zeros(1, nbFiles);
kappas = zeros(1, nbFiles);

%Does the scoring for every file in the group and retrieves some useful
%date
for ifile = 1:nbFiles
    file = datafile(ifile, :);
    [errorRate sensitivity specificity kappa meanWakeError stdWakeError meanSleepError stdSleepError] = individual(file, 1, 'COMPARISON', false);
    
    errorRates(ifile) = errorRate;
    sensitivities(ifile) = sensitivity;
    specificities(ifile) = specificity;
    kappas(ifile) = kappa;
end;

%Retrieves some data for extreme cases (all the records set sleep, set to
%wake, randomly scored)
[allWakeErrorRates, allWakeSensitivities, allWakeSpecificities, allWakePrecision, allSleepErrorRates, allSleepSensitivities, allSleepSpecificities, allSleepPrecisions, allRandomErrorRates, allRandomSensitivities, allRandomSpecificities, allRandomPrecisions] = extremeCase(datafile, nbFiles);

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

displayResults(allWakeErrorRates, allWakeSensitivities, allWakeSpecificities);

%% Display results for all sleep

fprintf('%s \n', strline);
fprintf('All the minutes are set to sleep : \n');

displayResults(allSleepErrorRates, allSleepSensitivities, allSleepSpecificities);

%% Display results for random scoring

fprintf('%s \n', strline);
fprintf('All the minutes are randomly set to wake or sleep : \n');
displayResults(allRandomErrorRates, allRandomSensitivities, allRandomSpecificities);


end