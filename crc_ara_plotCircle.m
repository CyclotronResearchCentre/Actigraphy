function crc_ara_plotCircle(SW, startTime, nbDataPerDay, ACTI, trueSW)
%
% FORMAT crc_ara_plotCircle(SW, trueSW, startTime, nbDataPerDay)
%
% Plot the sleep/wake cycles, with wake/sleep times on a spiral.
%
% INPUT:
% - SW           : sleep/wake time series
% - startTime    : start time of recording
% - nbDataPerDay : number of bins per day
% - ACTI         : actigraphic data
% - trueSW       : true sleep/wake time series, used as reference ([], def)
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

%% Define key stuff
if nargin < 5, trueSW = []; end
if nargin < 4, ACTI = []; end

radius = 1;
colors = ['b', 'r']; % BLUE = sleep, RED = wake
ang = getStartAngle(startTime);
angStep = 2 * pi / nbDataPerDay; % theta between two successives points on the circle
radStep = 1/nbDataPerDay;
origin = [0, 0]; % Center of the circle

nbDays = ceil(numel(SW)/nbDataPerDay)+1;
angCoord = ang:-angStep:-(2*pi*nbDays+ang);
radCoord = radius:radStep:(radius+nbDays);
line_length = nbDays+.5;

% find W->S/S->W transitions
dSW = diff(SW);
l_W2St = find(dSW==-1);
l_S2Wt = find(dSW==1);
l_SWt = find(dSW);
l_SWt_e = [ [1 l_SWt+1] ; [l_SWt numel(SW)] ];
if ~isempty(trueSW)
    dtrueSW    = diff(trueSW);
    ltrue_W2St = find(dtrueSW==-1);
    ltrue_S2Wt = find(dtrueSW==1);
    ltrue_SWt  = find(dtrueSW);
end

%% Start plot
hf = figure;
set(hf,'Position',[500 300 1200 800])
hold on;
axis equal;
axis([-nbDays-1 nbDays+1 -nbDays-1 nbDays+1])

%% If provided plot ACTI on top of spiral
if ~isempty(ACTI) 
    if numel(ACTI)<numel(angCoord)
        ACTI_sc = ACTI/prctile(ACTI,99) ; % Ensures few values >1;
        ACTI_rad = ACTI_sc + radCoord(1:numel(ACTI));
        ACTI_ang = angCoord(1:numel(ACTI));
        crc_ara_drawCircle(origin,ACTI_rad,ACTI_ang,'m');
    else
        fprintf('\n Could not plot ACTI data, wrong duration\n')
    end
end

%% Plot SW cycles on a spiral
for ii=1:size(l_SWt_e,2)
    SWt_rad = radCoord(l_SWt_e(1,ii):l_SWt_e(2,ii));
    SWt_ang = angCoord(l_SWt_e(1,ii):l_SWt_e(2,ii));
    tmp = crc_ara_drawCircle(origin,SWt_rad,SWt_ang,colors(SW(l_SWt_e(1,ii))+1));
    if ii<3
        switch SW(l_SWt_e(1,ii))
            case 0
                p(1)  = tmp;
            case 1
                p(2)  = tmp;
        end
    end
end

%% Add circles on transitions
SWt_ang = angCoord(l_SWt);
SWt_rad = radCoord(l_SWt);
p(3) = crc_ara_drawCircle(origin,SWt_rad,SWt_ang,'ko');
set(p(3),'MarkerSize',10,'LineWidth',2)
if ~isempty(trueSW)
    trueSWt_ang = angCoord(ltrue_SWt);
    trueSWt_rad = radCoord(ltrue_SWt);
    p(6) = crc_ara_drawCircle(origin,trueSWt_rad,trueSWt_ang,'go');
    set(p(6),'MarkerSize',10,'LineWidth',2)
end

