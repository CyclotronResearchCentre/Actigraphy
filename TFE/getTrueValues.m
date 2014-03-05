function [trueSW bedDate upDate sleepDate wakeDate] = getTrueValues(fileName, ACTI, startTime, nbDataPerDays)

constantes;

[bedDate upDate sleepDate wakeDate] = readXLS(fileName);

trueSW = zeros(1, length(ACTI)); %Sleep-Wake scored by hand
state = AWAKE;

sleepIndex = 1;
wakeIndex = 1;

for i = 1:length(ACTI)
    if sleepIndex <= length(sleepDate) && startTime > sleepDate(sleepIndex)
        state = ASLEEP;
        sleepIndex = sleepIndex + 1;
    end;
    
    if wakeIndex <= length(wakeDate) && startTime > wakeDate(wakeIndex)
        state = AWAKE;
        wakeIndex = wakeIndex + 1;
    end;
    
    trueSW(i) = state;
    startTime = startTime + 1 / nbDataPerDays;
end;


end