function stats(SW, trueSW, wakeDate, trueWakeDate, sleepDate, trueSleepDate)

%% Confusion matrix

%True positive if SW == AWAKE and trueSW == AWAKE
confusionMatrix = confusionmat(~SW, ~trueSW);

figure;
annotation('textbox', [0.2, 0.8, 0.4, 0.2], 'String', 'Positive', 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.6, 0.8, 0.4, 0.2], 'String', 'Negative', 'BackgroundColor', [1 1 1]);
annotation('textbox', [0, 0.4, 0.2, 0.4], 'String', 'Positive', 'BackgroundColor', [1 1 1]);
annotation('textbox', [0, 0, 0.2, 0.4], 'String', 'Negative', 'BackgroundColor', [1 1 1]);

annotation('textbox', [0.2, 0.4, 0.4, 0.4], 'String', num2str(confusionMatrix(1, 1)), 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.6, 0.4, 0.4, 0.4], 'String', num2str(confusionMatrix(1, 2)), 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.2, 0, 0.4, 0.4], 'String', num2str(confusionMatrix(2, 1)), 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.6, 0, 0.4, 0.4], 'String', num2str(confusionMatrix(2, 2)), 'BackgroundColor', [1 1 1]);

errorRate = sum(SW ~= trueSW) / length(SW);
sensitivity = confusionMatrix(1, 1) / sum(confusionMatrix(1, :)); % TP / P
specificity = confusionMatrix(2, 2) / sum(confusionMatrix(2, :)); % TN / N
precision = confusionMatrix(1, 1) / sum(confusionMatrix(:, 1)); % TP / (TP + FP) 

fprintf('Error rate : %f \n', errorRate);
fprintf('Sensitivity : %f \n', sensitivity);
fprintf('Specificity : %f \n', specificity);
fprintf('Precision: %f \n \n', precision);


%% t-test

%t-test sur les données entières
[H pvalue] = ttest(SW - trueSW);

fprintf('t-test sur les données entières \n');
fprintf('p-value (t-test) : %f \n', pvalue);

%t-test sur les heures de lever seules
[H pvalue] = ttest(wakeDate - trueWakeDate);

fprintf('t-test sur les heures de lever seules \n');
fprintf('p-value (t-test) : %f \n', pvalue);

%t-test sur les heures de coucher seules
[H pvalue] = ttest(sleepDate, trueSleepDate);

fprintf('t-test sur les heures de coucher seules \n');
fprintf('p-value (t-test) : %f \n', pvalue);


end