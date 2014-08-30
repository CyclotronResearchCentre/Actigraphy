function plotSWReport(fileName, ACTI, SW, trueSW, resolution, t)

if isempty(trueSW)
    nbPlots = 2;
else
    nbPlots = 4;
end;

modelFunction = @(params, r) params(1) * sin(params(2) * r + params(3));
paramInit = [1 0.005 0];
r = 1:length(ACTI);

functionParams = nlinfit(r, SW, modelFunction, paramInit);


% ! AFFICHAGE GRAPHIQUE DONNEES BRUTES ET SW ET BED/UP TIMES !

constantes;

xValues = 1:1*3600/resolution:length(t); %1 value every 3h
yValues = 0:500:3000;

figure('name', fileName);
ax(1) = subplot(nbPlots, 1, 1);
% set(gcf,'Position', [30 50 1200 650]);
% clf;
hold on;

%Plot Raw data
plot(ACTI, 'm');
i = 1;
while i < length(SW);
    state = SW(i);
    begin = i;
    
    while i < length(SW) && SW(i) == state
        i = i + 1;
    end;
    
    stop = i;
    if state == AWAKE || state == ASLEEP
        x = [begin + 60 begin + 60 stop - 60 stop - 60];
        y = [0 4000 4000 0];
        fill(x, y, 'b');
        h = findobj(gca, 'Type', 'patch');
        set(h, 'FaceColor', 'g', 'EdgeColor', 'w', 'facealpha', 0.55);
    end;
    
end;

title(strcat('Raw data'));
xlabel('Time');
set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(t(xValues), 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
set(gca, 'YTick', yValues);

%Plot the SW from the algorithm
ax(2) = subplot(nbPlots, 1, 2);
bar(SW);
hold on;
sinusoid = modelFunction(functionParams, r) + functionParams(1);
%plot(sinusoid / max(sinusoid), 'r');
hold off;
title('Estimated sleep-wake');
xlabel('Time');
set(gca,'XTick', xValues);
set(gca,'XTickLabel', datestr(t(xValues),15), 'FontSize', 6);
set(gca, 'YTick', [0 1]);

figure;
plot(ACTI(1:5), 'm');

figure;
plot(ACTI(6:10), 'm');

figure;
plot(ACTI(11:15), 'm');

figure;
plot(ACTI(16:20), 'm');

if nbPlots == 4
    %plot the SW from the scorer
    ax(3) = subplot(nbPlots, 1, 3);
    bar(trueSW);
    title('True sleep-wake');
    xlabel('Time');
    set(gca,'XTick', xValues);
    set(gca,'XTickLabel', datestr(t(xValues),15), 'FontSize', 6);
    set(gca, 'YTick', [0 1]);


    ax(4) = subplot(nbPlots, 1, 4);
    diff = SW ~= trueSW;
    bar(diff, 'r');
    title('Differences');
    xlabel('Time');
    set(gca,'XTick', xValues);
    set(gca,'XTickLabel', datestr(t(xValues),15), 'FontSize', 6);
    set(gca, 'YTick', [0 1]);
end;

if nbPlots == 2
    linkaxes([ax(1) ax(2)], 'x');
else
    linkaxes([ax(1) ax(2) ax(3) ax(4)], 'x');
end;

end