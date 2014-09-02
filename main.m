function [] = main(option,datafile)
%
% FORMAT [] = main(option,datafile)
%
% Launches the main analysis
%
% INPUT
% - mode of operation:
%       . INDIVIDUAL = 1, analysis a series of single files
%       . COMPARISON = 2, analysis and compares with soem ground truth a 
%                         series of single file
%       . GROUP = 3, analysis a series of single files and perform some
%                    group stats
% - datafile : list of files to process
%
% NOTE: to use the file selection GUI, SPM must be installed and set up
% (path defintion!)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

datadir = crc_ara_get_defaults('dir.datadir');
ara_def = crc_ara_get_defaults('mode');

if ~nargin
    button = questdlg('Choose action to perform','Action : ', ...
                'Individual','Comparison','Group','Individual');
    switch button
        case 'Individual', option = ara_def.INDIVIDUAL;
        case 'Comparison', option = ara_def.COMPARISON;
        case 'Group', option = ara_def.GROUP;
    end
end;

close all;

% Select the files to be analysed, if needed
if nargin<2 || isempty(datafile)
    datafile = spm_select(Inf, '.+\.AWD$', 'Select files ',...
        [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
end

if(isempty(datafile))
    nbFiles = 0;
else
    nbFiles = size(datafile, 1);
end;

switch(option)
    case ara_def.INDIVIDUAL
        individual(datafile, nbFiles, option, true);
    case ara_def.COMPARISON
        individual(datafile, nbFiles, option, true);
    case ara_def.GROUP
        group(datafile, nbFiles);
end;


end