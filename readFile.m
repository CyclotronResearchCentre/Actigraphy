function [name ACTI resolution startTime nbDays] = readFile(file)

strline = '--------------------------';


% Opens the file
[dir name ext] = fileparts(file);
fprintf(1, '%s \n', strline);
fprintf(1, 'Processing file : %s \n', name);
fprintf(1, '%s \n\n', strline);

%Reads the file
data = readActi(file);

switch(str2num(data{4}{1}))
    case 2
        resolution = 30; %s
    case 4
        resolution = 60; %s
    case 8
        resolution = 120; %s
    case 20
        resolution = 300; %s
end;


%The nine first data from the file are technical stuff -> not included in ACTI
ACTI = zeros(1, length(data) - 9);

%All the actimetric data are put in the array ACTI
for i = 9:(length(data))
    ACTI(i) = str2num(data{i}{1});
end;

nbDays = str2num(data{5}{1});

%startTime = when the recording started (in s)
startTime = datenum(data{2}{1}) + datenum(0, 0, 0, str2num(data{3}{1}(1:2)), str2num(data{3}{1}(4:5)), 0);



end