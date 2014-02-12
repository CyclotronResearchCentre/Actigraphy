function [fileName ACTI nbDays sleepToWake wakeToSleep resolution startTime t] = getData(datafile, ifile)

constantes

% ! OUVERTURE ET LECTURE DU FICHIER !
[fileName ACTI resolution startTime nbDays] = readFile(datafile, ifile);

% ! CALCUL DE NOUVEAUX PARAMETRES !
sleepToWake = sleepToWakeSec / resolution; %s -> nb de pas de temps
wakeToSleep = wakeToSleepSec / resolution; %s -> nb de pas de temps

t_abs = startTime + [0:resolution/nbSecPerDays:resolution/nbSecPerDays*(length(ACTI) - 1)]; %Absolute time of the acquisition
t = rem(t_abs, 1); %Relative time for each day of the acquisition

nbDays2 = round(length(ACTI) * resolution / nbSecPerDays);


fprintf('%s \n', strline);
fprintf('Number of days : %d \n', nbDays);
fprintf('Number of days : %d \n', nbDays2);
fprintf('Start time : %s \n', datestr(startTime));
fprintf('%s \n', strline);

end