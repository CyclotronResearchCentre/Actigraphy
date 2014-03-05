function SW = personnalMethod(ACTI)

constantes;

modelfun = @(alpha, r) alpha(1) * r .* r .* r .* r + alpha(2) * r .* r .* r + alpha(3) * r .* r + alpha(4) * r + alpha(5);

alphaInit = [0 0 0 0 0];

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
    window = sort(ACTI(startWindow:endWindow));
    r = 1:(endWindow-startWindow)+1;
    
    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    
    try
        alpha = nlinfit(r, window, modelfun, alphaInit, opts);
    catch exception
        alpha = [0 0 0 0 0];
    end;
    
    alphaInit = alpha;
    
    if sum(alpha(5)) > 30
        SW(i) = 1;
    end;
end;

end