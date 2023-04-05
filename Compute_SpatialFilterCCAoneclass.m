function W = Compute_SpatialFilterCCAoneclass(EEG1)
% Compute spatial filters based on CCA for EEG data of one class only
%
% INPUT:
% EEG1 -> EEG structure with trials for class 1, each trial is [Ncha x Nsam]
%
% OUTPUT:
% W -> Mixing matrix [ Ncha x Ncha ]
%
% NOTE: CCA-based spatial filtered signals are computed as Xsf = Xraw*W,
% where:
% Xraw -> [ Nsam x Ncha ]
% Xsf  -> [ Nsam x Ncha ] 
% W    -> [ Ncha x Ncha ]



%% GET DATA MATRIX X

% Construct data matrix[(Nsam*Ntrials) x Ncha]
X  = []; 
for i=1:length(EEG1.trial)
    X = [ X , EEG1.trial{i}];
end
X = X'; % [(Nsam*Ntrials) x Ncha]



%% COMPUTE AVERAGE AND REPLICATE IT TO GET DATA MATRIX Y

% Compute Average
cfg                 = [];
cfg.keeptrials      = 'no';
cfg.covariance      = 'no';
EEG1AVG             = ft_timelockanalysis(cfg,EEG1);

% Construct replicated average data matrix [(Nsam*Ntrials) x Ncha]
Y  = []; 
for i=1:length(EEG1.trial)
    Y = [ Y , EEG1AVG.avg];
end
Y = Y'; % [(Nsam*Ntrials) x Ncha]
% NOTE: use "repelem" instead of the bucle 



%% COMPUTE CCA BETWEEN X AND Y

% X -> [(Nsam*Ntrials) x Ncha]
% Y -> [(Nsam*Ntrials) x Ncha]
W = canoncorr(X,Y);



