function [name, ACTI, resolution, startTime, nbDays] = readFile(file)
%
% FORMAT [name, ACTI, resolution, startTime, nbDays] = readFile(file)
% 
% Read in the data:
% - ame   : file name of file (without dir & extension)
% - ACTI       : (raw) actigraphic signal
% - resolution : recording resolution (in sec)
% - startTime  : starting time
% - nbDays     : #days of recording
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium



strline = '--------------------------';

% Opens the file
[dir, name, ext] = fileparts(file); %#ok<*NASGU,*ASGLU>
fprintf(1, '%s \n', strline);
fprintf(1, 'Processing file : %s \n', name);
fprintf(1, '%s \n\n', strline);

% Reads the file
data = readActi(file);

% switch(str2double(data{4}{1}))
switch(str2double(data{4}))
    case 2
        resolution = 30; %s
    case 4
        resolution = 60; %s
    case 8
        resolution = 120; %s
    case 20
        resolution = 300; %s
end;


% The nine first data from the file are technical stuff -> not included in ACTI
ACTI = zeros(1, length(data) - 9);

% All the actimetric data are put in the array ACTI
for i = 9:(length(data))
%     ACTI(i) = str2double(data{i}{1});
    ACTI(i) = str2double(data{i});
end;

% nbDays = str2double(data{5}{1});
nbDays = str2double(data{5});


% startTime = datenum(data{2}{1}) + datenum(0, 0, 0, str2double(data{3}{1}(1:2)), str2double(data{3}{1}(4:5)), 0);
startTime = datenum(data{2}) + datenum(0, 0, 0, str2double(data{3}(1:2)), str2double(data{3}(4:5)), 0);

end