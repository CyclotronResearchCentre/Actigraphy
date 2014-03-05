function [SW] = processing(ACTI, SW, resolution)

constantes;

transitions = find(abs(diff(SW))==1);
sleepIndex = [];
wakeIndex = [];
sleep = [];
wake = [];

state = AWAKE;
index = 1;

for i = 1:length(transitions)
    if state == AWAKE
        sleepIndex = [sleepIndex; transitions(i)];
        wake = [wake, ACTI(index:transitions(i)-1)];
        state = ASLEEP;
        index = transitions(i);
    else
        wakeIndex = [wakeIndex; transitions(i)];
        sleep = [sleep, ACTI(index:transitions(i)-1)];
        state = AWAKE;
        index = transitions(i);
    end;
end;

wake = [wake, ACTI(index:end)];

medianSleep = mean(sleep);
medianWake = mean(wake);
stdSleep = std(sleep);
stdWake = std(wake);

windowLength = 150 * (60 / resolution); %60 minute-long window
sleepLength = 90 * (60 / resolution);
for i = 1:length(sleepIndex)
    index = sleepIndex(i);
    window = ACTI(index-windowLength:index+windowLength);
    for j = 1:length(window)
        if mean(ACTI(index-windowLength+j:index-windowLength+j+sleepLength)) <= medianSleep + 2*stdSleep && mean(ACTI(index-windowLength+j:index-windowLength+j+5)) <= medianWake + 2 * stdSleep;
            SW(index-windowLength:index-windowLength+j-1) = AWAKE;
            SW(index-windowLength+j:index+windowLength) = ASLEEP;
            break;
        end;
    end;
end;

windowLength = 180 * (60 / resolution); %60 minute-long window
wakeLength = 30 * (60 / resolution);
for i = 1:length(wakeIndex)
    index = wakeIndex(i);
    window = ACTI(index-windowLength:index+windowLength);
    for j = 1:length(window)
        if mean(ACTI(index-windowLength+j:index-windowLength+j+wakeLength)) >= medianWake - 2 * stdSleep
            SW(index-windowLength:index-windowLength+j-1) = ASLEEP;
            SW(index-windowLength+j:index+windowLength) = AWAKE;
            break;
        end;
    end;
end;

end