function [] = main(option)

% constantes;
datadir = crc_get_ara_defaults('dir.datadir');
ara_def = crc_get_ara_defaults('mode');


if ~nargin
    option = spm_input('Action : ',1,'m','Individual|Comparison|Group', ...
        [ara_def.INDIVIDUAL, ara_def.COMPARISON, ara_def.GROUP],0);
end;

close all;

% origdir = '/home/miguel/Cours/TFE/';
% datadir = fullfile(origdir, 'Actigraphy_TMS');
% origdir = crc_get_ara_defaults('dir.datadir');

% Select the files to be analysed
datafile = spm_select(Inf, '.+\.AWD$', 'Select files ...', [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
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