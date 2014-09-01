function [fileName ACTI nbDays resolution startTime t] = getData(file)

constantes

% ! OUVERTURE ET LECTURE DU FICHIER !
[fileName ACTI resolution startTime nbDays] = readFile(file);

%Absolute time of the acquisition
t_abs = startTime + [0:resolution/nbSecPerDays:resolution/nbSecPerDays*(length(ACTI) - 1)];
%Relative time for each day of the acquisition (will be used for the plots)
t = rem(t_abs, 1); 

nbDays = round(length(ACTI) * resolution / nbSecPerDays);

fprintf('%s \n', strline);
fprintf('Number of days : %d \n', nbDays);
fprintf('Start time : %s \n', datestr(startTime));
fprintf('%s \n \n', strline);

end