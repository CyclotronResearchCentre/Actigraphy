function y = crc_iqr(x)
% FORMAT y = crc_iqr(x) 
% Returns the interquartile range of the values in X.
% Only workds for a vector!
%__________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by C. Phillips, 2014.
% Cyclotron Research Centre, University of Liege, Belgium

y = diff([crc_percentile(x, 25) crc_percentile(x, 75)]);

end