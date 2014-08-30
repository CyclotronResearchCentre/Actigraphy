function [ACTI startTime t] = preprocessing(ACTI, startTime, t, resolution)

%If the ACTI begins with sleep, it is modified until we reach some activity

value = 180;
%value = prctile(ACTI, 33);
windowWidth = 80;
threshold = 80;
index = 0;
for i = 1:length(ACTI)
    %If the total activity in the window is higher than a set threshold,
    %we consider that the recording start at this window
    if sum(ACTI(i:i+windowWidth) > threshold) > 3 * windowWidth / 4
        index = i;
        break;
    end;
end;

ACTI = ACTI(index+windowWidth:end);
t = t(index+windowWidth:end);
startTime = startTime + (index + windowWidth - 1) * datenum(0, 0, 0, 0, 0, resolution);


end
