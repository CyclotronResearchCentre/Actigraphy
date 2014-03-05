function [ACTI trueSW startTime t] = modifyLength(ACTI, trueSW, startTime, t, resolution)

constantes;

start = 1;
for i = 1:length(trueSW)
    if trueSW(i) == ASLEEP
        start = i - 200;
        break;
    end;
end;

if start < 1
    start = 1;
end;

ending = 0;
for i = 1:length(trueSW)
    if trueSW(end-i) == ASLEEP
        ending = length(trueSW) - (i - 200);
        break;
    end;
end;

if ending > length(trueSW)
    ending = length(trueSW);
end;

ACTI = ACTI(start:ending);
trueSW = trueSW(start:ending);
t = t(start:ending);
startTime = startTime + (start - 1) * datenum(0, 0, 0, 0, 0, resolution);



end