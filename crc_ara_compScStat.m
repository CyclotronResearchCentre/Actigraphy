function stat_compRes = crc_ara_compScStat(SW, trueSW, displayRes)
%
% Compare 2 scoring, manual (reference) and automatic, then report some
% statistical values.
%
% INPUT:
% - SW     : automatic SW scoring
% - trueSW : "true" SW scoring
% - displayRes : plot the confusion matrix or not [def=false])
%
% OUTPUT:
% - stat_compRes : a structure containing the fields:
%   . CM          : confusion matrix
%   . errorRate   : overall error rate
%   . sensitivity : sensitivity of awake detection
%   . specificity : specificity of awake detection
%   . kappa       : Kappa coeficient of agreement
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

if nargin<3
    displayRes = false;
end

strline = '--------------------------';

%% Confusion matrix
% True positive if SW == AWAKE and trueSW == AWAKE
confMatrix = confMat(SW, trueSW);

%% Computes some interesting parameters
errorRate = sum(SW ~= trueSW) / length(SW);
sensitivity = confMatrix(1, 1) / sum(confMatrix(1, :)); % TP / P
specificity = confMatrix(2, 2) / sum(confMatrix(2, :)); % TN / N
% precision = confMatrix(1, 1) / sum(confMatrix(:, 1)); % TP / (TP + FP)

%% Cohen's kappa
Pra = (confMatrix(1, 1) + confMatrix(2, 2)) / length(SW);
Pre = (sum(confMatrix(1, :)) / length(SW)) * (sum(confMatrix(:, 1)) / length(SW));
Pre = Pre + (sum(confMatrix(2, :)) / length(SW)) * (sum(confMatrix(:, 2)) / length(SW));
kappa = (Pra - Pre) / (1 - Pre);

stat_compRes = struct( ...
    'CM', confMatrix, ...
    'errorRate', errorRate, ...
    'sensitivity', sensitivity, ...
    'specificity', specificity, ...
    'kappa', kappa);

%% Display things, if requested
if displayRes
    fprintf('%s \n', strline);
    fprintf('|\t\t | Pr. W | Pr. S |\n');
    fprintf('%s \n', strline);
    fprintf('| True W | %5d | %5d |\n', confMatrix(1,1), confMatrix(1,2))
    fprintf('%s \n', strline);
    fprintf('| True S | %5d | %5d |\n', confMatrix(2,1), confMatrix(2,2))
    fprintf('%s \n', strline);
    
    fprintf('%s \n', strline);
    fprintf('Error rate  : %4.2f%% \n', 100*errorRate);
    fprintf('Sensitivity : %4.2f%% \n', 100*sensitivity);
    fprintf('Specificity : %4.2f%% \n', 100*specificity);
    fprintf('Kappa       : %f \n', kappa);
    fprintf('Adj. kappa  : %f \n', 2 * kappa - 1);
    fprintf('%s \n \n', strline);
end

end

%% SUBFUNCTION
% Estimate confusion matrix
function CM = confMat(SW, trueSW)

% True positive if SW == AWAKE and trueSW == AWAKE
CM = zeros(2,2);
CM(1,1) = sum(trueSW==1 & SW==1);
CM(1,2) = sum(trueSW==1 & SW==0);
CM(2,2) = sum(trueSW==0 & SW==0);
CM(2,1) = sum(trueSW==0 & SW==1);

end

%% OLD BITS

% % Plot the confusion matrix in a figure
% figure;
% annotation('textbox', [0.2, 0.8, 0.4, 0.2], 'String', 'AWAKE', ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
% annotation('textbox', [0.6, 0.8, 0.4, 0.2], 'String', 'ASLEEP',  ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
% annotation('textbox', [0, 0.4, 0.2, 0.4], 'String', 'AWAKE',  ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
% annotation('textbox', [0, 0, 0.2, 0.4], 'String', 'ASLEEP',  ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
%
% annotation('textbox', [0.2, 0.4, 0.4, 0.4], ...
%     'String', num2str(confMatrix(1, 1)),  ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
% annotation('textbox', [0.6, 0.4, 0.4, 0.4], ...
%     'String', num2str(confMatrix(1, 2)),  ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
% annotation('textbox', [0.2, 0, 0.4, 0.4], ...
%     'String', num2str(confMatrix(2, 1)),  ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
% annotation('textbox', [0.6, 0, 0.4, 0.4], ...
%     'String', num2str(confMatrix(2, 2)),  ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     'BackgroundColor', [1 1 1]);
