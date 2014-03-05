function [ACTI] = preprocessing(ACTI)

%If the ACTI begins with sleep, it is modified until we reach some activity

value = 180;
%value = prctile(ACTI, 33);
windowWidth = 80;
threshold = 80;
index = 0;
for i = 1:length(ACTI)
    if sum(ACTI(i:i+windowWidth) > threshold) > windowWidth - 20
        index = i;
        break;
    end;
end;

ACTI(1:index+windowWidth) = value;

end