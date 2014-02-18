function [SW] = modifySWLength(SW, trueSW)

constantes
index1 = 1;
for i = 1:length(trueSW)
    if trueSW(i) == ASLEEP
        index1 = i - 20;
        break;
    end;
end;

index2 = length(trueSW) - 1;
for i = 0:length(trueSW)-1
    if trueSW(end-i) == ASLEEP
        index2 = i - 20;
        break;
    end;
end;

SW(1:index1) = AWAKE;
SW(end-index2:end) = AWAKE;

end