function circle(xyCenter, r, ang, color)
%
% FORMAT circle(xCenter, yCenter, r, ang, color)
%
% Plot things in polar coordinates
%
% INPUT:
% - xyCenter : [X Y] coord of centre
% - r        : radius or vector of radii
% - and      : angle or vector of angles
% - color    : color to use
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

x = xyCenter(1) + r .* cos(ang);
y = xyCenter(2) + r .* sin(ang);

plot(x, y, color);

end