function [ACTI,startTime,t] = crc_ara_preprocessing(ACTI, startTime, t, resolution)
%
% FORMAT [ACTI,startTime,t] = crc_ara_preprocessing(ACTI, startTime, t, resolution)
%
% Function to ensure that the actigraphic data start with some 'wake' time,
%  i.e. some activity. 
% If the ACTI begins with sleep or flat signal (e.g. when actimeter was
% activated too early), it is modified until we reach some activity.
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium


ara_def = crc_ara_get_defaults('preproc');
windowWidth = ara_def.windowWidth ;
threshold = ara_def.threshold ;

index = 1;
while sum(ACTI(index:index+windowWidth) > threshold) <= 3 * windowWidth / 4
    index = index+1;
end

ACTI = ACTI(index+windowWidth:end);
t = t(index+windowWidth:end);
startTime = startTime + (index + windowWidth - 1) * datenum(0, 0, 0, 0, 0, resolution);

end
