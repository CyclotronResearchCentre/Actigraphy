function [SW] = getSW(ACTI, wakeToSleep, sleepToWake)

constantes

SW = zeros(length(ACTI), 1); %Sleep / Wake vector
threshold = [median(ACTI) / 4, 2 * median(ACTI) / 3];
activity = 0; %activity = sum of the counts in the sliding window
nbNights = 0;


%Activity and SW are initialized (the subject is considered to
%be awake when the study begins)
state = AWAKE;
for i = 1:wakeToSleep
    activity = activity + ACTI(i);
    SW(i) = AWAKE;
end;

for i = wakeToSleep+1:length(ACTI)
    %When the subject is awake
    if state == AWAKE
        medianActivity = median(ACTI(i-wakeToSleep:i));
        
        %If the activity in the window is too low
        if medianActivity < threshold(1)
            for j = i - wakeToSleep:i
                SW(j) = ASLEEP;
            end;
            state = ASLEEP;
            nbNights = nbNights + 1;
        else
            SW(i) = state;
        end;
        
        
        %Lorsque le sujet est considéré endormi
    elseif state == ASLEEP
        
        medianActivity = median(ACTI(i-sleepToWake:i));
        
        %Si on a trop d'activité sur la fenêtre -> le sujet est
        %éveillé
        if medianActivity > threshold(2)
            for j = i - sleepToWake:i
                SW(j) = AWAKE;
            end;
            state = AWAKE;
        else
            SW(i) = state;
        end;
    end;
end;

end