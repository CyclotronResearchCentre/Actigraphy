function [SW] = crc_ara_learning(ACTI, SW, resolution)
%
% FORMAT [SW] = crc_ara_learning(ACTI, SW, resolution)
%
% Refines previous solution using machine learning techniques
% 
% INPUT:
% - ACTI       : actigraphic recording
% - SW         : slaap/wake time series
% - resolution : temporal resolution (in sec)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

ASLEEP = crc_ara_get_defaults('sw.ASLEEP');
AWAKE = crc_ara_get_defaults('sw.AWAKE');

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

%% Find all the sleep and wake indexes (= where the transitions happen)
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
wake{b} = ACTI(index:end); %#ok<*NASGU>

%% Divide SW into subwindows and extract interesting features

features = [];
windowLength = 15;
i = 61; % Begins after 1 hour

while i < length(SW) - windowLength - 60
    SWwindow = SW(i:i+(windowLength-1));
    tmpWindow = SW(i-60:i+(windowLength-1)+60);
    
    % Only the records 'far' (at least 1 hour after or before) a transition
    % are taken into account
    if length(unique(tmpWindow)) == 1
        state = unique(SWwindow);
        window = ACTI(i:i+(windowLength-1));
        nbZeros = sum(window == 0);
        features = [features; ...
            median(window) crc_iqr(window) mean(window) std(window) ...
            max(window) min(window) mode(window) nbZeros state]; %#ok<*AGROW>
        
    end;
    i = i + windowLength;
end;

% Training is done on the features
inp = features(:, 1:end-1);
out = features(:, end);
warning('OFF','NNET:Obsolete')
net = newff([min(inp)' max(inp)'], [30 1], {'tansig' 'purelin'});
warning('ON','NNET:Obsolete')
net.trainParam.epochs = 300;
net.trainParam.showWindow = 0;
net = train(net, inp', out');

back = 60 * (60 / resolution); %120 minute-long window

% Finds more precise sleep times using the neural network
for i = 1:length(sleepIndex)
    index = sleepIndex(i) - back;
    SW(index:sleepIndex(i)) = ASLEEP; %The whole window is set to sleep
    
    for j = 0:2*back-1
        window = ACTI(index+j:index+(windowLength-1)+j);
        nbZeros = sum(window == 0);
        %Computes the features of the window
        windowFeatures = [median(window) crc_iqr(window) mean(window) ...
            std(window) max(window) min(window) mode(window) nbZeros];
        
        %Uses the neural network to find if the subject is awake or asleep
        Y = sim(net, windowFeatures');
        
        %If the window is 'almost certainly' a asleep window
        if Y > 0.99
            SW(index:index+(windowLength-1)+j) = AWAKE;
        end;
    end;    
end;

% Finds more precise wake times using the neural network
for i = 1:length(wakeIndex)
    index = wakeIndex(i) - back;
    SW(index:index+back) = AWAKE; %The whole window is set to sleep
    
    for j = 0:2*back - 1
        window = ACTI(index+j:index+(windowLength-1)+j);
        nbZeros = sum(window == 0);
        % Computes the features of the window        
        windowFeatures = [median(window) crc_iqr(window) mean(window) ...
            std(window) max(window) min(window) mode(window) nbZeros];

        % Uses the neural network to find if the subject is awake or asleep        
        Y = sim(net, windowFeatures');
        
        % If the window is 'almost certainly' a awake window
        if Y < 0.01
            SW(index:index+(windowLength-1)+j) = ASLEEP;
        end;
    end;    
end;


end