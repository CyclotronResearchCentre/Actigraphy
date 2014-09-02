function [bedDate upDate sleepDate wakeDate] = readXLS(fileName, startDate)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

fileName = strcat(fileName, '_sleep analysis.xls');
%Warnings are set off because xlsread shows a useless warning message
warning('off', 'all');
data = xlsread(fileName);
warning('off', 'all');

startDay = num2str(data(1, 1));
if numel(startDay) == 7
    startDate = datenum(str2num(startDay(4:7)), str2num(startDay(2:3)), str2num(startDay(1)), 0, 0, 0);
else
    startDate = datenum(str2num(startDay(5:8)), str2num(startDay(3:4)), str2num(startDay(1:2)), 0, 0, 0);
end;

bedTime = data(2, :);
upTime = data(3, :);
sleepTime = data(4, :);
wakeTime = data(5, :);

nbDays = size(bedTime, 2);

bedDate = zeros(1, nbDays);
upDate = zeros(1, nbDays);
sleepDate = zeros(1, nbDays);
wakeDate = zeros(1, nbDays);

days = 0;

for i = 1:nbDays
    bed = '';
    sleep = '';
    up = '';
    wake = '';
    
    bed = num2str(bedTime(i));
    if numel(bed) == 2
        bedDate(i) = datenum(0, 0, 0, 0, str2num(bed(1:2)), 0) + days + 1;
    elseif numel(num2str(bed)) == 3
        bedDate(i) = datenum(0, 0, 0, str2num(bed(1)), str2num(bed(2:3)), 0) + days + 1;
    else
        bedDate(i) = datenum(0, 0, 0, str2num(bed(1:2)), str2num(bed(3:4)), 0) + days;
    end;
    
    sleep = num2str(sleepTime(i));
    %If there are 2 digits in the number (exple : 00h14)
    if numel(sleep) == 2
        sleepDate(i) = datenum(0, 0, 0, 0, str2num(sleep(1:2)), 0) + days + 1;
    %If there are 3 digits in the number (exple : 01h14)
    elseif numel(num2str(sleep)) == 3
        sleepDate(i) = datenum(0, 0, 0, str2num(sleep(1)), str2num(sleep(2:3)), 0) + days + 1;
    else
        sleepDate(i) = datenum(0, 0, 0, str2num(sleep(1:2)), str2num(sleep(3:4)), 0) + days;
    end;
    
    days = days + 1;
    
    up = num2str(upTime(i));
    if numel(up) == 2
        upDate(i) = datenum(0, 0, 0, 0, str2num(up(1:2)), 0) + days;
    elseif numel(num2str(up)) == 3
        upDate(i) = datenum(0, 0, 0, str2num(up(1)), str2num(up(2:3)), 0) + days;
    else
        upDate(i) = datenum(0, 0, 0, str2num(up(1:2)), str2num(up(3:4)), 0) + days;
    end;
    
    wake = num2str(wakeTime(i));
    if numel(wake) == 2
        wakeDate(i) = datenum(0, 0, 0, 0, str2num(wake(1:2)), 0) + days;
    elseif numel(num2str(wake)) == 3
        wakeDate(i) = datenum(0, 0, 0, str2num(wake(1)), str2num(wake(2:3)), 0) + days;
    else
        wakeDate(i) = datenum(0, 0, 0, str2num(wake(1:2)), str2num(wake(3:4)), 0) + days;
    end;
end;

bedDate = bedDate + startDate;
upDate = upDate + startDate;
sleepDate = sleepDate + startDate;
wakeDate = wakeDate + startDate;


end