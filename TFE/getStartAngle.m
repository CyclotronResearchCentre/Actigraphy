function [ang] = getStartAngle(startTime)

startTime = datestr(startTime);
startHour = startTime(13:14);
startMinute = startTime(16:17);
ang = pi / 2 - ((2 * pi) / 24) * str2num(startHour) - ((2 * pi) / (24 * 60)) * str2num(startMinute);

end