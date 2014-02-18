function [SW] = crespoPreprocessing(ACTI)

constantes;

%% Apply F{.}
i = 1;
a = [];
while i <= length(ACTI)
    consecZeroes = 0;
    while i <= length(ACTI) && ACTI(i) == 0
        consecZeroes = consecZeroes + 1;
        i  = i + 1;
    end;
    
    if consecZeroes >= z
        a = [a, i-consecZeroes:i-1];    
    elseif consecZeroes == 0
        i = i + 1;
    end;
end;

%% Compute x

st = prctile(ACTI, 33); % 33% percentile
x = zeros(1, length(ACTI));
index = 1;
for i = 1:length(ACTI)
    if index < length(a) && i == a(index)
        x(i) = st;
        index = index + 1;
    else
        x(i) = ACTI(i);
    end;
end;

%% x is padded

xp = zeros(1, length(x) + 2 * 30 * winAlpha); %x padded
m = max(ACTI);
xp(1:30*winAlpha) = m;
xp(30*winAlpha+1:end-30*winAlpha) = ACTI;
xp(end-30*winAlpha + 1:end) = m;

%% x is filtered by a median operator

xf = zeros(1, length(ACTI));

Lp = 60 * winAlpha;
for i = 1:length(ACTI)
    medianWindow = xp(i:i+Lp);
    xf(i) = median(medianWindow);
end;


%% y1 is computed

p = prctile(xf, 33);
y1 = zeros(1, length(xf));
for i = 1:length(xf)
    if xf(i) > p
        y1(i) = AWAKE;
    else
        y1(i) = ASLEEP;
    end;
end;

%% Opening - closing

Lp = 60 + 1;
morphWindow = linspace(AWAKE, AWAKE, Lp);
y = imopen(imclose(y1, morphWindow), morphWindow); %Wake and rest periods of less than 60 minutes are removed

SW = y;

end