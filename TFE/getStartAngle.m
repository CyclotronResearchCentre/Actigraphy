function [ang] = getStartAngle(startTime)

startTime = datestr(startTime);

%If the time of the beginning is defined in startTime, it is used
if numel(startTime) > 11
    startHour = startTime(13:14);
    startMinute = startTime(16:17);
%Else, it is set to midnight
else
    startHour = '0';
    startMinute = '0';
end;

ang = pi / 2 - ((2 * pi) / 24) * str2num(startHour) - ((2 * pi) / (24 * 60)) * str2num(startMinute);

end