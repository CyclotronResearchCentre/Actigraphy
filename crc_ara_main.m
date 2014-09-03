function [] = crc_ara_main(datafile,option)
%
% FORMAT [] = crc_ara_main(datafile,option)
%
% Launches the main analysis
%
% INPUT
% - datafile : list of files to process, if not use spm_select
% - optin    : mode of operation:
%       . 1, analysis a series of single files (INDIVIDUAL)[default]
%       . 2, analysis and compares with soem ground truth a 
%            series of single file (COMPARISON)
%       . 3, analysis a series of single files and perform some
%            group stats (GROUP)
%
% NOTE: to use the file selection GUI, SPM must be installed and set up
% (path defintion!)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium


if nargin<2, option = 1; end

% Select the files to be analysed, if needed
if nargin<1 || isempty(datafile)
    datadir = crc_ara_get_defaults('dir.datadir');
    datafile = spm_select(Inf, '.+\.AWD$', 'Select files ',...
        [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
end

if isempty(datafile)
    nbFiles = 0;
else
    nbFiles = size(datafile, 1);
end;

switch(option)
    case 1 % deal with files 1 by 1
        process_indiv(datafile, nbFiles);
    case 2 % deal with files 1 by 1 and comapre them with some reference
        comp_indiv(datafile, nbFiles);
    case 3 % deal with a group of files and reference for "group stats"
        % Option used to validate and draw conclusions for the 'rapport'.
        process_group(datafile, nbFiles);
end;

end

%% SUBFUNCTIONS
%  List of sub-functions used to deal with the 3 modes of operations:
%   - process_indiv
%   - comp_indiv
%   - process_group

%% process_indiv
function process_indiv(datafile, nbFiles)

% Simply loop through all files.
% Saving the results could be done at 2 levels:
% - here, after collecting al the results
% - when processign each file individually in 'crc_ara_processIndiv'
for ii=1:nbFiles
    fn_ii = deblank(datafile(ii,:));
    [SW, data, stat_res] = crc_ara_processIndiv(fn_ii); %#ok<*NASGU,*ASGLU>
end

end

%% comp_indiv
function comp_indiv(datafile, nbFiles)

% Simply loop through all files.
for ii=1:nbFiles
    fn_ii = deblank(datafile(ii,:));

    %Retrieves the values from the manual scoring
    [trueSW, trueBedDate, trueUpDate, trueSleepDate, trueWakeDate] = getTrueValues(fn_ii, ACTI, startTime, nbDataPerDays);
        
    %Sometime, all the nights weren't scored manually, so they need
    %to be removed from ACTI and trueSW
    [ACTI, trueSW, startTime, t] = modifyLength(ACTI, trueSW, startTime, t, resolution);

    % Do the automatic scoring
    [SW, data, stat_res] = crc_ara_processIndiv(fn_ii); %#ok<*NASGU,*ASGLU>

    % Compare the scoring
    [errorRate, sensitivity, specificity, kappa, meanWakeError, stdWakeError, meanSleepError, stdSleepError] = stats(SW, wakeDate, sleepDate, sleepDuration, trueSW, trueWakeDate, trueSleepDate, displayPlot);
        
    stat_res = struct( ...
        'errorRate',      errorRate, ...
        'sensitivity',    sensitivity, ...
        'specificity',    specificity, ...
        'kappa',          kappa, ...
        'meanWakeError',  meanWakeError, ...
        'stdWakeError',   stdWakeError, ...
        'meanSleepError', meanSleepError, ...
        'stdSleepError',  stdSleepError ...
        );

end

end

%% process_group
function process_group(datafile, nbFiles)


end
