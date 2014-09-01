function [data] = readActi(fileName)
%
% FORMAT [data] = readActi(fileName)
% 
% Breaks every line in words and puts everything in the array data
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by M. Gonzalez Y Viagas & C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

fid = fopen(fileName);
tmp = textscan(fid, '%s','delimiter','\n','whitespace','');
fclose(fid);
data = tmp{1}';

% 
% file = fopen(fileName);
% lines = {};
% i = 1;
% 
% % Reads the file line by line
% line = 1;
% while line~=-1
%     line = fgetl(file);   
%     lines{i} = line;
%     i = i + 1;
% end;
% while 1
%     line = fgetl(file);
%     if line == -1
%         break;
%     end;
%     
%     lines{i} = line;
%     
%     i = i + 1;
% end;
% fclose(file);
% 
% 
% 
% 
% data = {};
% 
% for i = 1:length(lines)
%     line = lines(i);
%     j = 1;
%     while ~isempty(line{1})
%         [word line] = strtok(line);
%         data{i}{j} = word{1};
%         j = j + 1;
%     end;
% end;

end