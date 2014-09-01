function [SW] = processing(ACTI, SW, resolution)

constantes;

transitions = find(abs(diff(SW))==1);
sleepIndex = [];
wakeIndex = [];
sleep = {};
wake = {};
totalSleep = [];
totalWake = [];

state = AWAKE;
index = 1;
a = 1;
b = 1;

%Find all the sleep and wake indexes
for i = 1:length(transitions)
    if state == AWAKE
        sleepIndex = [sleepIndex; transitions(i)];
        wake{a} = ACTI(index:transitions(i)-1);
        totalWake = [totalWake, ACTI(index:transitions(i)-1)];
        a = a + 1;
        state = ASLEEP;
        index = transitions(i);
    else
        wakeIndex = [wakeIndex; transitions(i)];
        sleep{b} = ACTI(index:transitions(i)-1);
        totalSleep = [totalSleep, ACTI(index:transitions(i) - 1)];
        b = b + 1;
        state = AWAKE;
        index = transitions(i);
    end;
end;
wake{b} = ACTI(index:end);

%For each sleep period, determine some intersting features
sleepFeatures = [];
for i = 1:length(sleep)
    nbZeros = sum(sleep{i}==0) / length(sleep{i});
    sleepFeatures = [sleepFeatures; median(sleep{i}) iqr(sleep{i}) mean(sleep{i}) std(sleep{i}) cov(sleep{i}) max(sleep{i}) mode(sleep{i}) nbZeros ASLEEP];
end;

%For each wake period, determine some intersting features
wakeFeatures = [];
for i = 1:length(wake)
    nbZeros = sum(wake{i}==0) / length(wake{i});
    wakeFeatures = [wakeFeatures; median(wake{i}) iqr(wake{i}) mean(wake{i}) std(wake{i}) cov(wake{i}) max(wake{i}) mode(wake{i}) nbZeros AWAKE];
end;

features = [sleepFeatures; wakeFeatures];

%Find the features that are most related to the state (Feature selection)
rhos = [];
for i = 1:size(wakeFeatures, 2)-1
    feature1 = features(:, i);
    feature2 = features(:, end);
    
    [rho pval] = corr(feature1, feature2);
    rhos = [rhos; rho];
end;

selectedFeature1 = 0;
rhoMax = 0;
for i = 1:length(rhos)
    if rhos(i) > rhoMax
        selectedFeature1 = i;
        rhoMax = rhos(i);
    end;
end;
rhos(selectedFeature1) = [];

selectedFeature2 = 0;
rhoMax = 0;
for i = 1:length(rhos)
    if rhos(i) > rhoMax
        selectedFeature2 = i;
        rhoMax = rhos(i);
    end;
end;

for i = 1:size(features, 1)
    if features(i, end) == 0
        y{i} = 'ASLEEP';
    else
        y{i} = 'AWAKE';
    end;
end;

t = classregtree(features(:, 1:end-1), y, 'minleaf', 4);
W = LDA([features(:, selectedFeature1), features(:, selectedFeature2)], features(:, end));

windowLength = 120 * (60 / resolution); %60 minute-long window
sleepLength = 15 * (60 / resolution);
nbWindows = 2 * windowLength / sleepLength;

%Find more precise sleep times
for i = 1:length(sleepIndex)
    index = sleepIndex(i) - windowLength;    
    SW(index:sleepIndex(i)+windowLength) = ASLEEP; %The whole window is set to sleep
    
    for j = 1:nbWindows
        window = ACTI(index+(j-1)*sleepLength:index+j*sleepLength);
        nbZeros = sum(window==0) / length(window);
        windowFeatures = [median(window) iqr(window) mean(window) std(window) cov(window) max(window) mode(window) nbZeros];
        L = [ones(1,1) windowFeatures(selectedFeature1) windowFeatures(selectedFeature2)] * W';
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
        if P(1) < P(2)
            SW(index:index+j*sleepLength) = AWAKE;
        end;
    end;    
end;

windowLength = 120 * (60 / resolution); %60 minute-long window
wakeLength = 15 * (60 / resolution);
nbWindows = 2 * windowLength / wakeLength;

%Find more precise wake times
for i = 1:length(wakeIndex)
    index = wakeIndex(i) + windowLength;    
    SW(wakeIndex(i)-windowLength:index) = ASLEEP; %The whole window is set to wake
    
    for j = 1:nbWindows
        window = ACTI(wakeIndex(i)-windowLength+(j-1)*wakeLength:wakeIndex(i)-windowLength+j*wakeLength);
        nbZeros = sum(window==0) / length(window);
        windowFeatures = [median(window) iqr(window) mean(window) std(window) cov(window) max(window) mode(window) nbZeros];
        L = [ones(1,1) windowFeatures(selectedFeature1) windowFeatures(selectedFeature2)] * W';
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
        if P(1) < P(2)
            SW(wakeIndex(i)-windowLength+(j-1)*wakeLength:index) = AWAKE;
        end;
    end;    
end;



end