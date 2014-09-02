function [minutesTheta] = getAngle(slope1, slope2)
%
% FORMAT [minutesTheta] = getAngle(slope1, slope2)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

if slope1 > slope2
    tmp = slope2;
    slope2 = slope1;
    slope1 = tmp;
end;

tanTheta = (slope2 - slope1) / (1 + slope1 * slope2);

theta = atand(tanTheta);

minutesTheta = theta * (1440 / 360);


end