function SWtimes = crc_ara_compSWtimes(SW,startTime,nbDataPerDay,trueSW)
%
% Calculate Wake/Sleep times + their mediand and standard deviation.
% If trueSW is provided, do the same for the reference S/W and calculate
% the difference between the 2 median Sleep/Wake times.
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

if nargin<4, trueSW = []; end

ang = crc_ara_getStartAngle(startTime);
nbDays = ceil(numel(SW)/nbDataPerDay);
angStep = 2 * pi / nbDataPerDay; % theta between two successives points on the circle
angCoord = (0:-angStep:-(2*pi*nbDays))+ang;
% find W->S/S->W transitions
dSW = diff(SW);
l_W2St = find(dSW==-1);
l_S2Wt = find(dSW==1);
% l_SWt = find(dSW);
% l_SWt_e = [ [1 l_SWt+1] ; [l_SWt numel(SW)] ];
if ~isempty(trueSW)
    dtrueSW    = diff(trueSW);
    ltrue_W2St = find(dtrueSW==-1);
    ltrue_S2Wt = find(dtrueSW==1);
%     ltrue_SWt  = find(dtrueSW);
end

%% Get median S/W angles
angWake  = angCoord(l_S2Wt); %#ok<*FNDSB>
% Avoid angle wrapping issues with 2 calculations:
v1 = mod(angWake,-2*pi);
v2 = mod(angWake-pi/2,-2*pi)+pi/2;
if std(v1)>std(v2), angWake = v2; else angWake = v1; end
m_angWake = median(angWake); s_angWake = std(angWake);
m_tWake = -m_angWake/2/pi*24+6;

if ~isempty(trueSW)
    angtrueWake  = angCoord(ltrue_S2Wt); %#ok<*FNDSB>
    % Avoid angle wrapping issues with 2 calculations:
    v1 = mod(angtrueWake,-2*pi);
    v2 = mod(angtrueWake-pi/2,-2*pi)+pi/2;
    if std(v1)>std(v2), angtrueWake = v2; else angtrueWake = v1; end
    m_angtrueWake = median(angtrueWake); s_angtrueWake = std(angtrueWake);
    m_ttrueWake = -m_angtrueWake/2/pi*24+6;
    
%     d_angWake = m_angtrueWake - m_angWake;
    d_angWake = rem(m_angtrueWake - m_angWake,2*pi);
    if d_angWake<-pi % bring in the [-pi pi$
        d_angWake = d_angWake + 2*pi;
    elseif d_angWake>pi
        d_angWake = d_angWake - 2*pi;
    end
    d_tWake = d_angWake/(2*pi)*24*60*60; % in seconds
end

%% Get median W/S angles
angSleep = angCoord(l_W2St);
% Avoid angle wrapping issues with 2 calculations:
v1 = mod(angSleep,-2*pi);
v2 = mod(angSleep-pi/2,-2*pi)+pi/2;
if std(v1)>std(v2), angSleep = v2; else angSleep = v1; end
m_angSleep = median(angSleep); s_angSleep = std(angSleep);
m_tSleep = -m_angSleep/2/pi*24+6;

if ~isempty(trueSW)
    angtrueSleep = angCoord(ltrue_W2St);
    % Avoid angle wrapping issues with 2 calculations:
    v1 = mod(angtrueSleep,-2*pi);
    v2 = mod(angtrueSleep-pi/2,-2*pi)+pi/2;
    if std(v1)>std(v2), angtrueSleep = v2; else angtrueSleep = v1; end
    m_angtrueSleep = median(angtrueSleep); s_angtrueSleep = std(angtrueSleep); 
    m_ttrueSleep = -m_angtrueSleep/2/pi*24+6;
    
%     d_angSleep = m_angtrueSleep - m_angSleep;
    d_angSleep = rem(m_angtrueSleep - m_angSleep,2*pi);
    if d_angSleep<-pi % bring in the [-pi pi$
        d_angSleep = d_angSleep + 2*pi;
    elseif d_angSleep>pi
        d_angSleep = d_angSleep - 2*pi;
    end
    d_tSleep = d_angSleep/(2*pi)*24*60*60; % in seconds
end



%% Store results
trueSWtimes = struct( ...
    'angtrueWake', angtrueWake, ...
    'm_angtrueWake', m_angtrueWake, ...
    's_angtrueWake', s_angtrueWake, ...
    'm_ttrueWake', m_ttrueWake, ...
    'd_angWake', d_angWake, ...
    'd_tWake', d_tWake, ...
    'angtrueSleep', angtrueSleep, ...
    'm_angtrueSleep', m_angtrueSleep, ...
    's_angtrueSleep', s_angtrueSleep, ...
    'm_ttrueSleep', m_ttrueSleep, ...
    'd_angSleep', d_angSleep, ...
    'd_tSleep', d_tSleep);
SWtimes = struct( ...
    'angWake', angWake, ...
    'm_angWake', m_angWake, ...
    's_angWake', s_angWake, ...
    'm_tWake', m_tWake, ...
    'angSleep', angSleep, ...
    'm_angSleep', m_angSleep, ...
    's_angSleep', s_angSleep, ...
    'm_tSleep', m_tSleep, ...
    'trueSWt', trueSWtimes);

end
