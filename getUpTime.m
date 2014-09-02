function [upTime] = getUpTime(ACTI, wakeTime, startTime, nbDataPerDays)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

wakeTime = (wakeTime - startTime) * nbDataPerDays;
factor = 1.8;

for i = 1:length(wakeTime)
    index = wakeTime(i);
    indexMax = index;
    max = ACTI(int32(indexMax));
    
    for j = 1:15
        if(ACTI(int32(index + j)) > factor * max)
            max = ACTI(int32(index + j));
            indexMax = index + j;
        end;
    end;
    
    upTime(i) = indexMax;
end;

upTime = upTime / nbDataPerDays + startTime;

end