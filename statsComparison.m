function statsComparison(SW, trueSW, wakeDate, trueWakeDate, sleepDate, trueSleepDate)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

%% Confusion matrix

%True positive if SW == AWAKE and trueSW == AWAKE
confusionMatrix = confusionmat(~SW, ~trueSW);

% Plot the confusion matrix
figure;
annotation('textbox', [0.2, 0.8, 0.4, 0.2], 'String', 'AWAKE', 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.6, 0.8, 0.4, 0.2], 'String', 'ASLEEP', 'BackgroundColor', [1 1 1]);
annotation('textbox', [0, 0.4, 0.2, 0.4], 'String', 'AWAKE', 'BackgroundColor', [1 1 1]);
annotation('textbox', [0, 0, 0.2, 0.4], 'String', 'ASLEEP', 'BackgroundColor', [1 1 1]);

annotation('textbox', [0.2, 0.4, 0.4, 0.4], 'String', num2str(confusionMatrix(1, 1)), 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.6, 0.4, 0.4, 0.4], 'String', num2str(confusionMatrix(1, 2)), 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.2, 0, 0.4, 0.4], 'String', num2str(confusionMatrix(2, 1)), 'BackgroundColor', [1 1 1]);
annotation('textbox', [0.6, 0, 0.4, 0.4], 'String', num2str(confusionMatrix(2, 2)), 'BackgroundColor', [1 1 1]);

% Computes some interesting parameters
errorRate = sum(SW ~= trueSW) / length(SW);
sensitivity = confusionMatrix(1, 1) / sum(confusionMatrix(1, :)); % TP / P
specificity = confusionMatrix(2, 2) / sum(confusionMatrix(2, :)); % TN / N
precision = confusionMatrix(1, 1) / sum(confusionMatrix(:, 1)); % TP / (TP + FP) 

fprintf('Error rate : %f \n', errorRate);
fprintf('Sensitivity : %f \n', sensitivity);
fprintf('Specificity : %f \n', specificity);
fprintf('Precision: %f \n \n', precision);

%% Cohen's kappa

Pra = (confusionMatrix(1, 1) + confusionMatrix(2, 2)) / length(SW);
Pre = (sum(confusionMatrix(1, :)) / length(SW)) * (sum(confusionMatrix(:, 1)) / length(SW));
Pre = Pre + (sum(confusionMatrix(2, :)) / length(SW)) * (sum(confusionMatrix(:, 2)) / length(SW));

kappa = (Pra - Pre) / (1 - Pre);

fprintf('Kappa : %f \n', kappa);
fprintf('Adjusted kappa : %f \n\n', 2 * kappa - 1);

%% Pearson

[rho, pvalue] = corr(wakeDate', trueWakeDate');
fprintf('Test de Pearson sur les heures de lever seules \n');
fprintf('rho : %f \n', rho);
fprintf('p-value : %f \n', pvalue);

[rho, pvalue] = corr(sleepDate', trueSleepDate');
fprintf('Test de Pearson sur les heures de coucher seules \n');
fprintf('rho : %f \n', rho);
fprintf('p-value : %f \n\n', pvalue);

%% t-test
% 
% 
% %t-test sur les heures de lever seules
% [H pvalue] = ttest(wakeDate - trueWakeDate);
% 
% fprintf('t-test sur les heures de lever seules \n');
% fprintf('p-value (t-test) : %f \n', pvalue);
% 
% %t-test sur les heures de coucher seules
% [H pvalue] = ttest(sleepDate, trueSleepDate);
% 
% fprintf('t-test sur les heures de coucher seules \n');
% fprintf('p-value (t-test) : %f \n', pvalue);

%% Mean and variance of the error between the estimated sleep-wake times and the true ones

wakeError = abs(wakeDate - trueWakeDate);
sleepError = abs(sleepDate - trueSleepDate);

meanWakeError = mean(wakeError);
meanSleepError = mean(sleepError);

stdDevWakeError = std(wakeError);
stdDevSleepError = std(sleepError);

fprintf('Mean Wake Error : %s hour(s) and %s minute(s) \n', datestr(meanWakeError, 'HH'), datestr(meanWakeError, 'MM'));
fprintf('Standard Deviation Wake Error : %s hour(s) and %s minute(s) \n', datestr(stdDevWakeError, 'HH'), datestr(stdDevWakeError, 'MM'));
fprintf('Mean Sleep Error : %s hour(s) and %s minute(s) \n', datestr(meanSleepError, 'HH'), datestr(meanSleepError, 'MM'));
fprintf('Standard Deviation Sleep Error : %s hour(s) and %s minute(s) \n\n', datestr(stdDevSleepError, 'HH'), datestr(stdDevSleepError, 'MM'));

end