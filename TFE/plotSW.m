function plotSW(fileName, ACTI, SW, startTime, bedTime, upTime, nbDataPerDays)

% ! AFFICHAGE GRAPHIQUE DONNEES BRUTES ET SW ET BED/UP TIMES !

constantes

i = 1:length(ACTI);

subplot(4, 1, 1)
% set(gcf,'Position', [30 50 1200 650]);
% clf;
hold on;

%Plot Raw data
plot(i, ACTI, 'm');

%Plot a vertical line at estimated bed time
for j = 1:length(bedTime)
    %plot(linspace(double((bedTime(j) - startTime) * nbDataPerDays), double((bedTime(j) - startTime) * nbDataPerDays), length(ACTI)), linspace(0, 10000, length(ACTI)), 'k');
end;

%Plot a vertical line at estimated up time
for j = 1:length(upTime)
    %plot(linspace(double((upTime(j) - startTime) * nbDataPerDays), double((upTime(j) - startTime) * nbDataPerDays), length(ACTI)), linspace(0, 10000, length(ACTI)), 'k');
end;

%Plot the S-W values
%plot(i, 1000 * SW, 'b');
title(fileName, 'interpreter', 'none');

%Plot the SW from the algorithm
subplot(4, 1, 2)
bar(SW);

%plot the SW from the scorer
startDate = startTime - mod(startTime, 1);
[bedDate upDate sleepDate wakeDate] = convertXLS(fileName, startDate);

scoreSW = zeros(length(ACTI), 1);
state = AWAKE;

sleepIndex = 1;
wakeIndex = 1;

for i = 1:length(ACTI)
    if sleepIndex <= length(sleepDate) && startTime > sleepDate(sleepIndex)
        state = ASLEEP;
        sleepIndex = sleepIndex + 1;
    end;
    
    if wakeIndex <= length(wakeDate) && startTime > wakeDate(wakeIndex)
        state = AWAKE;
        wakeIndex = wakeIndex + 1;
    end;
    
    scoreSW(i) = state;
    startTime = startTime + 1 / nbDataPerDays;
end;

subplot(4, 1, 3)
bar(scoreSW);

subplot(4, 1, 4)
diff = SW ~= scoreSW;
bar(diff, 'r');

end