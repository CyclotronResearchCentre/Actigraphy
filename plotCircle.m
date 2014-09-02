function plotCircle(SW, startTime, nbDataPerDays, trueSW)
%
% FORMAT plotCircle(SW, trueSW, startTime, nbDataPerDays)
%
% Plot the sleep/wake cycles, with wake/sleep times on a spiral.
%
% INPUT:
% - SW            : sleep/wake time series
% - startTime     : start time of recording
% - nbDataPerDays : number of bins per day
% - trueSW        : true sleep/wake time series, used as reference ([], def)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

%% Define key stuff
if nargin < 4, trueSW = []; end

radius = 1;
colors = ['b', 'r']; % BLUE = sleep, RED = wake
ang = getStartAngle(startTime);
angStep = 2 * pi / nbDataPerDays; % theta between two successives points on the circle
radStep = 1/nbDataPerDays;
origin = [0, 0]; % Center of the circle
strline = '--------------------------';

nbDays = ceil(numel(SW)/nbDataPerDays);
angCoord = ang:-angStep:-(2*pi*nbDays+ang);
radCoord = radius:radStep:(radius+nbDays);

% find W->S/S->W transitions
dSW = diff(SW);
l_W2St = find(dSW==-1);
l_S2Wt = find(dSW==1);
l_SWt = find(dSW);
l_SWt_e = [ [1 l_SWt+1] ; [l_SWt numel(SW)] ];
if ~isempty(trueSW)
    dtrueSW = diff(trueSW);
    ltrue_W2St = find(dtrueSW==-1);
    ltrue_S2Wt = find(dtrueSW==1);
    ltrue_SWt = find(dtrueSW);
end

%% Start plot
figure;
hold on;
axis equal;
axis([-nbDays-1 nbDays+1 -nbDays-1 nbDays+1])

% Plot SW cycles on a spiral
for ii=1:size(l_SWt_e,2)
    SWt_rad = radCoord(l_SWt_e(1,ii):l_SWt_e(2,ii));
    SWt_ang = angCoord(l_SWt_e(1,ii):l_SWt_e(2,ii));
    drawCircle(origin,SWt_rad,SWt_ang,colors(SW(l_SWt_e(1,ii))+1))
end

% Add circles on transitions
SWt_ang = angCoord(l_SWt);
SWt_rad = radCoord(l_SWt);
drawCircle(origin,SWt_rad,SWt_ang,'ko')
if ~isempty(trueSW)
    trueSWt_ang = angCoord(ltrue_SWt);
    trueSWt_rad = radCoord(ltrue_SWt);
    drawCircle(origin,trueSWt_rad,trueSWt_ang,'go')
end

%% Get mean S/W angles and plot fitted line + standard deviation
angWake  = angCoord(l_S2Wt); %#ok<*FNDSB>
% Avoid angle wrapping issues with 2 calculations:
v1 = mod(angWake,-2*pi);
v2 = mod(angWake-pi/2,-2*pi)+pi/2;
if std(v1)>std(v2), angWake = v2; else angWake = v1; end
m_angWake = mean(angWake); s_angWake = std(angWake);
drawCircle(origin,[0 nbDays+1],[m_angWake m_angWake],'k')
drawCircle(origin,[0 nbDays+1],[m_angWake+s_angWake m_angWake+s_angWake],'--k')
drawCircle(origin,[0 nbDays+1],[m_angWake-s_angWake m_angWake-s_angWake],'--k')
if ~isempty(trueSW)
    angtrueWake  = angCoord(ltrue_S2Wt); %#ok<*FNDSB>
    % Avoid angle wrapping issues with 2 calculations:
    v1 = mod(angtrueWake,-2*pi);
    v2 = mod(angtrueWake-pi/2,-2*pi)+pi/2;
    if std(v1)>std(v2), angtrueWake = v2; else angtrueWake = v1; end
    m_angtrueWake = mean(angtrueWake); 
    drawCircle(origin,[0 nbDays+1],[m_angtrueWake m_angtrueWake],'g')
end

angSleep = angCoord(l_W2St);
% Avoid angle wrapping issues with 2 calculations:
v1 = mod(angSleep,-2*pi);
v2 = mod(angSleep-pi/2,-2*pi)+pi/2;
if std(v1)>std(v2), angSleep = v2; else angSleep = v1; end
m_angSleep = mean(angSleep); s_angSleep = std(angSleep);
drawCircle(origin,[0 nbDays+1],[m_angSleep m_angSleep],'k')
drawCircle(origin,[0 nbDays+1],[m_angSleep+s_angSleep m_angSleep+s_angSleep],'--k')
drawCircle(origin,[0 nbDays+1],[m_angSleep-s_angSleep m_angSleep-s_angSleep],'--k')
if ~isempty(trueSW)
    angtrueSleep = angCoord(ltrue_W2St);
    % Avoid angle wrapping issues with 2 calculations:
    v1 = mod(angtrueSleep,-2*pi);
    v2 = mod(angtrueSleep-pi/2,-2*pi)+pi/2;
    if std(v1)>std(v2), angtrueSleep = v2; else angtrueSleep = v1; end
    m_angSleep = mean(angtrueSleep); 
    drawCircle(origin,[0 nbDays+1],[m_angtrueSleep m_angtrueSleep],'k')
end

%% Output mean w/s times
t_wake = -m_angWake/2/pi*24+6;
fprintf('%s \n', strline);
fprintf('Mean wake time : %dh %dm\n',fix(t_wake),round((t_wake-fix(t_wake))*60))
t_slep = -m_angSleep/2/pi*24+6;
fprintf('Mean sleep time: %dh %dm\n',fix(t_slep),round((t_slep-fix(t_slep))*60))
fprintf('%s \n\n', strline);

%% Add some text informations
text(0, nbDays+1.5, 'Midnight');
text(nbDays+1.5, 0, '6AM');
text(0, -(nbDays+1.5), 'Noon');
text(-(nbDays+1.5), 0, '6PM');

axis off

end
