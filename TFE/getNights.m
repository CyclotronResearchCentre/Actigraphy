function [sleepTime wakeTime] = getNights(SW, time, nbDataPerDays)

ASLEEP = 0;
AWAKE = 1;

transitions = abs(diff(SW));
state = SW(1);

sleepTime = [];
wakeTime = [];

for i = 1:length(SW)-1
    
    if(transitions(i) == 1)
        if(state == ASLEEP)
            wakeTime = [wakeTime time];
            state = AWAKE;
        else
            sleepTime = [sleepTime time];
            state = ASLEEP;
        end;
    end;
        
    time = time + 1 / nbDataPerDays;
end;

% for i = 1:length(wakeTime)
%     datestr(wakeTime(i))
% end;
% 
% for i = 1:length(sleepTime)
%     datestr(sleepTime(i))
% end;

end