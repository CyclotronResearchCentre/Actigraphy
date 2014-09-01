function plotCircle(SW, trueSW, startTime, nbDataPerDays)

% ! PLOT ON A CIRCLE !

constantes

radius = 1;
colors = ['b', 'r']; %BLUE = sleep, RED = wake
ang = getStartAngle(startTime);
angStep = 2 * pi / nbDataPerDays; % Δtheta between two successives points on the circle
origin = [0, 0]; %Center of the circle

figure;
hold on;
axis equal;
% 
% %Plot an horizontal line
% plot(linspace(0, 0, 20001), -100:0.01:100, 'k');
% 
% %Plot a vertical line
% plot(-100:0.01:100, linspace(0, 0, 20001), 'k');

sleepCoordinates = [0; 0]; %Coordinates of the transitions Wake -> Sleep
wakeCoordinates = [0; 0]; %Coordinates of the transitions Sleep -> Wake
state = SW(1);

if ~isempty(trueSW)
    trueSleepCoordinates = [];
    trueWakeCoordinates = [];
    trueState = trueSW(1);
end;

for i = 1:length(SW)
    %End of day i = beginning of day i+1
    if ang <= - 3 * pi / 2
        ang = pi / 2;
    end;
    
    circle(origin(1), origin(2), radius, ang, colors(SW(i) + 1));
    
    %A ring is put at every transition (Sleep -> Wake or Wake
    %-> Sleep)
    if (SW(i) ~= state)
        [x y] = drawRing(origin(1), origin(2), radius, ang, 'k');
        if (SW(i) == ASLEEP)
            sleepCoordinates = [sleepCoordinates [x; y]];
        else
            wakeCoordinates = [wakeCoordinates [x; y]];
        end;
    end;
    
    if ~isempty(trueSW)
        %The same is done with the trueSW
        if (trueSW(i) ~= trueState)
            [x y] = drawRing(origin(1), origin(2), radius, ang, 'g');
            if (trueSW(i) == ASLEEP)
                trueSleepCoordinates = [trueSleepCoordinates [x; y]];
            else
                trueWakeCoordinates = [trueWakeCoordinates [x; y]];
            end;
        end;
        
        trueState = trueSW(i);
    end;
    
    state = SW(i);
    ang = ang - angStep;
    radius = radius + 0.01;
end;

plot(-radius-10:0.1:radius+10, -radius-10:0.1:radius+10, 'w'); %Useless plot to increase the window size ( yeah, it's not beautiful )

%Plot a line that fits the sleep times
x_max = max(sleepCoordinates(1, :));
x_min = min(sleepCoordinates(1, :));

x_mean = mean(sleepCoordinates(1, :));
y_mean = mean(sleepCoordinates(2, :));

sleepSlope = y_mean / x_mean;

p(1) = plot(0:0.1:x_max, sleepSlope .* (0:0.1:x_max), 'k');

%Plot a line that fits the up times
x_max = max(wakeCoordinates(1, :));
x_min = min(wakeCoordinates(1, :));

x_mean = mean(wakeCoordinates(1, :));
y_mean = mean(wakeCoordinates(2, :));

wakeSlope = y_mean / x_mean;

plot(0:0.1:x_max, wakeSlope .* (0:0.1:x_max), 'k');

if ~isempty(trueSW)
    %Plot a line that fits the true sleep times
    x_max = max(trueSleepCoordinates(1, :));
    x_min = min(trueSleepCoordinates(1, :));
    
    x_mean = mean(trueSleepCoordinates(1, :));
    y_mean = mean(trueSleepCoordinates(2, :));
    
    trueSleepSlope = y_mean / x_mean;
    
    p(2) = plot(0:0.1:x_max, trueSleepSlope .* (0:0.1:x_max), 'g');
    
    %Plot a line that fits the true up times
    x_max = max(trueWakeCoordinates(1, :));
    x_min = min(trueWakeCoordinates(1, :));
    
    x_mean = mean(trueWakeCoordinates(1, :));
    y_mean = mean(trueWakeCoordinates(2, :));
    
    trueWakeSlope = y_mean / x_mean;
    
    plot(x_min:0.1:x_max, trueWakeSlope .* (x_min:0.1:x_max), 'g');
    
    legend(p, 'Estimated times', 'True times');
    
    sleepAngleTime = getAngle(sleepSlope, trueSleepSlope);
    wakeAngleTime = getAngle(wakeSlope, trueWakeSlope);    
    fprintf('Sleep Angle (minutes) : %f \n', sleepAngleTime);
    fprintf('Wake Angle (minutes) : %f \n\n', wakeAngleTime);
end;

%Add some text informations
text(-9, radius, 'Midnight');
text(radius, 0, '6AM');
text(-7, -radius, 'Noon');
text(-radius-20, 0, '6PM');

            
end