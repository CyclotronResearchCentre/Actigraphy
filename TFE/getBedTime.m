function [bedTime] = getBedTime(ACTI, sleepTime, startTime, nbDataPerDays)

sleepTime = (sleepTime - startTime) * nbDataPerDays;
factor = 1.8;

for i = 1:length(sleepTime)
    index = sleepTime(i);
    indexMax = index;
    max = ACTI(int32(indexMax));
    
    for j = 1:15
        if(ACTI(int32(index - j)) > factor * max)
            max = ACTI(int32(index - j));
            indexMax = index - j;
        end;
    end;
    
    bedTime(i) = indexMax;
end;

bedTime = bedTime / nbDataPerDays + startTime;

end