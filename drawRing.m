function [x y] = drawRing(xCenter, yCenter, r, ang, color)

x = xCenter + r * cos(ang);
y = yCenter + r * sin(ang);

plot(x, y, [color 'o']);

end