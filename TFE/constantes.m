ASLEEP = 0;
AWAKE = 1;
strline = '--------------------------';

nbSecPerDays = 86400;
sleepToWakeSec = 1800; %s (se réveiller = 30 minutes d'activité)
wakeToSleepSec = 1800; %s (s'endormir = 30 minutes d'inactivité)

%% Crespo constantes

z = 15;
za = 3;
zr = 50;
winAlpha = 1;
Lp = 60 + 1;
Lw = 60 * 4 + 1;
hs = 8;