function [trueV] = crc_ara_getTrueValues(fileName, nACTI, startTime, nbDataPerDay)
%
% Function that extracts the "true values" as saved in the Excell file
% created during the manual scoring of actigraphic data.
%
% INPUT:
% - fileName, filename of the .xlsx file
% - nACTI, number of bins in the ACTI data
% - startTime, start time 'number' of the recording
% - nbDataPerDay, number of samples per day
% 
% OUTPUT:
% - trueV : structure containing the following fields
%   . trueSW, true sleep/wake series generated from the true sleep & wake
%             times
%   . bedDate, bed times 
%   . upDate, up times
%   . sleepDate, sleep times
%   . wakeDate wake times
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

% Reads the XLS file related to the manual scoring and retrieves the data
[bedDate, upDate, sleepDate, wakeDate] = crc_ara_readXLS(fileName);

AWAKE  = crc_ara_get_defaults('sw.AWAKE');
ASLEEP = crc_ara_get_defaults('sw.ASLEEP');

trueSW = zeros(1, nACTI); %Sleep-Wake scored by hand
state = AWAKE; % start with being awake.

sleepIndex = 1;
wakeIndex = 1;

% Creates the "trueSW" array, ie the array created from the manual scoring
for ii = 1:nACTI
    if sleepIndex <= length(sleepDate) && startTime > sleepDate(sleepIndex)
        state = ASLEEP;
        sleepIndex = sleepIndex + 1;
    end;
    
    if wakeIndex <= length(wakeDate) && startTime > wakeDate(wakeIndex)
        state = AWAKE;
        wakeIndex = wakeIndex + 1;
    end;
    
    trueSW(ii) = state;
    startTime = startTime + 1 / nbDataPerDay;
end;

trueV = struct( ...
    'trueSW', trueSW, ...
    'bedDate', bedDate, ...
    'upDate', upDate, ...
    'sleepDate', sleepDate, ...
    'wakeDate', wakeDate);

end