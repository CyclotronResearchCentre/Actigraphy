function [SW,data,stat_res] = crc_ara_processIndiv(fn_dat, option)
%
% FORMAT [SW,data,stat_res] = crc_ara_processIndiv(fn_dat, option)
%
% Processes a single actigraphy files.
% Depending on 'option', also displaying the results in 1 or 2 figures and
% estimating some more parameters
%
% INPUT
% - fn_dat : filename of data to process
% - option : structure with some options. If not provided, use 'defaults'
%       . dispActiSW : display the actigraphic data and S/W on time plot
%       . dispSpirSW : display the S/W cycle on circle
%       . dispSpirAC : display ACTI data on circle
%       . calcExtra  : estimate extra parameters
%
% OUTPUT
% - SW       : Estimated sleep wake cycle
% - data     : a structure containing the data and some other info
%       . ACTI       : actigraphic data
%       . resolution : temporal resolution
%       . nbDays     : number of days of recording
%       . startTime  : start date & time
%       . t          : time regressor for plot
%       . subjName   : subject name (from file name)
% - stat_res : some processed results
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
    fn_dat = spm_select(1, '.+\.AWD$', 'Select files ',...
        [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
end

nbSecPerDay = 24*60*60;

%% Get Acti data & process
[subjName, ACTI, nbDays, resolution, startTime, t] = crc_ara_getData(fn_dat);
nbDataPerDay = nbSecPerDay / resolution;

% Sometimes the signal begins "too early" with a lot of 0 values
%  -> they are removed
[ACTI, startTime, t] = crc_ara_preprocessing(ACTI, startTime, t, resolution);

% Remove "long zeros" (actigraph removed by the subject)
ACTI = crc_ara_removeZeros(ACTI);

% Preprocessing stage
[SW, x, xf, y1] = crc_ara_crespoPreprocessing(ACTI, resolution); %#ok<*NASGU,*ASGLU>
% crc_ara_plotSW(subjName, ACTI, SW, resolution, t);

% Processing stage
[SW] = crc_ara_learning(ACTI, SW, resolution);

% Output data
data = struct('ACTI',ACTI, ...
    'resolution',resolution, ...
    'nbDays',nbDays, ...
	'startTime',startTime, ...
	't',t, ...
    'subjName',subjName);

%% Plot results and get things out
if option.dispActiSW
    % Plots the data in a linear way
    crc_ara_plotSW(subjName, ACTI, SW, resolution, t);
end
if option.dispSpirSW
    % Plots the data on a circling spiral
    if option.dispSpirAC
        crc_ara_plotCircle(SW, startTime, nbDataPerDay, ACTI);
    else
        crc_ara_plotCircle(SW, startTime, nbDataPerDay);
    end
end;

if option.calcExtra
    [sleepDate, wakeDate] = crc_ara_getNights(SW, startTime, nbDataPerDay);
    bedDate = crc_ara_getBedTime(ACTI, sleepDate, startTime, nbDataPerDay);
    upDate  = crc_ara_getUpTime(ACTI, wakeDate, startTime, nbDataPerDay);
    % Sleep efficiency
    assumedSleepDate = upDate - bedDate;
    actualSleepDate = wakeDate - sleepDate;
    actualSleepRatio = actualSleepDate ./ assumedSleepDate;
    actualWakeDate = assumedSleepDate - actualSleepDate;
    actualWakeRatio = actualWakeDate ./ assumedSleepDate;
    
    sleepDuration = wakeDate - sleepDate;
    % Computes some more stats
    [stat_res] = crc_ara_sumStats(wakeDate, sleepDate, sleepDuration);
    % With output
    % stat_res = struct( ...
    %     'meanWakeTime', meanWakeTime, ...
    %     'medianWakeTime', medianWakeTime, ...
    %     'stdWakeTime', stdWakeTime, ...
    %     'meanSleepTime', meanSleepTime, ...
    %     'medianSleepTime', medianSleepTime, ...
    %     'stdSleepTime', stdSleepTime, ...
    %     'meanDuration', meanDuration, ...
    %     'medianDuration', medianDuration, ...
    %     'stdDuration', stdDuration);
    daily = struct(...
        'sleepDate', sleepDate, ...
        'wakeDate', wakeDate, ...
        'bedDate', bedDate, ...
        'assumedSleepDate', assumedSleepDate, ...
        'actualSleepDate', actualSleepDate, ...
        'actualSleepRatio', actualSleepRatio, ...
        'actualWakeDate', actualWakeDate, ...
        'actualWakeRatio', actualWakeRatio, ...
        'sleepDuration', sleepDuration ...
        );
    stat_res.daily = daily;
end

end

% NOTES:
% Need to add something to save the data in some useful format!
% Should be a .txt or xls file, for example upadte and use the 
% crc_ara_saveData or crc_ara_saveXLS routines to do this
% crc_ara_saveData(subjName, sleepTime, wakeTime, bedTime, upTime, ...
%   assumedSleepTime, actualSleepTime, actualSleep, actualWakeTime, ...
%   actualWake, sleepDuration, meanDuration, stdDev);
% crc_ara_saveXLS(wakeDate, sleepDate);

