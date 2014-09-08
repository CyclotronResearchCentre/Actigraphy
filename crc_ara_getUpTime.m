function [upTime] = crc_ara_getUpTime(ACTI, wakeTime, startTime, nbDataPerDay)
%
% FORMAT [upTime] = crc_ara_getUpTime(ACTI, wakeTime, startTime, nbDataPerDay)
% 
% Roughly find the up time following the wake time
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

wakeTime = (wakeTime - startTime) * nbDataPerDay;
factor = crc_ara_get_defaults('but.factor');
upTime = zeros(1,numel(wakeTime));

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

upTime = upTime / nbDataPerDay + startTime;

end