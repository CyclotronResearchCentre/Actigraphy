function crc_ara_defaults
% Sets the defaults which are used by ARA:
% "Actigraphic Recording Analysis" Toolbox
%
% FORMAT crc_ara_defaults
%_______________________________________________________________________
%
% This file can be customised to any the site/person own setup.
% Individual users can make copies which can be stored on their own
% matlab path. Make sure your 'crc_ara_ defaults' is the first one found in
% the path. See matlab documentation for details on setting path.
%
% Care must be taken when modifying this file!
%
% The structure and content of this file are largely inspired by SPM's 
% similar function.
%_______________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre

% Written by C. Phillips, 2014
% Cyclotron Research Centre, University of Liege, Belgium

%%
global crc_ara_def

%% Directory
if ispc
    crc_ara_def.dir.datadir = 'C:\Dropbox\Work\4_Partage\Actigraphy_TMS'; % Directory where the *.AWD files are stored
    crc_ara_def.dir.refdir  = 'C:\Dropbox\Work\4_Partage\Actigraphy_TMS'; % Directory where the reference .xls files are stored
else
    crc_ara_def.dir.datadir = '/Users/chrisp/Dropbox/Work/4_Partage/Actigraphy_TMS'; % Directory where the *.AWD files are stored
    crc_ara_def.dir.refdir  = '/Users/chrisp/Dropbox/Work/4_Partage/Actigraphy_TMS'; % Directory where the reference .xls files are stored
end

%% Modes for the main function
% crc_ara_def.mode.INDIVIDUAL = 1;
% crc_ara_def.mode.COMPARISON = 2;
% crc_ara_def.mode.GROUP = 3;

%% Preprocessing
crc_ara_def.preproc.windowWidth = 80; % expressed in time bins!
crc_ara_def.preproc.threshold = 80; % expressed in signal amplitude

%% Removing zeros
crc_ara_def.rmzeros.thresh   = 10; % amplitude threshold (in signal amplitude)
crc_ara_def.rmzeros.dur      = 90; % duration of 'zero episode' (in time bins!)
crc_ara_def.rmzeros.dur_fill = 30; % filling duration (in time bins!)

%% Sleep/Wake values
crc_ara_def.sw.ASLEEP = 0;
crc_ara_def.sw.AWAKE  = 1;

%% ACTI constantes
crc_ara_def.acti.res_opt.dispActiSW = true; % Display SW and ACTI time series
crc_ara_def.acti.res_opt.dispSpirSW = true; % Display SW on circle
crc_ara_def.acti.res_opt.dispSpirAC = true; % Display ACTI data on circle
crc_ara_def.acti.res_opt.calcExtra  = false; % Estimate extra parameters
crc_ara_def.acti.res_opt.saveRes    = false;% Save the results for each data file
crc_ara_def.acti.sleepToWakeSec = 1800; % in sec (waking up = 30 active minutes activity)
crc_ara_def.acti.wakeToSleepSec = 1800; % in sec (falling asleep = 30 inactive minutes)
crc_ara_def.acti.useNN = true; % use NN to improve Crespo solution, or not

%% Crespo constantes
crc_ara_def.crespo.z = 15;
crc_ara_def.crespo.za = 2;
crc_ara_def.crespo.zr = 30;
crc_ara_def.crespo.winAlpha = 1;
crc_ara_def.crespo.Lp = 60 + 1;
crc_ara_def.crespo.Lw = 150;
crc_ara_def.crespo.hs = 8;
crc_ara_def.crespo.percentile = 33;

%% Learning parameters
crc_ara_def.learn.windowLength = 15; % window size on which features are extracted
crc_ara_def.learn.winTest = 60; % window size around 1st estimate of transition
crc_ara_def.learn.skipBE = 60; % window skipped at beginning and end
crc_ara_def.learn.threshL = .99; % decision threshold

%% Bed & Up time constantes
crc_ara_def.but.factor = 1.8;

%% Comparison constantes
crc_ara_def.comp.ALL_SLEEP = 0;
crc_ara_def.comp.ALL_WAKE = 1;
crc_ara_def.comp.ALL_RANDOM = 2;

%% Excell file convention
crc_ara_def.xls.ext = '.xlsx' ; % file extension
crc_ara_def.xls.fn_append = '_sleep analysis';

end