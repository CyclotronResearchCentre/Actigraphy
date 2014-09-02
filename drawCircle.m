function drawCircle(xyCenter, r, ang, color_opt)
%
% FORMAT drawCircle(xyCenter, r, ang, color)
%
% Plot lines in polar coordinates around a centre
%
% INPUT:
% - xyCenter  : [X Y] coord of centre
% - r         : radius or vector of radii
% - and       : angle or vector of angles
% - color_opt : color to use and other plot option
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

x = xyCenter(1) + r .* cos(ang);
y = xyCenter(2) + r .* sin(ang);

plot(x, y, color_opt);

end