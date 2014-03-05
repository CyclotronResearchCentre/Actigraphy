ASLEEP = 0;
AWAKE = 1;
strline = '--------------------------';

nbSecPerDays = 86400;
sleepToWakeSec = 1800; %s (se réveiller = 30 minutes d'activité)
wakeToSleepSec = 1800; %s (s'endormir = 30 minutes d'inactivité)

%% Crespo constantes

z = 15;
za = 2;
zr = 30;
winAlpha = 1;
Lp = 60 + 1;
Lw = 150;
hs = 8;
percentile = 33;