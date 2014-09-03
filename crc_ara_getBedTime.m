function [bedTime] = crc_ara_getBedTime(ACTI, sleepTime, startTime, nbDataPerDays)
% 
% FORMAT [bedTime] = crc_ara_getBedTime(ACTI, sleepTime, startTime, nbDataPerDays)
%
% Roughly estimate the time of going to bed.
%
% INPUT:
% - ACTI          : actigraphic data
% - sleepTime     : estimated sleep date & time
% - startTime     : start time
% - nbDataPerDays : #bins/da
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

sleepTime = (sleepTime - startTime) * nbDataPerDays;
factor = 1.8;
bedTime = zeros(1,numel(sleepTime));

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