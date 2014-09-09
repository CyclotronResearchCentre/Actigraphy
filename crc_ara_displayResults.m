function crc_ara_displayResults(errorRates, sensitivities, specificities, kappas,CMs)
%
% FORMAT crc_ara_displayResults(errorRates, sensitivities, specificities, kappas,CMs)
%
% Print out the results, as mean/max/min of error rate, sensitivity,
% specificity and Cohen's kappa for N data files.
% Plus mean confusion matrix, assuming each CM was normalised.
%
% INPUT:
% - errorRates
% - sensitivities
% - specificities
% - kappas
% - CMs
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

strline = '--------------------------';

if nargin<1
    return
end

if nargin>0 && ~isempty(errorRates)
    fprintf('%s \n', strline);
    fprintf('Mean error : %f \n', 1 - mean(errorRates));
    fprintf('Max arror  : %f \n', 1 - max(errorRates));
    fprintf('Min error  : %f \n', 1 - min(errorRates));
end
if nargin>1 && ~isempty(sensitivities)
    fprintf('%s \n', strline);
    fprintf('Mean Sensitivity : %f \n', mean(sensitivities));
    fprintf('Max sensitivity  : %f \n', max(sensitivities));
    fprintf('Min sensitivity  : %f \n', min(sensitivities));
end
if nargin>2 && ~isempty(specificities)
    fprintf('%s \n', strline);
    fprintf('Mean specificity : %f \n', mean(specificities));
    fprintf('Max specificity  : %f \n', max(specificities));
    fprintf('Min specificity  : %f \n', min(specificities));
end
if nargin>3 && ~isempty(kappas)
    fprintf('%s \n', strline);
    fprintf('Kappa moyen : %f \n', mean(kappas));
    fprintf('Kappa max : %f \n', max(kappas));
    fprintf('Kappa min : %f \n', min(kappas));
end
fprintf('%s \n \n', strline);

if nargin==5
    % Rescaling all CM's, so that sum(CM(:))=1
    nbCMs = size(CMs,3);
    rCMs = reshape(CMs,4,nbCMs);
    sCMs = reshape(rCMs*diag(1./sum(rCMs)), 2, 2, nbCMs);
    mCMs = squeeze(mean(sCMs,3));
    pCMs = mCMs*100;
    fprintf(' %s \n', strline);
    fprintf('|\t\t | Pr. W  | Pr. S  |\n');
    fprintf(' %s \n', strline);
    fprintf('| True W | %5.2f%% | %5.2f%% |\n', pCMs(1,1), pCMs(1,2))
    fprintf(' %s \n', strline);
    fprintf('| True S | %5.2f%% | %5.2f%% |\n', pCMs(2,1), pCMs(2,2))
    fprintf(' %s \n', strline);
end

end

% mCM = [1024 34 ; 56 903];
% fprintf('%s \n', strline);
% fprintf('|\t\t | Pr. W | Pr. S |\n');
% fprintf('%s \n', strline);
% fprintf('| True W | %5d | %5d |\n', mCM(1,1), mCM(1,2))
% fprintf('%s \n', strline);
% fprintf('| True S | %5d | %5d |\n', mCM(2,1), mCM(2,2))
% fprintf('%s \n', strline);
% 
% pCM = mCM /sum(mCM(:))*100
% fprintf(' %s \n', strline);
% fprintf('|\t\t | Pr. W  | Pr. S  |\n');
% fprintf(' %s \n', strline);
% fprintf('| True W | %5.2f%% | %5.2f%% |\n', pCM(1,1), pCM(1,2))
% fprintf(' %s \n', strline);
% fprintf('| True S | %5.2f%% | %5.2f%% |\n', pCM(2,1), pCM(2,2))
% fprintf(' %s \n', strline);
