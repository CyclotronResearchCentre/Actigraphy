function [SW] = getSW(ACTI, wakeToSleep, sleepToWake)

constantes

windowLength = wakeToSleep;

SW = zeros(1, length(ACTI)); %Sleep / Wake vector
threshold = prctile(ACTI, percentile);

%Activity and SW are initialized (the subject is considered to
%be awake when the study begins)
state = AWAKE;
for i = 1:windowLength
    SW(i) = AWAKE;
end;

for i = wakeToSleep+1:length(ACTI)
    %When the subject is awake
    windowActivity = prctile(ACTI(i-windowLength:i), percentile);
    
    %If the activity in the window is too low
    if windowActivity < threshold && state == AWAKE
        for j = i - windowLength:i
            SW(j) = ASLEEP;
        end;
        state = ASLEEP;
        
    elseif windowActivity > threshold && state == ASLEEP
        for j = i - windowLength:i
            SW(j) = AWAKE;
        end;
        state = AWAKE;
        
    else
        SW(i) = state;
    end;
end;

end