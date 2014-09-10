function [SW, data, trueV, stat_anaRes, stat_compRes] = crc_ara_compIndiv(fn_dat,dis_opt)
%
% FORMAT [SW, data, trueV, stat_anaRes, stat_compRes] = crc_ara_compIndiv(fn_dat,dis_opt)
%
% Processes a single actigraphy files and compares it with a "ground truth"
% coming from an Excell file, from manual scoring.
%
% INPUT
% - fn_dat  : filename of data to process
% - dis_opt : display comparaison or not [def. true]
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
% - trueV    : a structure containing the true values
%   . trueSW, true sleep/wake series generated from the true sleep &
%             wake times
%   . bedDate, bed times
%   . upDate, up times
%   . sleepDate, sleep times
%   . wakeDate wake times
% - stat_anaRes  : some processed results, if requested. Otherwise [].
% - stat_compRes : stats from the comparison between manual and automatic
%                  scoring
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

if nargin<2, dis_opt = true; end

%% Read in the ACTI data
[subjName, ACTI, nbDays, resolution, startTime, t] = crc_ara_getData(fn_dat);
% Sometimes the signal begins "too early" with a lot of 0 values
%  -> they are removed
[ACTI, startTime, t] = crc_ara_preprocessing(ACTI, startTime, t, resolution);
% Remove "long zeros" (actigraph removed by the subject)
ACTI = crc_ara_removeZeros(ACTI);

% Create data structure
data = struct('ACTI', ACTI, ...
    'resolution', resolution, ...
    'nbDays', nbDays, ...
    'startTime', startTime, ...
    't', t, ...
    'subjName', subjName, ...
    'fn_dat', fn_dat);
nbDataPerDay = (60*60*24) / data.resolution;

%% Retrieve the values from the manual scoring
[pth,fn,ext] = fileparts(fn_dat);
def_xls = crc_ara_get_defaults('xls');
fn_xls = fullfile(pth,[fn,def_xls.fn_append,def_xls.ext]);
if exist(fn_xls,'file')~=2
    error('CRC_ara:xls','XLSX reference file does not seem to exist');
end
[trueV] = crc_ara_getTrueValues(fn_xls, numel(ACTI), ...
    startTime, nbDataPerDay);
% - trueV : structure containing the following fields
%   . trueSW, true sleep/wake series generated from the true sleep &
%             wake times
%   . bedDate, bed times
%   . upDate, up times
%   . sleepDate, sleep times
%   . wakeDate wake times

% Sometime, all the nights weren't scored manually, so they need
% to be removed from ACTI and trueSW
[data, trueV] = crc_ara_modifyLength(data, trueV);

%% Process the individual file!
option = struct('dispActiSW', false, ... % Display SW and ACTI time series
    'dispSpirSW', false, ... % Display SW on circle
    'dispSpirAC', false); % Display ACTI data on circle
[SW, data, stat_anaRes] = crc_ara_processIndiv(data, option); %#ok<*NASGU,*ASGLU>

%% Compare the scoring
[stat_compRes] = crc_ara_compScStat(SW, trueV.trueSW, true);
if dis_opt
    crc_ara_plotSW(subjName, data.ACTI, SW, data.resolution, data.t, ...
        trueV.trueSW, data.subjName);
    crc_ara_plotCircle(SW, data.startTime, nbDataPerDay, data.ACTI, ...
        trueV.trueSW, data.subjName);
end

end