function SW = piresMethod(ACTI)

constantes;

modelfun = @(theta, r) theta(1)*sqrt(2/pi)*((r-theta(3)).*(r-theta(3))/(theta(2)^3)).*exp(-((r-theta(3)).*(r-theta(3))/(theta(2)^3))) ...
+ theta(4)*(1/sqrt(2*pi))*(1/theta(5)).*exp(-((r-theta(6)).*(r-theta(6))/(2*theta(5)^2)));
thetaInit = [0 15 10 1 5 2];

SW = zeros(1, length(ACTI));

for i = 1:length(ACTI)
    startWindow = i - W;
    endWindow = i + W;
    if startWindow < 1
        startWindow = 1;
    end;
    if endWindow > length(ACTI)
        endWindow = length(ACTI);
    end;
    window = ACTI(startWindow:endWindow);
    
    [y, r] = hist(window, 50);
    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    try
        theta = nlinfit(r, y, modelfun, thetaInit, opts);
    catch exception
        theta = [0 15 10 1 5 2];
    end;
    
    thetaInit = theta;
    if theta(1) > theta(2)
        SW = 1;
    end;
end;

end