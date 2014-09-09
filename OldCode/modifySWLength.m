function [SW] = modifySWLength(SW, trueSW)
%
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

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