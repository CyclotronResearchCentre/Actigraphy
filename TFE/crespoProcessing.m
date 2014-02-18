function [SW] = crespoProcessing(ACTI, SW)

constantes;

% 
% %% Apply G{.}
% 
% i = 1;
% b = [];
% while i <= length(ACTI)
%     consecZeroes = 0;
%     state = SW(i);
%     
%     % Counts the number of consecutives zeros while the state (ASLEEP or
%     % AWAKE) of the patient is not modified
%     while i <= length(ACTI) && ACTI(i) == 0 && SW(i) == state
%         consecZeroes = consecZeroes + 1;
%         i = i + 1;
%     end;
%     
%     %If the number of consecutives zeroes is greater than z, it is
%     %considered invalid and added in b
%     if (state == AWAKE && consecZeroes >= za) || (state == ASLEEP && consecZeroes >= zr)
%         b = [b, i-consecZeroes:i-1];    
%     elseif consecZeroes == 0
%         i = i + 1;
%     end;
% end;
% 
% %% Compute xsp
% 
% m = max(ACTI);
% paddingLength = 60;
% xsp = zeros(1, length(ACTI) + 2 * paddingLength);
% xsp(1:paddingLength) = m;
% xsp(paddingLength + 1:end-paddingLength) = ACTI;
% xsp(end-paddingLength + 1:end) = m;
% 
% %% Adaptative median filter
% 
% xfa = zeros(1, length(ACTI));
% windowLength = paddingLength * 2;
% 
% for i = paddingLength+1:length(xsp)-2*paddingLength
%     medianWindow = [];
%     
%     %Adds the values preceding the center of the window
%     for j = 1:windowLength/2
%         index = i - paddingLength - j;
%         if isempty(find(b==index))
%             medianWindow = [xsp(i-j), medianWindow];
%         end;
%     end;
%     
%     %Adds the values following the center of the window
%     for j = 0:windowLength/2
%         index = i - paddingLength + j;
%         if isempty(find(b==index))
%             medianWindow = [medianWindow, xsp(i+j)];
%         end;
%     end;
% 
%     xfa(i) = median(medianWindow);
%     
%     if windowLength < Lw
%         windowLength = windowLength + 2;
%     end;
%     
%     while i + windowLength / 2 > length(xsp)-2*paddingLength
%         windowLength = windowLength - 2;
%     end;
% end;
% 
% 
% %% y2 is computed
% 
% p = prctile(xfa, 33);
% y2 = zeros(1, length(xfa));
% for i = 1:length(xfa)
%     if xfa(i) > p
%         y2(i) = AWAKE;
%     else
%         y2(i) = ASLEEP;
%     end;
% end;

y2 = SW;

%% Opening - closing

Lp = 60 + 1;
Lp = 2 * (Lp - 1) + 1;
morphWindow = linspace(AWAKE, AWAKE, Lp);
o = imopen(imclose(y2, morphWindow), morphWindow);
o(1) = AWAKE;
o(end) = AWAKE;

SW = o;

end