function ACTI = removeZeros(ACTI)

nbZeros = 0;

%Removes the zones where too many zeros follow each others
for i = 1:length(ACTI)
    
    if ACTI(i) < 10
        nbZeros = nbZeros + 1;
    else
        nbZeros = 0;
    end;
    
    if nbZeros > 90
        ACTI(i-30:i) = max(ACTI);
    end;
end;


end