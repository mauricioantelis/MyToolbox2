function [X, EEGnew] = Compute_FeatureExtractionAverageAllChannels(EEG)
% Feature extraction based on average across all channels
% 
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
%
% OUTPUT:
% X -> Feature matrix [ Ntrials x Nfeatures ]
% 


%% COMPUTE EEG WITH THE AVERAGE ACROSS ALL CHANNELS

% Total number of trials
Ntrials           = length(EEG.trial);

EEGnew  = EEG;
for i=1:Ntrials
    EEGnew.trial{i} = mean(EEG.trial{i},1);
end
EEGnew.label    = [];
EEGnew.label{1} = 'Avg';



%% COMPUTE MATRIX X

% ----------------------------------------------
% Feature vector for each trial
% x = [Sample_1, Sample_2,...,Sample_Ns]
% x is a vector of [ 1 x Nfeatures ] where Nfeatures is equal to Ns
% 
% Matriz of featutes
% X = [x1 ; x2 ; ... ; xNtrials]
% X is a matrix of [ Ntrials x Nfeatures ]

% ----------------------------------------------
% Initialize feature matrix X

Nsamp = size(EEGnew.trial{1},2);

X  = zeros(Ntrials,Nsamp);

% Compute feature vector for each trial
for itrial = 1:Ntrials
    X(itrial,:) = EEGnew.trial{itrial}(:)';
end
