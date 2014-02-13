function plotSW(fileName, ACTI, SW, trueSW)

% ! AFFICHAGE GRAPHIQUE DONNEES BRUTES ET SW ET BED/UP TIMES !

constantes

i = 1:length(ACTI);

subplot(4, 1, 1)
% set(gcf,'Position', [30 50 1200 650]);
% clf;
hold on;

%Plot Raw data
plot(i, ACTI, 'm');
title(fileName, 'interpreter', 'none');

%Plot the SW from the algorithm
subplot(4, 1, 2)
bar(SW);

%plot the SW from the scorer


subplot(4, 1, 3)
bar(trueSW);

subplot(4, 1, 4)
diff = SW ~= trueSW;
bar(diff, 'r');

end