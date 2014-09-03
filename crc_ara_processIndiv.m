function [SW,data] = crc_ara_processIndiv(datafile, option)
%
% FORMAT [stat_res] = crc_ara_processIndiv(datafile, option)
%
% Processes a series of actigraphy files and displaying the results.
% Possibly comparing each to some true scoring, provided in a separate .xls
% file in the same directory.
%
% INPUT
% - datafile    : filename of data to process
% - option structure:
%       . dispActiSW : display the actigraphic data and S/W on time plot
%       . dispSpirSW : display the S/W cycle on a spiral
%
% OUTPUT
% - SW   : Estimated sleep wake cycle
% - data : a structure containing the data and some other info
%       . ACTI       : actigraphic data
%       . resolution : temporal resolution
%       . nbDays     : number of days of recording
%       . startTime  : start date & time
%       . t          : time regressor for plot
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

%% Sorting defaults and options
opt_def = crc_ara_get_defaults('acti.res_opt');
if nargin<2, option = []; end
option = crc_ara_check_flag(opt_def,option);

% Select 1 file?
if nargin<1,
    datadir = crc_ara_get_defaults('dir.datadir');
    datafile = spm_select(1, '.+\.AWD$', 'Select files ',...
        [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
end

nbSecPerDays = 24*60*60;

%% Get Acti data & process
[fileName, ACTI, nbDays, resolution, startTime, t] = crc_ara_getData(datafile);
nbDataPerDays = nbSecPerDays / resolution;

% Sometimes the signal begins "too early" with a lot of 0 values
%  -> they are removed
[ACTI, startTime, t] = crc_ara_preprocessing(ACTI, startTime, t, resolution);

% Remove "long zeros" (actigraph removed by the subject)
ACTI = crc_ara_removeZeros(ACTI);

% Preprocessing stage
[SW, x, xf, y1] = crc_ara_crespoPreprocessing(ACTI, resolution); %#ok<*NASGU,*ASGLU>
% crc_ara_plotSW(fileName, ACTI, SW, resolution, t);

% Processing stage
[SW] = crc_ara_learning(ACTI, SW, resolution);

% Output data
data = struct('ACTI',ACTI, ...
    'resolution',resolution, ...
    'nbDays',nbDays, ...
	'startTime',startTime, ...
	't',t);

%% Plot results and get things out
if option.dispActiSW
    % Plots the data in a linear way
    crc_ara_plotSW(fileName, ACTI, SW, resolution, t);
end
if option.dispSpirSW
    % Plots the data on a circling spiral
    if option.dispSpirAC
        crc_ara_plotCircle(SW, startTime, nbDataPerDays, ACTI);
    else
        crc_ara_plotCircle(SW, startTime, nbDataPerDays);
    end
end;


if option.calcExtra
    [sleepDate, wakeDate] = crc_ara_getNights(SW, startTime, nbDataPerDays);
    bedDate = crc_ara_getBedTime(ACTI, sleepDate, startTime, nbDataPerDays);
    upDate  = crc_ara_getUpTime(ACTI, wakeDate, startTime, nbDataPerDays);
    %     assumedSleepDate = upDate - bedDate;
    %     actualSleepDate = wakeDate - sleepDate;
    %     actualSleep = actualSleepDate ./ assumedSleepDate;
    %     actualWakeDate = assumedSleepDate - actualSleepDate;
    %     actualWake = actualWakeDate ./ assumedSleepDate;
    sleepDuration = wakeDate - sleepDate;
    % Computes some more stats
    [stat_res] = crc_ara_sumStats(wakeDate, sleepDate, sleepDuration);
    
end

end

% NOTES:
% Need to add something to save the data in some useful format!
% Should be a .txt or xls file, for example upadte and use the 
% crc_ara_saveData or crc_ara_saveXLS routines to do this
% crc_ara_saveData(fileName, sleepTime, wakeTime, bedTime, upTime, ...
%   assumedSleepTime, actualSleepTime, actualSleep, actualWakeTime, ...
%   actualWake, sleepDuration, meanDuration, stdDev);
% crc_ara_saveXLS(wakeDate, sleepDate);

