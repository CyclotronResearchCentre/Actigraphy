function displayResults(errorRates, sensitivities, specificities)
%
% FORMAT displayResults(errorRates, sensitivities, specificities)
%
% Print out the results, as mean/max/min of error rate, sensitivity and
% specificity for N data files
% 
% INPUT:
% - errorRates, 
% - sensitivities, 
% - specificities
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

strline = crc_get_ara_defaults('acti.strline');

fprintf('%s \n', strline);
fprintf('Mean error : %f \n', 1 - mean(errorRates));
fprintf('Max arror  : %f \n', 1 - max(errorRates));
fprintf('Min error  : %f \n', 1 - min(errorRates));
fprintf('%s \n \n', strline);

fprintf('%s \n', strline);
fprintf('Mean Sensitivity : %f \n', mean(sensitivities));
fprintf('Max sensitivity  : %f \n', max(sensitivities));
fprintf('Min sensitivity  : %f \n', min(sensitivities));
fprintf('%s \n \n', strline);

fprintf('%s \n', strline);
fprintf('Mean specificity : %f \n', mean(specificities));
fprintf('Max specificity  : %f \n', max(specificities));
fprintf('Min specificity  : %f \n', min(specificities));
fprintf('%s \n \n', strline);

end