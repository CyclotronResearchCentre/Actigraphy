%% Options

INDIVIDUAL = 1;
COMPARISON = 2;
GROUP = 3;

%% ACTI constantes

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
percentile = 30;

%% Comparison constantes

ALL_SLEEP = 0;
ALL_WAKE = 1;
ALL_RANDOM = 2;