function saveXLS(fileName, wakeDate, sleepDate)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

if str2num(datestr(sleepDate(1), 'HH')) < 12
    day = datenum(0, 0, 1, 0, 0, 0);
    startDateStr = datestr((sleepDate(1) - day), 'ddmmyyyy');
else
    startDateStr = datestr(sleepDate(1), 'ddmmyyyy');
end

sleepDateStr = datestr(sleepDate, 'HHMM');
wakeDateStr = datestr(wakeDate, 'HHMM');
nbValues = length(sleepDate);

values = zeros(3, nbValues);

values(1, 1) = str2num(startDateStr);
values(1, 2:end) = NaN;

values(2, :) = str2num(sleepDateStr);
values(3, :) = str2num(wakeDateStr);

%xlswrite(fileName, values);

end