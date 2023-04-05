function [X, EEGsf] = Compute_SpatialFilterCCAapply(EEG,W,Nsf)
% Apply spatial filter based on CCA
%
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
% W   -> Mixing matrix W [ Ncha x Ncha ]
% Nsf -> Number of spatial filter where Nsf<=Ncha
%
% OUTPUT:
% EEGsf -> EEG structure with trials after spatial filter, each trial is [Nsf x Nsam]
% X -> feature matrix [Nsam*Ntrials Nsf]
% 
% NOTE: CCA-based spatial filtered signals are computed as Xsf = Xraw*W,
% where:
% Xraw -> [ Nsam x Ncha ]
% Xsf  -> [ Nsam x Ncha ] 
% W    -> [ Ncha x Ncha ]
% or, if Nsf<=Ncha spatial filters are used, then Xsf = Xraw*W(:,1:Nsf),
% where:
% Xraw       -> [ Nsam x Ncha ]
% Xsf        -> [ Nsam x Nsf ] 
% W(:,1:Nsf) -> [ Ncha x Nsf ]



%% VERIFY

Nchan = size(W,1);
if Nsf>Nchan
    error('PILAS: Nsf is greather than Nchan')
end



%% COMPUTE CCA-BASED SPATIAL FILTERED EEG AND FEATURE MATRIX

% Compute number of trials
Ntrials           = length(EEG.trial);

% Initialize structure for the CCA-based spatial filtered EEG
EEGsf.fsample     = EEG.fsample;
EEGsf.trial       = cell(1,Ntrials);
EEGsf.time        = EEG.time;
for i=1:Nsf
    EEGsf.label{i,1}  = ['SF' num2str(i)];
end

% Compute number of samples
itrial            = 1;
Nsamp             = size(EEG.trial{itrial},2);

% Initialize feature matrix
X                 = zeros(length(EEG.trial),Nsf*Nsamp);

% For each trial...
for i=1:Ntrials
    
    % Initialize Xraw
    Xraw                     = EEG.trial{i}';      % [Nsam x Ncha]
    
    % Compute spatial filtered data
    Xsf                      = Xraw * W(:,1:Nsf);  % [Nsam x Nsf]
    EEGsf.trial{i}           = Xsf';
    
    % Save feature vector
    X(i,:)                   =  Xsf(:);
end



