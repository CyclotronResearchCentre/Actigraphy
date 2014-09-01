function [duration] = getDuration(sleepDate, wakeDate)

duration = zeros(1, length(sleepDate));

for i = 1:length(sleepDate)
    duration(i) = wakeDate(i) - sleepDate(i);
end;

end