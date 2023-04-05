%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE

% Clear all
clear
close all
clc

% Agregar fieldtrip path
path(path,'C:\Antelis\fieldtrip-20200911'), ft_defaults

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA

% ----------------------------------------------
% LOAD DATA
load('EEG_P1_MotorImagery')



%%





% ----------------------------------------------
% PREPROCESSING: RESAMPLING
cfg                       = [];
cfg.resamplefs            = 160;
cfg.detrend               = 'no';
EEG                       = ft_resampledata(cfg,EEG);
EEG                       = rmfield(EEG,'cfg');



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE TFR

% ----------------------------------------------
% COMPUTE TFR
cfg                   = [];
cfg.method            = 'tfr';
cfg.output            = 'pow';
cfg.waveletwidth      = 7;
cfg.keeptrials        = 'yes';
cfg.channel           = 'all';
cfg.foi               = 4:1:40;
cfg.toi               = EEG.time{1}(1:2:end);
TFR                   = ft_freqanalysis(cfg,EEG); % TFRcond1.powspctrm = 10*log10(TFRcond1.powspctrm);

% ----------------------------------------------
% COMPUTE ERDS
cfg                   = [];
cfg.baseline          = [1 3];
cfg.baselinetype      = 'percentage'; % (relative|absolute|percentage)
cfg.alpha             = 0.01;
cfg.ComputeMask       = 'no';
ERDS                  = Compute_Bootstat4TFR(cfg,TFR);


% ----------------------------------------------
% Load layout
load('MyLayout')

% ----------------------------------------------
% PLOT ERDERS MAPS
cfg              = [ ];
cfg.zparam       = 'powspctrmsignificant'; %(powspctrmbaseline|powspctrmsignificant)
cfg.zlim         = 1.5*ERDS.zlim;
cfg.showlabels   = 'yes';
cfg.fontsize     = 8;
cfg.box          = 'off';
cfg.colorbar     = 'yes';
cfg.showoutline  = 'yes';
cfg.comment      = 'off';
% cfg.maskstyle    = 'saturation';
cfg.layout       = MyLayout;
cfg.xlim         = [ERDS.time(1) ERDS.time(end)];
ft_multiplotTFR(cfg,ERDS);
clear ans cfg


