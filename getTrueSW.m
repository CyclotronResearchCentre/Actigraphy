function [trueSW] = getTrueSW(fileName, ACTI, startTime, nbDataPerDays)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

constantes

[bedDate upDate sleepDate wakeDate] = readXLS(fileName);

trueSW = zeros(length(ACTI), 1);
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