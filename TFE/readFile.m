function [name ACTI resolution startTime nbDays] = readFile(datafile, ifile)

strline = '--------------------------';


% ! OUVERTURE ET LECTURE DU FICHIER !
filepath = datafile(ifile, :);
[dir name ext] = fileparts(filepath);
fprintf(1, '%s \n', strline);
fprintf(1, 'Processing file : %s \n', name);
fprintf(1, '%s \n\n', strline);
data = readcoglog(filepath); %lecture du fichier

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

%All the actimetric data are put in the array ACTI

ACTI = zeros(1, size(data, 1) - 9);

for i = 9:(size(data, 1))
    ACTI(i) = str2num(data{i}{1});
end;

nbDays = str2num(data{5}{1});
startTime = datenum(data{2}{1}) + datenum(0, 0, 0, str2num(data{3}{1}(1:2)), str2num(data{3}{1}(4:5)), 0); %s (quand l'enregistrement a débuté)



end