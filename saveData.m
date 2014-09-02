function [error] = saveData(fileName, sleepTime, wakeTime, bedTime, upTime, assumedSleepTime, actualSleepTime, actualSleep, actualWakeTime, actualWake, sleepDuration, meanDuration, stdDev)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

error = 0;
fileName = [fileName '_ExtractedData'];
file = fopen(fileName, 'w');

for i = 1:length(sleepTime)
    fprintf(file, 'Day %d -- ', i);
    fprintf(file, 'Sleep Time : %s - ', datestr(sleepTime(i)));
    fprintf(file, 'Bed Time : %s - ', datestr(bedTime(i)));
    fprintf(file, 'Wake Time : %s - ', datestr(wakeTime(i)));
    fprintf(file, 'Up Time : %s - ', datestr(upTime(i)));
    fprintf(file, 'Assumed Sleep : %s - ', datestr(assumedSleepTime(i)));
    fprintf(file, '\n');
end;


fclose(file);

end