function [sleepTime, wakeTime] = getNights(SW, time, nbDataPerDays)
%
% FORMAT [sleepTime wakeTime] = getNights(SW, time, nbDataPerDays)
%
% Get the sleep and wake times from the SW time series.
% 
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

ASLEEP = crc_ara_get_defaults('acti.ASLEEP');
AWAKE = crc_ara_get_defaults('acti.AWAKE');

transitions = abs(diff(SW));
state = SW(1);

sleepTime = [];
wakeTime = [];

%For every transition, we find if the transition is WAKE -> SLEEP or
%SLEEP -> WAKE
for i = 1:length(SW)-1
    if(transitions(i) == 1)
        if state == ASLEEP
            wakeTime = [wakeTime time]; %#ok<*AGROW>
            state = AWAKE;
        else
            sleepTime = [sleepTime time];
            state = ASLEEP;
        end;
    end;
        
    time = time + 1 / nbDataPerDays;
end;

end