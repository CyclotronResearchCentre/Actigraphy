function [fileName, ACTI, nbDays, resolution, startTime, t] = crc_ara_getData(file)
%
% FORMAT [fileName, ACTI, nbDays, resolution, startTime, t] = crc_ara_getData(file)
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

nbSecPerDays = 24*60*60;
strline = '--------------------------';

% Opening and reading of the file
[fileName, ACTI, resolution, startTime, nbDays] = readFile(file); %#ok<*NASGU>

% Absolute time of the acquisition
t_abs = startTime + ...
    (0:resolution/nbSecPerDays:resolution/nbSecPerDays*(length(ACTI) - 1));
% Relative time for each day of the acquisition (will be used for the plots)
t = rem(t_abs, 1); 

nbDays = round(length(ACTI) * resolution / nbSecPerDays);

fprintf('%s \n', strline);
fprintf('Number of days : %d \n', nbDays);
fprintf('Start time : %s \n', datestr(startTime));
fprintf('%s \n \n', strline);

end

%% SUBFUNCTIONS
% List of sub-functions used to read in the data:
% - readFile
% - readActi

%% readFile
function [name, ACTI, resolution, startTime, nbDays] = readFile(file)
%
% FORMAT [name, ACTI, resolution, startTime, nbDays] = readFile(file)
% 
% Read in the data:
% - name       : file name of file (without dir & extension)
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
fprintf(1, 'Reading file : %s \n', name);
fprintf(1, '%s \n\n', strline);

% Reads the file
data = readActi(file);

% Get key info
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
nbDays = str2double(data{5});
startTime = datenum(data{2}) + ...
    datenum(0,0,0,str2double(data{3}(1:2)), str2double(data{3}(4:5)),0);

% The first nine data cells from the file are technical stuff 
% -> not included in ACTI
ACTI = zeros(1, length(data) - 9);
% All the actimetric data are put in the array ACTI
for i = 9:(length(data))
    ACTI(i) = str2double(data{i});
end;

end

%% readActi
function [data] = readActi(fileName)
%
% FORMAT [data] = readActi(fileName)
% 
% Breaks every line in words and puts everything in the array data
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

fid = fopen(fileName);
tmp = textscan(fid, '%s','delimiter','\n','whitespace','');
fclose(fid);
data = tmp{1}';


end