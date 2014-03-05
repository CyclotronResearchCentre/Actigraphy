function [ang] = getStartAngle(startTime)

startTime = datestr(startTime);

if numel(startTime) > 11
    startHour = startTime(13:14);
    startMinute = startTime(16:17);
else
    startHour = '0';
    startMinute = '0';
end;

ang = pi / 2 - ((2 * pi) / 24) * str2num(startHour) - ((2 * pi) / (24 * 60)) * str2num(startMinute);

end