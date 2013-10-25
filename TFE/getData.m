function [fileName ACTI ACTI2 resolution sleepToWake wakeToSleep t] = getData(datafile, ifile)

% ! DÉTÉRMINATION DE CERTAINS PARAMÈTRES !
nbSecPerDay = 86400; %s
bufferPoint = 3600; %s (the first hour is ignored)
sleepToWakeSec = 900; %s (se réveiller = 15 minutes d'activité)
wakeToSleepSec = 1800; %s (s'endormir = 30 minutes d'inactivité)
strline = '--------------------------';

% ! OUVERTURE ET LECTURE DU FICHIER !
[fileName ACTI resolution startTime nbDays] = readFile(datafile, ifile, bufferPoint);

% ! CALCUL DE NOUVEAUX PARAMETRES !
sleepToWake = sleepToWakeSec / resolution; %s -> nb de pas de temps
wakeToSleep = wakeToSleepSec / resolution; %s -> nb de pas de temps

t_abs = startTime + [0:resolution/nbSecPerDay:resolution/nbSecPerDay*(length(ACTI) - 1)]; %Absolute time of the acquisition
t = rem(t_abs, 1); %Relative time for each day of the acquisition

% ! ACTI -> ACTI 2 !

for i = 1:length(ACTI)
    if ACTI(i) > 10
        ACTI2(i) = 1;
    else
        ACTI2(i) = 0;
    end;
end;

nbDays2 = round(length(ACTI) * resolution / nbSecPerDay);


fprintf('%s \n', strline);
fprintf('Number of days : %d \n', nbDays);
fprintf('Number of days : %d \n', nbDays2);
fprintf('%s \n', strline);

end