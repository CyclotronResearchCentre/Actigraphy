function [SW] = crespoProcessing(ACTI, SW, resolution)

constantes;


%% Apply G{.}

i = 1;
b = [];
while i <= length(ACTI)
    consecZeroes = 0;
    state = SW(i);
    
    % Counts the number of consecutives zeros while the state (ASLEEP or
    % AWAKE) of the patient is not modified
    while i <= length(ACTI) && ACTI(i) == 0 && SW(i) == state
        consecZeroes = consecZeroes + 1;
        i = i + 1;
    end;
    
    %If the number of consecutives zeroes is greater than z, it is
    %considered invalid and added in b
    if (state == AWAKE && consecZeroes >= za) || (state == ASLEEP && consecZeroes >= zr)
        b = [b, i-consecZeroes:i-1];    
    elseif consecZeroes == 0
        i = i + 1;
    end;
end;

%% Compute xsp

m = max(ACTI);
paddingLength = 60 * (60 / resolution);
xsp = zeros(1, length(ACTI) + 2 * paddingLength); %x is padded with 1h of max at each extremities
xsp(1:paddingLength) = m;
xsp(paddingLength + 1:end-paddingLength) = ACTI;
xsp(end-paddingLength + 1:end) = m;

%% Adaptative median filter

xfa = zeros(1, length(ACTI));
windowLength = paddingLength * 2;

for i = paddingLength+1:length(xsp)-2*paddingLength
    medianWindow = [xsp(i-windowLength/2:i+windowLength/2)];
    indices = i-windowLength/2:i+windowLength/2;
    
    for j = 1:length(indices)
        index = indices(j) - paddingLength;
        if ~isempty(find(b==index))
            medianWindow(j) = NaN;
        end;
    end;
    
    medianWindow = medianWindow(~isnan(medianWindow));

    xfa(i) = median(medianWindow);
    
    if windowLength < Lw
        windowLength = windowLength + 2;
    end;
    
    while i + windowLength / 2 > length(xsp)-2*paddingLength
        windowLength = windowLength - 2;
    end;
end;


%% y2 is computed

p = prctile(xfa, percentile);
y2 = zeros(1, length(xfa));
for i = 1:length(xfa)
    if xfa(i) > p
        y2(i) = AWAKE;
    else
        y2(i) = ASLEEP;
    end;
end;

%% Opening - closing

Lp = (120 + 1) * (60 / resolution);
morphWindow = linspace(AWAKE, AWAKE, Lp);
o = imopen(imclose(y2, morphWindow), morphWindow);
o(1) = AWAKE;
o(end) = AWAKE;

SW = o;

end