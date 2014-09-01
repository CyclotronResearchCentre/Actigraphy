function [] = main(option)

constantes;

if ~nargin
    option = spm_input('Action : ',1,'m','Individual|Comparison|Group',[INDIVIDUAL, COMPARISON, GROUP],0);
end;

close all;

origdir = '/home/miguel/Cours/TFE/';
datadir = fullfile(origdir, 'Actigraphy_TMS');

%Select the files to be analysed
datafile = spm_select(Inf, '.+\.AWD$', 'Select files ...', [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
if(isempty(datafile))
    nbFiles = 0;
else
    nbFiles = size(datafile, 1);
end;

switch(option)
    case INDIVIDUAL
        individual(datafile, nbFiles, option, true);
    case COMPARISON
        individual(datafile, nbFiles, option, true);
    case GROUP
        group(datafile, nbFiles);
end;


end