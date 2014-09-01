function plotSW(fileName, ACTI, SW, resolution, t, trueSW)
%
% FORMAT plotSW(fileName, ACTI, SW, trueSW, resolution, t)
%
% Plot the raw actigraphic data and the sleep/wake cycles.
%
% INPUT:
% - fileName   : data file name (no ext nor dir)
% - ACTI       : rawa ctigraphic data
% - SW         : sleep/wake time series
% - resolution : temporal resolution
% - t          : time regressor for plots
% - trueSW     : true sleep/wake time series, used as reference ([], def)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

if nargin < 6, trueSW = []; end

% If we are in comparison mode, we show 4 subplots
if isempty(trueSW)
    nbPlots = 2;
else
    nbPlots = 4;
end;

% modelFunction = @(params, r) params(1) * sin(params(2) * r + params(3));
% paramInit = [1 0.005 0];
% r = 1:length(ACTI);
% 
% functionParams = nlinfit(r, SW, modelFunction, paramInit);


% ! PLOTS THE RAW ACTIGRAPHIC DATA AND SW AND BED/UP TIMES !

% constantes;

xValues = 1:1*3600/resolution:length(t); % 1 value every 3h
yValues = 0:500:3000;

figure('name', fileName);
ax(1) = subplot(nbPlots, 1, 1);
% set(gcf,'Position', [30 50 1200 650]);
% clf;
hold on;

% Plot Raw data
plot(ACTI, 'm');
title(strcat('Raw data'));
xlabel('Time');
set(gca, 'XTick', xValues);
set(gca, 'XTickLabel', datestr(t(xValues), 15), 'FontSize', 6); %Display the time in 'HH:MM' format for every 'a' displayed
set(gca, 'YTick', yValues);


% Plot the SW from the algorithm
ax(2) = subplot(nbPlots, 1, 2);
bar(SW);
hold on;
% sinusoid = modelFunction(functionParams, r) + functionParams(1);
% plot(sinusoid / max(sinusoid), 'r');
hold off;
title('Estimated sleep-wake');
xlabel('Time');
set(gca,'XTick', xValues);
set(gca,'XTickLabel', datestr(t(xValues),15), 'FontSize', 6);
set(gca, 'YTick', [0 1]);

if nbPlots == 4
    % plot the SW from the scorer
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