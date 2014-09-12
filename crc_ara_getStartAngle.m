function [ang] = crc_ara_getStartAngle(startTime)
%
% Return the time of day angle from the starting time.
%
% INPUT:
% - startTime : date vector
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

startTime = datestr(startTime);
% If the time of the beginning is defined in startTime, it is used
if numel(startTime) > 11
startHour = str2double(startTime(13:14));
startMinute = str2double(startTime(16:17));
% Else, it is set to midnight
else
startHour = 0;
startMinute = 0;
end;
ang = pi / 2 - ((2 * pi) / 24) * startHour - ...
((2 * pi) / (24 * 60)) * startMinute;
end
