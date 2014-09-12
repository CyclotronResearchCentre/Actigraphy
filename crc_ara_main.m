function varargout = crc_ara_main(datafile,option)
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
    return
end

switch(option)
    case 1 % deal with files 1 by 1
        [SW, data, stat_anaRes] = process_indiv(datafile);
        varargout{1} = SW;
        varargout{2} = data;
        varargout{3} = stat_anaRes;
    case 2 % deal with files 1 by 1 and comapre them with some reference
        [SW, data, trueV, trueSW, stat_anaRes, stat_compRes] = ...
            comp_indiv(datafile);
        varargout{1} = SW;
        varargout{2} = data;
        varargout{3} = trueV;
        varargout{4} = stat_anaRes;
        varargout{5} = stat_compRes;       
    case 3 % deal with a group of files and reference for "group stats"
        % Option used to validate and draw conclusions for the 'rapport'.
        stat_grRes = process_group(datafile);
        varargout{1} = stat_grRes;
end;

end

%% SUBFUNCTIONS
%  List of sub-functions used to deal with the 3 modes of operations:
%   - process_indiv
%   - comp_indiv
%   - process_group

%% process_indiv
function [SW, data, stat_anaRes] = process_indiv(datafile)

% Simply loop through all files.
% Saving the results could be done at 2 levels:
% - here, after collecting al the results
% - when processign each file individually in 'crc_ara_processIndiv'
nbFiles = size(datafile, 1);
SW = cell(1,nbFiles);
data = cell(1,nbFiles);
stat_anaRes = cell(1,nbFiles);
for ii=1:nbFiles
    fn_ii = deblank(datafile(ii,:));
    [SW{ii}, data{ii}, stat_anaRes{ii}] = ...
        crc_ara_processIndiv(fn_ii); %#ok<*NASGU,*ASGLU>
end

end

%% comp_indiv
function [SW, data, trueV, trueSW, stat_anaRes, stat_compRes] = comp_indiv(datafile, dis_opt)

if nargin<2, dis_opt = true; end

nbFiles = size(datafile, 1);
SW = cell(1,nbFiles);
trueSW = cell(1,nbFiles);
data = cell(1,nbFiles);
trueV = cell(1,nbFiles);
stat_anaRes = cell(1,nbFiles);
stat_compRes = cell(1,nbFiles);

% Simply loop through all files.
for ii=1:nbFiles
    fn_ii = deblank(datafile(ii,:));
    
    [SW{ii}, data{ii}, trueV{ii}, stat_anaRes{ii}, stat_compRes{ii}] = ...
        crc_ara_compIndiv(fn_ii,dis_opt); %#ok<*NASGU,*ASGLU>
    trueSW{ii} = trueV{ii}.trueSW;
    % With
    % - trueV, a structure containing the true values
    %   . trueSW, true sleep/wake series generated from the true sleep &
    %             wake times
    %   . bedDate, bed times
    %   . upDate, up times
    %   . sleepDate, sleep times
    %   . wakeDate wake times
    % - stat_compRes, a structure containing the fields:
    %   . CM          : confusion matrix
    %   . errorRate   : overall error rate
    %   . sensitivity : sensitivity of awake detection
    %   . specificity : specificity of awake detection
    %   . kappa       : Kappa coeficient of agreement
    
end

end

%% Process_group
function stat_grRes = process_group(datafile)

nbFiles = size(datafile, 1);

% First get the stats from all the comparisons
dis_opt = false;
[SW, data, trueV, trueSW, stat_anaRes, stat_compRes] = ...
    comp_indiv(datafile,dis_opt);

% Compile values
CMs = zeros(2,2,nbFiles);
errorRates = zeros(1, nbFiles);
sensitivities = zeros(1, nbFiles);
specificities = zeros(1, nbFiles);
kappas = zeros(1, nbFiles);
d_tWake = zeros(1, nbFiles);
d_tSleep = zeros(1, nbFiles);

for ii=1:nbFiles
    errorRates(ii) = stat_compRes{ii}.errorRate;
    sensitivities(ii) = stat_compRes{ii}.sensitivity;
    specificities(ii) = stat_compRes{ii}.specificity;
    kappas(ii) = stat_compRes{ii}.kappa;
    CMs(:,:,ii) = stat_compRes{ii}.CM;
    d_tWake(ii) = stat_compRes{ii}.SWtimes.trueSWt.d_tWake;
    d_tSleep(ii) = stat_compRes{ii}.SWtimes.trueSWt.d_tSleep;
end

% Display mean/min/max for errorrate/sensitivity/specificity/kappa/CM
crc_ara_displayResults(errorRates, sensitivities, specificities, ...
    kappas, d_tWake, d_tSleep, CMs);

stat_grRes = struct( ...
    'errorRates', errorRates, ...
    'sensitivities', sensitivities, ...
    'specificities', specificities, ...
    'kappas', kappas, ...
    'CMs', CMs, ...
    'd_tWake', d_tWake, ...
    'd_tSleep', d_tSleep);

% Consider where all SW series are set as sleep/wake/random
% crc_ara_extremeCase(trueSW);

end
