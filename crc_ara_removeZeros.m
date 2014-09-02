function ACTI = crc_ara_removeZeros(ACTI)
% 
% FORMAT ACTI = crc_ara_removeZeros(ACTI)
%
% Removes the zones where too many zeros follow each others.
% Checks signal below some threshold ('tresh') for a sufficiently long 
% period ('dur'), then pads with the maximum value of ACTO over some 
% specific window ('dur_fill').
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

ara_def  = crc_ara_get_defaults('rmzeros');
thresh   = ara_def.thresh ;
dur      = ara_def.dur ;
dur_fill = ara_def.dur_fill ;

nbZeros = 0;

for ii = 1:length(ACTI)
    
    if ACTI(ii) < thresh
        nbZeros = nbZeros + 1;
    else
        nbZeros = 0;
    end;
    
    if nbZeros > dur
        ACTI(ii-dur_fill:ii) = max(ACTI);
    end;
end;


end