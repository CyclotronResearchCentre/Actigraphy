function dd=readcoglog(filename)

% Open File
file = fopen(filename);

% Empty cell array 
c={};
i=1;

% For each line in file
while 1
    % Read line
    line = fgetl(file);
    % If end of file finish loop
    if ~isstr(line)
        break;
    end;
    % Cell element i made equal to this line
    c{i}=line;

    i=i+1;
end;

% Transpose to a column vector of lines
c=c';
fclose(file);
 
% Divide lines into words
d=c;
dd={};

for i=1:length(d)
    wordarray = {};
    remainder = d{i};
    j = 1;

    while 1
        %Remainder is divided in 2 pieces : the first word is put in
        %wordarray{j}, the rest is put in remainder
        [wordarray{j}, remainder] = strtok(remainder);
        
        %If nothing remains, this is the end of the line
        if(isempty(remainder))
            break;
        end;
        j=j+1;
    end;

    dd{i} = wordarray;
end;

dd=dd';

end