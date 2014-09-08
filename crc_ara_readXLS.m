function [bedDate, upDate, sleepDate, wakeDate] = crc_ara_readXLS(fileName)
%
% Function reading in the .xlsx file containingthe results of the manual
% analysis fo actigraphic data.
%
% INPUT:
% - fileName : filename of the .xlsx file to read in
%
% OUPUT:
% - bedDate, series of bed datetime
% - upDate, idem
% - sleepDate, idem
% - wakeDate, idem
%
%
% WARNING
% The .xlsx file reading seems to be working only on a Windows system with
% Microsoft Excell sofwate installed.
% Sorry about that.
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

try
    [num,txt,raw] = xlsread(fileName); %#ok<*ASGLU>
catch %#ok<*CTCH>
    [pth,fn,ext] = fileparts(fileName);
    strline = '--------------------------';
    fprintf('%s \n', strline);
    fprintf('Something went wrong while importing file): %s\n',fullfile(fn,ext));
    fprintf('NOTE: \n');
    fprintf('\tYou need to be on a widows machine with Excell installed.\n');
    fprintf('%s \n \n', strline);
end

% Start day of recording
startDayRec = raw(4, 4);
startDateRec = datenum(startDayRec,'dd/mm/yyyy'); %#ok<*NASGU>

% Start day of scoring
startDay = raw(10, 5);
startDate = datenum(startDay,'dd/mm/yyyy');

% counted in fraction of day!
bedTime = raw(11, 5:end); bedTime = cell2mat(bedTime);
lNaN = find(isnan(bedTime)); bedTime(lNaN(1):end) = [];
upTime = raw(12, 5:end); upTime = cell2mat(upTime);
lNaN = find(isnan(upTime)); upTime(lNaN(1):end) = [];
sleepTime = raw(14, 5:end); sleepTime = cell2mat(sleepTime);
lNaN = find(isnan(sleepTime)); sleepTime(lNaN(1):end) = [];
wakeTime = raw(15, 5:end); wakeTime = cell2mat(wakeTime);
lNaN = find(isnan(wakeTime)); wakeTime(lNaN(1):end) = [];

% Checking at what time wake/sleep/bed/up took place and possibly add 1
% day to the date/time number.
% Assume that
% - if bed/sleep time if before 10am, i.e. between midnight and 09:59
%   then it took place the day after. Otherwise on date day
% - Wake/Up is always taking place the 'day after'.
% Then add the startDate.

nbDay_m1 = numel(bedTime)-1;
bedDate = bedTime + (bedTime*24<10) + startDate + (0:nbDay_m1);
sleepDate = sleepTime + (sleepTime*24<10) + startDate + (0:nbDay_m1);
upDate = upTime + 1 + startDate + (0:nbDay_m1);
wakeDate = wakeTime + 1 + startDate + (0:nbDay_m1);

end