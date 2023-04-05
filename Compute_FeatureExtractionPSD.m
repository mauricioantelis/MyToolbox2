function [X, POWER] = Compute_FeatureExtractionPSD(EEG,cfgin)
% Feature extraction based on Power Spectral Density
%
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
% cfg -> info
%
% OUTPUT:
% X -> Feature matrix [ Ntrials x Nfeatures ]
% 



%% COMPUTE XXX

% ----------------------------------------------
% Compute PSD
cfg              = [];
cfg.keeptrials   = 'yes';
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'dpss'; % ('dpss','hanning')
cfg.foi          = cfgin.foi;
cfg.tapsmofrq    = cfgin.tapsmofrq;
POWER            = ft_freqanalysis(cfg,EEG);


%% COMPUTE MATRIX X

% Construct X: Ch1_F1, Ch2_F1, Ch3_F1, Ch1_F2, Ch2_F2,...
[ Ntrials,Nchan,Nfreq ] = size(POWER.powspctrm);
X  = reshape(POWER.powspctrm,Ntrials,Nchan*Nfreq);