function [minutesTheta] = getAngle(slope1, slope2)

if slope1 > slope2
    tmp = slope2;
    slope2 = slope1;
    slope1 = tmp;
end;

tanTheta = (slope2 - slope1) / (1 + slope1 * slope2);

theta = atand(tanTheta);

minutesTheta = theta * (1440 / 360);


end