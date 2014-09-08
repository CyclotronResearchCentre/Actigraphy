function stat_res = crc_ara_compScStat(SW, trueSW, displayCM)
%
% Compare 2 scoring, manual (reference) and automatic, then report some
% statistical values.
%
% INPUT:
% - SW     : automatic SW scoring
% - trueSW : "true" SW scoring
% - displayCM : plot the confusion matrix or not [def=false])
% 
% OUTPUT:
% - stat_res : a structure containing the fields:
%   . CM          : confusion matrix
%   . errorRate   : overall error rate
%   . sensitivity : sensitivity of awake detection
%   . specificity : specificity of awake detection
%   . kappa       : Kappa coeficient of agreement
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium


strline = '--------------------------';

%% Confusion matrix
% True positive if SW == AWAKE and trueSW == AWAKE
confusionMatrix = confusionmat(~SW, ~trueSW);

if displayCM == true
    % Plot the confusion matrix
    figure;
    annotation('textbox', [0.2, 0.8, 0.4, 0.2], 'String', 'AWAKE', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
    annotation('textbox', [0.6, 0.8, 0.4, 0.2], 'String', 'ASLEEP',  ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
    annotation('textbox', [0, 0.4, 0.2, 0.4], 'String', 'AWAKE',  ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
    annotation('textbox', [0, 0, 0.2, 0.4], 'String', 'ASLEEP',  ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
    
    annotation('textbox', [0.2, 0.4, 0.4, 0.4], ...
        'String', num2str(confusionMatrix(1, 1)),  ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
    annotation('textbox', [0.6, 0.4, 0.4, 0.4], ...
        'String', num2str(confusionMatrix(1, 2)),  ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
    annotation('textbox', [0.2, 0, 0.4, 0.4], ...
        'String', num2str(confusionMatrix(2, 1)),  ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
    annotation('textbox', [0.6, 0, 0.4, 0.4], ...
        'String', num2str(confusionMatrix(2, 2)),  ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', [1 1 1]);
end;

% Computes some interesting parameters
errorRate = sum(SW ~= trueSW) / length(SW);
sensitivity = confusionMatrix(1, 1) / sum(confusionMatrix(1, :)); % TP / P
specificity = confusionMatrix(2, 2) / sum(confusionMatrix(2, :)); % TN / N
% precision = confusionMatrix(1, 1) / sum(confusionMatrix(:, 1)); % TP / (TP + FP)

fprintf('%s \n', strline);
fprintf('Error rate  : %2.2f%% \n', 100*errorRate);
fprintf('Sensitivity : %2.2f%% \n', 100*sensitivity);
fprintf('Specificity : %2.2f%% \n', 100*specificity);
% fprintf('Precision: %f \n ', precision);
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

stat_res = struct( ...
    'CM', confusionMatrix, ...
    'errorRate', errorRate, ...
    'sensitivity', sensitivity, ...
    'specificity', specificity, ...
    'kappa', kappa);

end
