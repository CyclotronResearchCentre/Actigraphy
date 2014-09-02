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


end