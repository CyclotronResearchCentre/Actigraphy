function [sleepTime, wakeTime] = crc_ara_getNights(SW, startTime, nbDataPerDay)
%
% FORMAT [sleepTime wakeTime] = crc_ara_getNights(SW, time, nbDataPerDay)
%
% Get the sleep and wake times from the SW time series.
%
% INPUT:
% - SW           : SW time series of 1's and 0's
% - startTime    : start time
% - nbDataPerDay : #bins per day
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium


dSW = diff(SW);
all_t = startTime + (0:numel(SW)-1)/nbDataPerDay;

wakeTime  = all_t(dSW==1);
sleepTime = all_t(dSW==-1);

end