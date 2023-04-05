function [X, EEGnew] = Compute_FeatureExtractionAverage(EEG,Twin)
% Feature extraction based on average on Twin
% 
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
% Twin -> Time window size (in seconds) to compute the average
%
% OUTPUT:
% X -> Feature matrix [ Ntrials x Nfeatures ]
% 



%% COMPUTE EEG WITH THE AVERAGE FOR EACH TIME WINDOW OF SIZE TWIN

% Total number of trials
Ntrials           = length(EEG.trial);

% Structure with the EEG averaged in each time window of size Twin
EEGnew.fsample    = EEG.fsample;
EEGnew.trial      = cell(1,Ntrials);
EEGnew.time       = cell(1,Ntrials);
EEGnew.label      = EEG.label;

% Number of samples in Twin
Swin              = floor(Twin*EEG.fsample);

% Get the number of channels and samples of the "current trial"
itrial            = 1;
Nchan             = size(EEG.trial{itrial},1);
Nsamp_Old         = size(EEG.trial{itrial},2);

% Compute indices (ini and end) of the time windows to compute the average
Swin_ini          = 1:Swin:Nsamp_Old;
Swin_fin          = Swin_ini+Swin-1;

Swin_ini          = Swin_ini(1:end-1);
Swin_fin          = Swin_fin(1:end-1);

% Number of samples of the "averaged trial" in each time window of size Twin
Nsamp_New         = length(Swin_ini);


%%
% Compute the average across all Twin and save
for itrial = 1:Ntrials

    % Initialize trial old and new
    TrialOld                 = EEG.trial{itrial};
    TrialNew                 = zeros(Nchan,Nsamp_New);
    
    % Compute and save the average of each window
    for iwin = 1:Nsamp_New
        TrialOld_Win         = TrialOld(:,Swin_ini(iwin):Swin_fin(iwin));
        TrialNew(:,iwin)     = mean(TrialOld_Win,2);
    end
    EEGnew.trial{itrial}     = TrialNew;
    
    % Save the time
    EEGnew.time{itrial}      = EEG.time{itrial}(Swin_fin);
end



%% COMPUTE MATRIX X

% Initialize feature matrix X
X  = zeros(Ntrials,Nchan*Nsamp_New);

% Compute feature vector for each trial
for itrial = 1:Ntrials
    X(itrial,:) = EEGnew.trial{itrial}(:)';
end
