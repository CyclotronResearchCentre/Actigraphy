function plotDistribution(meanTime, stdTime, titleStr)

x = linspace(meanTime-5*stdTime, meanTime+5*stdTime, 1000);
xValues = linspace(meanTime-5*stdTime, meanTime+5*stdTime, 10);
y = gaussmf(x, [stdTime, meanTime]);
figure('name', titleStr);
plot(x, y);

meanStr = strcat('Mean : ', datestr(meanTime, 15));
text(x(550) + 0.01, y(550), meanStr);
stdStr = strcat('Std Dev : ', datestr(stdTime, 15));
text(x(550) + 0.01, y(550) - 0.05, stdStr);

set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(xValues, 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
title(titleStr);


end