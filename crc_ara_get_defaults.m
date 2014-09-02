function varargout = crc_ara_get_defaults(defstr, varargin)
% Get/set the defaults values associated with an identifier
% FORMAT defaults = crc_ara_get_defaults
% Return the global "defaults" variable defined in crc_ara_defaults.m.
%
% FORMAT defval = crc_ara_get_defaults(defstr)
% Return the defaults value associated with identifier "defstr". 
% Currently, this is a '.' subscript reference into the global  
% "crc_ara_def" variable defined in crc_ara_defaults.m.
%
% FORMAT crc_ara_get_defaults(defstr, defval)
% Sets the defaults value associated with identifier "defstr". The new
% defaults value applies immediately to:
% * new modules in batch jobs
% * modules in batch jobs that have not been saved yet
% This value will not be saved for future sessions of ARA. To make
% persistent changes, edit crc_ara_defaults.m.
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
% Copyright (C) 2014 Cyclotron Research Centre

% Volkmar Glauche
% Then modified for use with the ARA toolbox by Christophe Phillips

global crc_ara_def;
if isempty(crc_ara_def)
    crc_ara_defaults;
end

if nargin == 0
    varargout{1} = crc_ara_def;
    return
end

% construct subscript reference struct from dot delimited tag string
tags = textscan(defstr,'%s', 'delimiter','.');
subs = struct('type','.','subs',tags{1}');

if nargin == 1
    varargout{1} = subsref(crc_ara_def, subs);
else
    crc_ara_def = subsasgn(crc_ara_def, subs, varargin{1});
end
