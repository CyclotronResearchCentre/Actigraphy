function [ACTI trueSW startTime t] = modifyLength(ACTI, trueSW, startTime, t, resolution)

constantes;

%Finds the first "Awake" record. The start of the recording is set to
%300 records before it.
start = 1;
for i = 1:length(trueSW)
    if trueSW(i) == ASLEEP
        start = i - 300;
        break;
    end;
end;

if start < 1
    start = 1;
end;

%Finds the first "Awake" record. The start of the recording is set to
%500 records after it. (300 and 500 are arbitrary chosen)
ending = 0;
for i = 1:length(trueSW)
    if trueSW(end-i) == ASLEEP
        if i < 500
            ending = length(trueSW);
        else
            ending = length(trueSW) - (i - 500);
        end;
        break;
    end;
end;

if ending > length(trueSW)
    ending = length(trueSW);
end;

%ACTI and trueSW are modified to only contains records between start and
%ending
ACTI = ACTI(start:ending);
trueSW = trueSW(start:ending);
t = t(start:ending);
startTime = startTime + (start - 1) * datenum(0, 0, 0, 0, 0, resolution);



end