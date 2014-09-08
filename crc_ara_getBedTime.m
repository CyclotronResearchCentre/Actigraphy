function [bedTime] = crc_ara_getBedTime(ACTI, sleepTime, startTime, nbDataPerDay)
% 
% FORMAT [bedTime] = crc_ara_getBedTime(ACTI, sleepTime, startTime, nbDataPerDay)
%
% Roughly estimate the time of going to bed.
%
% INPUT:
% - ACTI          : actigraphic data
% - sleepTime     : estimated sleep date & time
% - startTime     : start time
% - nbDataPerDay  : #bins/day
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

sleepTime = (sleepTime - startTime) * nbDataPerDay;
factor = crc_ara_get_defaults('but.factor');
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

bedTime = bedTime / nbDataPerDay + startTime;

end