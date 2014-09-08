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

    % Read in the ACTI data
    [subjName, ACTI, nbDays, resolution, startTime, t] = crc_ara_getData(fn_ii);
    % Create data structure
    data = struct('ACTI',ACTI, ...
        'resolution',resolution, ...
        'nbDays',nbDays, ...
        'startTime',startTime, ...
    	't',t, ...
        'subjName',subjName);
    nbDataPerDay = (60*60*24) / data.resolution;
    
    % Retrieve the values from the manual scoring
    [pth,fn,ext] = fileparts(fn_ii);
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
    [SW, data, trueV] = crc_ara_modifyLength(SW, data, trueV);

    % Process the individual file!
    [SW, data, stat_res] = crc_ara_processIndiv(data); %#ok<*NASGU,*ASGLU>
        
    % Compare the scoring
    [stat_res] = crc_ara_compScStat(SW, trueV.trueSW, true);
    crc_ara_plotCircle(SW, data.startTime, nbDataPerDay, data.ACTI, trueV.trueSW);
    
end

end

%% process_group
function process_group(datafile, nbFiles)


end
