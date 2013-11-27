function [duration meanDuration stdDev] = getDuration(sleepTime, wakeTime, resolution, nbDataPerDays)

duration = zeros(1, length(sleepTime));

for i = 1:length(sleepTime)
    duration(i) = (wakeTime(i) - sleepTime(i)) * nbDataPerDays * resolution;  
end;

meanDuration = mean(duration);
stdDev = std(duration);

end