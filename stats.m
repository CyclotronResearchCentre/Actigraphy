function [stat_res,stat_cmp] = stats(SW, wakeDate, sleepDate, sleepDuration, trueSW, trueWakeDate, trueSleepDate, displayPlot)
%
% errorRate, sensitivity, specificity, kappa, meanWakeError, stdWakeError, meanSleepError, stdSleepError
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

constantes;
strline = '--------------------------';

%% Initialize the output variables
errorRate = -1;
sensitivity = -1;
specificity = -1;
kappa = -1;
meanWakeError = -1;
stdWakeError = -1;
meanSleepError = -1;
stdSleepError = -1;

wakeTime = mod(wakeDate, 1); %Get the time out of the date
sleepTime = mod(sleepDate, 1);

sleepTime(sleepTime>0.5) = sleepTime(sleepTime>0.5) - 1;

meanWakeTime = mean(wakeTime);
stdWakeTime = std(wakeTime);
meanSleepTime = mean(sleepTime);
stdSleepTime = std(sleepTime);
meanDuration = mean(sleepDuration);
stdDuration = std(sleepDuration);

meanWakeTimeStr = datestr(meanWakeTime, 'HH:MM');
stdWakeTimeStr = datestr(stdWakeTime, 'HH:MM');
meanSleepTimeStr = datestr(meanSleepTime, 'HH:MM');
stdSleepTimeStr = datestr(stdSleepTime, 'HH:MM');

fprintf('%s \n', strline);
fprintf('Mean Wake Time : %s \n', meanWakeTimeStr);
fprintf('Std Dev Wake Time : %s \n', stdWakeTimeStr);
fprintf('Mean Sleep Time : %s \n', meanSleepTimeStr);
fprintf('Std Dev Sleep Time : %s \n', stdSleepTimeStr);
fprintf('%s \n \n', strline);

% if displayPlot == true
%     plotDistribution(meanWakeTime, stdWakeTime, 'Wake time Distribution');
%     plotDistribution(meanSleepTime, stdSleepTime, 'Sleep time Distribution');
%     plotDistribution(meanDuration, stdDuration, 'Sleep Duration Distribution');
% end;


if ~isempty(trueSW)
    %% Confusion matrix
    
    %True positive if SW == AWAKE and trueSW == AWAKE
    confusionMatrix = confusionmat(~SW, ~trueSW);
    
    if displayPlot == true
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
    end;
    
    % Computes some interesting parameters
    errorRate = sum(SW ~= trueSW) / length(SW);
    sensitivity = confusionMatrix(1, 1) / sum(confusionMatrix(1, :)); % TP / P
    specificity = confusionMatrix(2, 2) / sum(confusionMatrix(2, :)); % TN / N
    precision = confusionMatrix(1, 1) / sum(confusionMatrix(:, 1)); % TP / (TP + FP)
    
    fprintf('%s \n', strline);
    fprintf('Error rate : %f \n', errorRate);
    fprintf('Sensitivity : %f \n', sensitivity);
    fprintf('Specificity : %f \n', specificity);
    fprintf('Precision: %f \n ', precision);
    fprintf('%s \n \n', strline);
    
    %% Cohen's kappa
    
    Pra = (confusionMatrix(1, 1) + confusionMatrix(2, 2)) / length(SW);
    Pre = (sum(confusionMatrix(1, :)) / length(SW)) * (sum(confusionMatrix(:, 1)) / length(SW));
    Pre = Pre + (sum(confusionMatrix(2, :)) / length(SW)) * (sum(confusionMatrix(:, 2)) / length(SW));
    
    kappa = (Pra - Pre) / (1 - Pre);
    
    fprintf('%s \n', strline);
    fprintf('Kappa : %f \n', kappa);
    fprintf('Adjusted kappa : %f \n', 2 * kappa - 1);
    fprintf('%s \n \n', strline);
    
    %%All the stuff below is certainly useless (and wrong...)
    %% Pearson (min - max - median - Wilkinson test)
    
%     [rho, pvalue] = corr(wakeDate', trueWakeDate');
%     fprintf('%s \n', strline);
%     fprintf('Test de Pearson sur les heures de lever seules \n');
%     fprintf('rho : %f \n', rho);
%     fprintf('p-value : %f \n', pvalue);
%     
%     [rho, pvalue] = corr(sleepDate', trueSleepDate');
%     fprintf('Test de Pearson sur les heures de coucher seules \n');
%     fprintf('rho : %f \n', rho);
%     fprintf('p-value : %f \n', pvalue);
%     fprintf('%s \n \n', strline);
    
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
    
%     wakeError = abs(wakeDate - trueWakeDate);
%     sleepError = abs(sleepDate - trueSleepDate);
%     
%     meanWakeError = mean(wakeError);
%     meanSleepError = mean(sleepError);
%     
%     stdWakeError = std(wakeError);
%     stdSleepError = std(sleepError);
%     
%     fprintf('%s \n', strline);
%     fprintf('Mean Wake Error : %s hour(s) and %s minute(s) \n', datestr(meanWakeError, 'HH'), datestr(meanWakeError, 'MM'));
%     fprintf('Standard Deviation Wake Error : %s hour(s) and %s minute(s) \n', datestr(stdWakeError, 'HH'), datestr(stdWakeError, 'MM'));
%     fprintf('Mean Sleep Error : %s hour(s) and %s minute(s) \n', datestr(meanSleepError, 'HH'), datestr(meanSleepError, 'MM'));
%     fprintf('Standard Deviation Sleep Error : %s hour(s) and %s minute(s) \n\n', datestr(stdSleepError, 'HH'), datestr(stdSleepError, 'MM'));
%     fprintf('%s \n \n', strline);
end;

end