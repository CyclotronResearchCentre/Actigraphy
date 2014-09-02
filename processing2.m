function [SW] = processing2(ACTI, SW, resolution)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

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

features = [];
windowLength = 30;
i = windowLength + 1;

while i < length(SW) - (2 * windowLength - 1)
    SWwindow = SW(i:i+(windowLength-1));
    
    %If there is no transition in the window
    if length(unique(SWwindow)) == 1
        state = unique(SWwindow);
        
        previousWindow = ACTI(i-windowLength:i-1);
        window = ACTI(i:i+(windowLength-1));
        nextWindow = ACTI(i+windowLength:i+(2*windowLength-1));
        
        nbZeros = sum(previousWindow == 0) / length(previousWindow);
        previousFeatures = [median(previousWindow) iqr(previousWindow) mean(previousWindow) std(previousWindow) cov(previousWindow) max(previousWindow) mode(previousWindow) nbZeros];        
        nbZeros = sum(window == 0) / length(window);
        windowFeatures = [median(window) iqr(window) mean(window) std(window) cov(window) max(window) mode(window) nbZeros];
        nbZeros = sum(nextWindow == 0) / length(nextWindow);
        nextFeatures = [median(nextWindow) iqr(nextWindow) mean(nextWindow) std(nextWindow) cov(nextWindow) max(nextWindow) mode(nextWindow) nbZeros];
        
        features = [features; previousFeatures windowFeatures nextFeatures state];
    end;
    
    i = i + 1;
end;

for i = 1:size(features, 1)
    if features(i, end) == 0
        y{i} = 'ASLEEP';
    else
        y{i} = 'AWAKE';
    end;
end;

W = LDA(features(:, 1:end-1), features(:, end));

back = 120 * (60 / resolution); %120 minute-long window

%Find more precise sleep times
for i = 1:length(sleepIndex)
    index = sleepIndex(i) - back;
    %SW(index:sleepIndex(i)) = ASLEEP; %The whole window is set to sleep
    
    for j = 0:back-1
        previousWindow = ACTI(index-windowLength+j:index-1+j);
        window = ACTI(index+j:index+(windowLength-1)+j);
        nextWindow = ACTI(index+windowLength+j:index+(2*windowLength-1)+j);
        
        nbZeros = sum(previousWindow == 0) / length(previousWindow);
        previousFeatures = [median(previousWindow) iqr(previousWindow) mean(previousWindow) std(previousWindow) cov(previousWindow) max(previousWindow) mode(previousWindow) nbZeros];
        nbZeros = sum(window == 0) / length(window);
        windowFeatures = [median(window) iqr(window) mean(window) std(window) cov(window) max(window) mode(window) nbZeros];
        nbZeros = sum(nextWindow == 0) / length(nextWindow);
        nextFeatures = [median(nextWindow) iqr(nextWindow) mean(nextWindow) std(nextWindow) cov(nextWindow) max(nextWindow) mode(nextWindow) nbZeros];
        
        tmpFeatures = [previousFeatures windowFeatures nextFeatures];
        
        L = [ones(1, 1) tmpFeatures] * W';
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
        %class = classify(tmpFeatures, features(:, 1:end-1), y);
        if P(2) > 0.9
            SW(index:index+(windowLength-1)+j) = AWAKE;
        end;
    end;    
end;

%Find more precise wake times
for i = 1:length(sleepIndex)
    index = sleepIndex(i) - back;
    %SW(index:index+back) = ASLEEP; %The whole window is set to sleep
    
    for j = 0:2*back-1
        previousWindow = ACTI(index-windowLength+j:index-1+j);
        window = ACTI(index+j:index+(windowLength-1)+j);
        nextWindow = ACTI(index+windowLength+j:index+(2*windowLength-1)+j);
        
        nbZeros = sum(previousWindow == 0) / length(previousWindow);
        previousFeatures = [median(previousWindow) iqr(previousWindow) mean(previousWindow) std(previousWindow) cov(previousWindow) max(previousWindow) mode(previousWindow) nbZeros];
        nbZeros = sum(window == 0) / length(window);
        windowFeatures = [median(window) iqr(window) mean(window) std(window) cov(window) max(window) mode(window) nbZeros];
        nbZeros = sum(nextWindow == 0) / length(nextWindow);
        nextFeatures = [median(nextWindow) iqr(nextWindow) mean(nextWindow) std(nextWindow) cov(nextWindow) max(nextWindow) mode(nextWindow) nbZeros];
        
        tmpFeatures = [previousFeatures windowFeatures nextFeatures];
        
        L = [ones(1, 1) tmpFeatures] * W';
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
        %class = classify(tmpFeatures, features(:, 1:end-1), y);
        
        %If the window is 'almost certainly' a awake window
        if P(2) > 0.9
            SW(index+j:index+2*back) = AWAKE;
            break;
        end;
    end;    
end;


end