function [fileName, ACTI, nbDays, resolution, startTime, t] = getData(file)
%
% FORMAT [fileName, ACTI, nbDays, resolution, startTime, t] = getData(file)
% 
% Read in the data:
% - fileName   : file name of file (without dir & extension)
% - ACTI       : (raw) actigraphic signal
% - nbDays     : #days of recording
% - resolution : recording resolution (in sec)
% - startTime  : starting time
% - t          : time regressor (Relative time for each day of the
%                acquisition)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

ara_def = crc_get_ara_defaults('acti');
nbSecPerDays = ara_def.nbSecPerDays;
strline = ara_def.strline;

% Opening and reading of the file
[fileName, ACTI, resolution, startTime, nbDays] = readFile(file); %#ok<*NASGU>

% Absolute time of the acquisition
t_abs = startTime + [0:resolution/nbSecPerDays:resolution/nbSecPerDays*(length(ACTI) - 1)];
% Relative time for each day of the acquisition (will be used for the plots)
t = rem(t_abs, 1); 

nbDays = round(length(ACTI) * resolution / nbSecPerDays);

fprintf('%s \n', strline);
fprintf('Number of days : %d \n', nbDays);
fprintf('Start time : %s \n', datestr(startTime));
fprintf('%s \n \n', strline);

end