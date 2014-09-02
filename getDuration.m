function [duration] = getDuration(sleepDate, wakeDate)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

duration = zeros(1, length(sleepDate));

for i = 1:length(sleepDate)
    duration(i) = wakeDate(i) - sleepDate(i);
end;

end