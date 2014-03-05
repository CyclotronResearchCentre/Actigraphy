function plotCircle(SW, trueSW, startTime, nbDataPerDays)

% ! AFFICHAGE SUR CERCLE !

constantes

radius = 1;
colors = ['b', 'r']; %Bleu = sommeil, Rouge = éveil
ang = getStartAngle(startTime);
angStep = 2 * pi / nbDataPerDays; % Δtheta entre deux points consécutifs sur le cercle
origin = [0, 0]; %Centre du cercle


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

trueSleepCoordinates = [];
trueWakeCoordinates = [];

state = SW(1);
trueState = trueSW(1);
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
    
    %The same is done with the trueSW
    if (trueSW(i) ~= trueState)
        [x y] = drawRing(origin(1), origin(2), radius, ang, 'g');
        if (trueSW(i) == ASLEEP)
            trueSleepCoordinates = [trueSleepCoordinates [x; y]];
        else
            trueWakeCoordinates = [trueWakeCoordinates [x; y]];
        end;
    end;
    
    state = SW(i);
    trueState = trueSW(i);
    ang = ang - angStep;
    radius = radius + 0.01;
end;

plot(-radius-10:0.1:radius+10, -radius-10:0.1:radius+10, 'w'); %Useless plot to increase the window size ( :puke: )

%Plot a line that fits the sleep times
x_max = max(sleepCoordinates(1, :));
x_min = min(sleepCoordinates(1, :));

x_mean = mean(sleepCoordinates(1, :));
y_mean = mean(sleepCoordinates(2, :));

sleepSlope = y_mean / x_mean;

p(1) = plot(x_min:0.1:x_max, sleepSlope .* (x_min:0.1:x_max), 'k');
legend('Estimated sleep time')

%Plot a line that fits the up times
x_max = max(wakeCoordinates(1, :));
x_min = min(wakeCoordinates(1, :));

x_mean = mean(wakeCoordinates(1, :));
y_mean = mean(wakeCoordinates(2, :));

wakeSlope = y_mean / x_mean;

plot(x_min:0.1:x_max, wakeSlope .* (x_min:0.1:x_max), 'k');

%Plot a line that fits the true sleep times
x_max = max(trueSleepCoordinates(1, :));
x_min = min(trueSleepCoordinates(1, :));

x_mean = mean(trueSleepCoordinates(1, :));
y_mean = mean(trueSleepCoordinates(2, :));

trueSleepSlope = y_mean / x_mean;

p(2) = plot(x_min:0.1:x_max, trueSleepSlope .* (x_min:0.1:x_max), 'g');

%Plot a line that fits the true up times
x_max = max(trueWakeCoordinates(1, :));
x_min = min(trueWakeCoordinates(1, :));

x_mean = mean(trueWakeCoordinates(1, :));
y_mean = mean(trueWakeCoordinates(2, :));

trueWakeSlope = y_mean / x_mean;

plot(x_min:0.1:x_max, trueWakeSlope .* (x_min:0.1:x_max), 'g');

%Add some text informations
legend(p, 'Estimated times', 'True times');

text(-9, radius, 'Midnight');
text(radius, 0, '6AM');
text(-7, -radius, 'Noon');
text(-radius-20, 0, '6PM');

sleepAngleTime = getAngle(sleepSlope, trueSleepSlope);
wakeAngleTime = getAngle(wakeSlope, trueWakeSlope);

fprintf('Sleep Angle (minutes) : %f \n', sleepAngleTime);
fprintf('Wake Angle (minutes) : %f \n\n', wakeAngleTime);

            
end