function [data] = readActi(fileName)

file = fopen(fileName);

lines = {};
i = 1;

%Reads the file line by line
while 1
    line = fgetl(file);
    if line == -1
        break;
    end;
    
    lines{i} = line;
    
    i = i + 1;
end;
fclose(file);

%Breaks every line in words and puts everything in the array data
data = {};

for i = 1:length(lines)
    line = lines(i);
    j = 1;
    while ~isempty(line{1})
        [word line] = strtok(line);
        data{i}{j} = word{1};
        j = j + 1;
    end;
end;

end