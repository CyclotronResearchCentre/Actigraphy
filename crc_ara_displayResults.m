function crc_ara_displayResults(errorRates, sensitivities, ...
    specificities, kappas, d_tWake, d_tSleep, CMs)
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
    fprintf('Mean error : %4.2f%% \n', 100*mean(errorRates));
    fprintf('Max arror  : %4.2f%% \n', 100*max(errorRates));
    fprintf('Min error  : %4.2f%% \n', 100*min(errorRates));
end
if nargin>1 && ~isempty(sensitivities)
    fprintf('%s \n', strline);
    fprintf('Mean Sensitivity : %4.2f%% \n', 100*mean(sensitivities));
    fprintf('Max sensitivity  : %4.2f%% \n', 100*max(sensitivities));
    fprintf('Min sensitivity  : %4.2f%% \n', 100*min(sensitivities));
end
if nargin>2 && ~isempty(specificities)
    fprintf('%s \n', strline);
    fprintf('Mean specificity : %4.2f%% \n', 100*mean(specificities));
    fprintf('Max specificity  : %4.2f%% \n', 100*max(specificities));
    fprintf('Min specificity  : %4.2f%% \n', 100*min(specificities));
end
if nargin>3 && ~isempty(kappas)
    fprintf('%s \n', strline);
    fprintf('Mean Kappa : %f \n', mean(kappas));
    fprintf('Max Kappa  : %f \n', max(kappas));
    fprintf('Min Kappa  : %f \n', min(kappas));
end
if nargin>4 && ~isempty(d_tWake)
    md_tWake = mean(d_tWake);
    Mad_tWake = max(d_tWake);
    Mid_tWake = min(d_tWake);
    fprintf('%s \n', strline);
    fprintf('Mean diff.median  Wake time : %dm %ds \n', ...
        fix(md_tWake/60), round(mod(md_tWake,60)) );
    fprintf('Max diff. median Wake time  : %dm %ds \n', ...
        fix(Mad_tWake/60), round(mod(Mad_tWake,60)) );
    fprintf('Min diff. median Wake time  : %dm %ds \n', ...
        fix(Mid_tWake/60), round(mod(Mid_tWake,60)) );
end
if nargin>5 && ~isempty(d_tSleep)
    md_tSleep = mean(d_tSleep);
    Mad_tSleep = max(d_tSleep);
    Mid_tSleep = min(d_tSleep);
    fprintf('%s \n', strline);
    fprintf('Mean diff. median Sleep time : %dm %ds \n', ...
        fix(md_tSleep/60), round(mod(md_tSleep,60)) );
    fprintf('Max diff. median Sleep time  : %dm %ds \n', ...
        fix(Mad_tSleep/60), round(mod(Mad_tSleep,60)) );
    fprintf('Min diff. median Sleep time  : %dm %ds \n', ...
        fix(Mid_tSleep/60), round(mod(Mid_tSleep,60)) );
end
fprintf('%s \n \n', strline);

if nargin==7 && ~isempty(CMs)
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