%% Get mean S/W angles and plot fitted line + standard deviation
angWake  = angCoord(l_S2Wt); %#ok<*FNDSB>
% Avoid angle wrapping issues with 2 calculations:
v1 = mod(angWake,-2*pi);
v2 = mod(angWake-pi/2,-2*pi)+pi/2;
if std(v1)>std(v2), angWake = v2; else angWake = v1; end
m_angWake = median(angWake); s_angWake = std(angWake);
p(4) = crc_ara_drawCircle(origin,[0 line_length],[m_angWake m_angWake],'k');
p(5) = crc_ara_drawCircle(origin,[0 line_length],[m_angWake+s_angWake m_angWake+s_angWake],'--k');
crc_ara_drawCircle(origin,[0 line_length],[m_angWake-s_angWake m_angWake-s_angWake],'--k');
if ~isempty(trueSW)
    angtrueWake  = angCoord(ltrue_S2Wt); %#ok<*FNDSB>
    % Avoid angle wrapping issues with 2 calculations:
    v1 = mod(angtrueWake,-2*pi);
    v2 = mod(angtrueWake-pi/2,-2*pi)+pi/2;
    if std(v1)>std(v2), angtrueWake = v2; else angtrueWake = v1; end
    m_angtrueWake = median(angtrueWake); 
    p(7) = crc_ara_drawCircle(origin,[0 line_length],[m_angtrueWake m_angtrueWake],'g');
end

angSleep = angCoord(l_W2St);
% Avoid angle wrapping issues with 2 calculations:
v1 = mod(angSleep,-2*pi);
v2 = mod(angSleep-pi/2,-2*pi)+pi/2;
if std(v1)>std(v2), angSleep = v2; else angSleep = v1; end
m_angSleep = median(angSleep); s_angSleep = std(angSleep);
crc_ara_drawCircle(origin,[0 line_length],[m_angSleep m_angSleep],'k');
crc_ara_drawCircle(origin,[0 line_length],[m_angSleep+s_angSleep m_angSleep+s_angSleep],'--k');
crc_ara_drawCircle(origin,[0 line_length],[m_angSleep-s_angSleep m_angSleep-s_angSleep],'--k');
if ~isempty(trueSW)
    angtrueSleep = angCoord(ltrue_W2St);
    % Avoid angle wrapping issues with 2 calculations:
    v1 = mod(angtrueSleep,-2*pi);
    v2 = mod(angtrueSleep-pi/2,-2*pi)+pi/2;
    if std(v1)>std(v2), angtrueSleep = v2; else angtrueSleep = v1; end
    m_angtrueSleep = median(angtrueSleep); 
    crc_ara_drawCircle(origin,[0 line_length],[m_angtrueSleep m_angtrueSleep],'k');
end

%% Add median w/s times
t_wake = -m_angWake/2/pi*24+6;
xy_t_wake = [cos(m_angWake) sin(m_angWake)]*(line_length+.2);
text(xy_t_wake(1),xy_t_wake(2),sprintf('%02d:%02d', ...
        fix(t_wake),round((t_wake-fix(t_wake))*60)))
t_sleep = -m_angSleep/2/pi*24+6;
xy_t_sleep = [cos(m_angSleep) sin(m_angSleep)]*(line_length+.2);
text(xy_t_sleep(1),xy_t_sleep(2),sprintf('%02d:%02d', ...
        fix(t_sleep),round((t_sleep-fix(t_sleep))*60)))

%% Add some text informations
text(0, nbDays+1.4, 'Midnight', 'FontWeight','Bold', ...
    'HorizontalAlignment','Center','VerticalAlignment','Bottom');
text(nbDays+1.4, 0, '6AM', 'FontWeight','Bold', ...
    'HorizontalAlignment','Left','VerticalAlignment','Middle');
text(0, -(nbDays+1.4), 'Noon', 'FontWeight','Bold', ...
    'HorizontalAlignment','Center','VerticalAlignment','Top');
text(-(nbDays+1.4), 0, '6PM', 'FontWeight','Bold', ...
    'HorizontalAlignment','Right','VerticalAlignment','Middle');

axis off

if isempty(trueSW)
    legend(p, 'Sleep time', 'Wake time', 'Transition time', ...
            'Median transition time', 'Std transition time', ...
            'Location','BestOutside');
else
    legend(p, 'Sleep time', 'Wake time', 'Transition time', ...
            'Median transition time', 'std transition time', ...
            'Ref. transition time', 'Median ref. transition time', ... 
            'Location','BestOutside');    
end

end
