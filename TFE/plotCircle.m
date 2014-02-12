function plotCircle(SW, startTime, nbDataPerDays)

% ! AFFICHAGE SUR CERCLE !

constantes

radius = 1;
colors = ['b', 'r']; %Bleu = sommeil, Rouge = éveil
ang = getStartAngle(startTime);
angStep = 2 * pi / nbDataPerDays; % Δtheta entre deux points consécutifs sur le cercle
origin = [0, 0]; %Centre du cercle


figure;
hold on;
axis square;

%Plot an horizontal line
plot(linspace(0, 0, 20001), -100:0.01:100, 'k');

%Plot a vertical line
plot(-100:0.01:100, linspace(0, 0, 20001), 'k');

sleepCoordinates = [0; 0]; %Coordinates of the transitions Wake -> Sleep
wakeCoordinates = [0; 0]; %Coordinates of the transitions Sleep -> Wake

state = SW(1);
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
    
    state = SW(i);
    ang = ang - angStep;
    radius = radius + 0.01;
end;

x_mean = mean(sleepCoordinates(1, :));
y_mean = mean(sleepCoordinates(2, :));

plot(-1:0.1:5, (y_mean / x_mean) .* (-1:0.1:5), 'g');

x_mean = mean(wakeCoordinates(1, :));
y_mean = mean(wakeCoordinates(2, :));

plot(-1:0.1:5, (y_mean / x_mean) .* (-1:0.1:5), 'g');
            
end