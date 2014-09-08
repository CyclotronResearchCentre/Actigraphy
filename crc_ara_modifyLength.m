function [data, trueV] = crc_ara_modifyLength(data, trueV)
%
% Sometime, all the nights in the actigraphic data were not scored 
% manually. Therefore, in order to compare both automatic and manual
% scoring, the 1st part of the data and automatic scoring has to be
% removed.
%
% INPUT:
% - data  : the rest of the data derived from raw actigraphy file
% - trueV : "true" values from manual scoring file
% 
% OUTPUT:
%   idem but updated.
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

ASLEEP = crc_ara_get_defaults('sw.ASLEEP');
trueSW = trueV.trueSW;

% Finds the first "ASLEEP" record. The start of the recording is set to
% 300 records before it.
lASLEEP = find(trueSW==ASLEEP);
start = max(1,lASLEEP(1)-300);

ending = min(numel(trueSW),lASLEEP(end)+500);

% A few things now get modified to only inclue the time period between
% 'start' & 'ending', i.e. the few manually scored days.
data.ACTI = data.ACTI(start:ending);
data.t = data.t(start:ending);
data.startTime = data.startTime + (start - 1) * ...
    datenum(0, 0, 0, 0, 0, data.resolution);
data.nbDays = numel(trueV.bedDate);
trueV.trueSW = trueSW(start:ending);

end