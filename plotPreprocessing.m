function plotPreprocessing(fileName, ACTI, SW, x, xf, y1, resolution, t)

constantes;

xValues = 1:1*3600/resolution:length(t); %1 value every 3h
yValues = 0:500:3000;

figure('name', fileName);
ax(1) = subplot(5, 1, 1);
plot(ACTI, 'm');
title('Raw data');
xlabel('Time');
set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(t(xValues), 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
set(gca, 'YTick', yValues);

ax(2) = subplot(5, 1, 2);
plot(x, 'm');
title('x');
xlabel('Time');
set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(t(xValues), 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
set(gca, 'YTick', yValues);

ax(3) = subplot(5, 1, 3);
plot(xf, 'm');
title('xf');
xlabel('Time');
set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(t(xValues), 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
set(gca, 'YTick', yValues);

ax(4) = subplot(5, 1, 4);
bar(y1);
title('y_1');
xlabel('Time');
set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(t(xValues), 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
set(gca, 'YTick', yValues);

ax(5) = subplot(5, 1, 5);
bar(SW);
title('y_e');
xlabel('Time');
set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(t(xValues), 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
set(gca, 'YTick', 0:1);


linkaxes([ax(1) ax(2) ax(3) ax(4) ax(5)], 'x');

end