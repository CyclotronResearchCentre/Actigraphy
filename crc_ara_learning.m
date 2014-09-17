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
def_learn = crc_ara_get_defaults('learn');

%% Find all the sleep and wake indexes (= where the transitions happen)
% transitions = find(abs(diff(SW))==1);
sleepIndex = find(diff(SW)==-1);
wakeIndex = find(diff(SW)==1);

%% Divide SW into subwindows and extract interesting features
features = [];
windowLength = def_learn.windowLength;
windowLength2 = round(windowLength/2); % half window length
winTest = def_learn.winTest; % Begins after 1 hour
ii = def_learn.skipBE + 1; % Begins after 1 hour

while ii < length(SW) - windowLength - def_learn.skipBE % finish 1h before end
    % Only the records 'far' (at least 1 hour after or before) a transition
    % are taken into account
    SWwindow = SW(ii:ii+(windowLength-1));
    tmpWindow = SW(ii-winTest:ii+(windowLength-1)+winTest);
    
    if length(unique(tmpWindow)) == 1
        state = unique(SWwindow);
        window = ACTI(ii:ii+(windowLength-1));
        nbZeros = sum(window == 0);
        features = [features; ...
            median(window) crc_iqr(window) mean(window) std(window) ...
            max(window) min(window) mode(window) nbZeros state]; %#ok<*AGROW>
        
    end;
    ii = ii + windowLength;
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

back = round(winTest * (60 / resolution)); % 2 x winTest window

threshL = def_learn.threshL;
% fplot(ACTI), hold on, plot(SW*1000,'r')

% Finds more precise sleep times using the neural network
for ii = 1:length(sleepIndex)
    index = sleepIndex(ii) - back;
    SW(index:sleepIndex(ii)) = ASLEEP; % The whole window is set to 'sleep'
                                       % 2nd part is already 'sleep'
    Y = zeros(1,2*back);
    for jj = 0:2*back-1
        window = ACTI(index+(jj:(windowLength-1)+jj));
        nbZeros = sum(window == 0);
        % Computes the features of the window
        windowFeatures = [median(window) crc_iqr(window) mean(window) ...
            std(window) max(window) min(window) mode(window) nbZeros];
        
        %Uses the neural network to find if the subject is awake or asleep
        Y(jj+1) = sim(net, windowFeatures');
        
    end;    
    % Pick the latest moment we're sure subject is awake
    i_Wake = max(find(Y>threshL)); %#ok<*MXFND>
    SW(index+(0:i_Wake+windowLength2)) = AWAKE;
%     fplot(ACTI(index+(0:2*back-1))), hold on, plot(1000*Y,'r'), plot(1000*threshL*SW(index+(0:2*back-1)),'g')
end;

% Finds more precise wake times using the neural network
for ii = 1:length(wakeIndex)
    index = wakeIndex(ii) - back;
    SW(index:index+back) = AWAKE; %The whole window is set to wake
    
    Y = zeros(1,2*back);
    for jj = 0:2*back - 1
        window = ACTI(index+jj:index+(windowLength-1)+jj);
        nbZeros = sum(window == 0);
        % Computes the features of the window        
        windowFeatures = [median(window) crc_iqr(window) mean(window) ...
            std(window) max(window) min(window) mode(window) nbZeros];

        % Uses the neural network to find if the subject is awake or asleep        
        Y(jj+1) = sim(net, windowFeatures');
        
    end;    
    % Pick the earliest moment we're sure subject is awake
    i_Sleep = min(find(Y>threshL)); %#ok<*MXFND>
    SW(index+(0:i_Sleep+windowLength2)) = ASLEEP;
%     fplot(ACTI(index+(0:2*back-1))), hold on, plot(1000*Y,'r'), plot(1000*threshL*SW(index+(0:2*back-1)),'g')
end;


end