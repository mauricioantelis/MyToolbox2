function [X, EEGnew] = Compute_FeatureExtractionDecimation(EEG,fac)
% Feature extraction based on decimation
%
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
% fac -> decimation factor
%
% OUTPUT:
% X -> Feature matrix [ Ntrials x Nfeatures ]
% 



%% COMPUTE EEG DECIMATED STRUCTURE

% Total number of trials
Ntrials           = length(EEG.trial);

% Structure with the EEG averaged in each time window of size Twin
EEGnew.fsample    = EEG.fsample;
EEGnew.trial      = cell(1,Ntrials);
EEGnew.time       = cell(1,Ntrials);
EEGnew.label      = EEG.label;

% Compute indices of the time samples to get the decimated data
itrial            = 1;
Nchan             = size(EEG.trial{itrial},1);
Nsamp             = size(EEG.trial{itrial},2);
ind               = 1:fac:Nsamp;

% Number of samples of the "decimated trial"
Nsamp_New         = length(ind);

% Compute the average across all Twin and save
for itrial = 1:Ntrials
    
    % Initialize trial old and new
    TrialOld                 = EEG.trial{itrial};
    TrialNew                 = TrialOld(:,ind);
    EEGnew.trial{itrial}     = TrialNew;
    
    % Save the time
    EEGnew.time{itrial}      = EEG.time{itrial}(ind);
end



%% COMPUTE MATRIX X

% Initialize feature matrix X
X  = zeros(Ntrials,Nchan*Nsamp_New);

% Compute feature vector for each trial
for itrial = 1:Ntrials
    X(itrial,:) = EEGnew.trial{itrial}(:)';
end