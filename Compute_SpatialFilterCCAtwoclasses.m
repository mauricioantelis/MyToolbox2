function W = Compute_SpatialFilterCCAtwoclasses(EEG1,EEG2)
% Compute spatial filters based on CCA for EEG data of two classes
%
% INPUT:
% EEG1 -> EEG structure with trials for class 1, each trial is [Ncha x Nsam]
% EEG2 -> EEG structure with trials for class 2, each trial is [Ncha x Nsam]
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

% Construct data matrix for class 1 [(Nsam*Ntrials) x Ncha]
X1  = []; 
for i=1:length(EEG1.trial)
    X1 = [ X1 , EEG1.trial{i}];
end
X1 = X1'; % [(Nsam*Ntrials) x Ncha]

% Construct data matrix for class 2 [(Nsam*Ntrials) x Ncha]
X2  = []; 
for i=1:length(EEG2.trial)
    X2 = [ X2 , EEG2.trial{i}];
end
X2 = X2'; % [(Nsam*Ntrials) x Ncha]



%% COMPUTE AVERAGE AND REPLICATE IT TO GET DATA MATRIX Y

% Compute Average
cfg                 = [];
cfg.keeptrials      = 'no';
cfg.covariance      = 'no';
EEG1AVG             = ft_timelockanalysis(cfg,EEG1);
EEG2AVG             = ft_timelockanalysis(cfg,EEG2);

% Construct replicated average data matrix [(Nsam*Ntrials) x Ncha]
Y1  = []; 
for i=1:length(EEG1.trial)
    Y1 = [ Y1 , EEG1AVG.avg];
end
Y1 = Y1'; % [(Nsam*Ntrials) x Ncha]
% NOTE: use "repelem" instead of the bucle

% Construct replicated average data matrix [(Nsam*Ntrials) x Ncha]
Y2  = []; 
for i=1:length(EEG2.trial)
    Y2 = [ Y2 , EEG2AVG.avg];
end
Y2 = Y2'; % [(Nsam*Ntrials) x Ncha]
% NOTE: use "repelem" instead of the bucle 



%% COMPUTE CCA BETWEEN X AND Y

X = [X1 ; X2];
Y = [Y1 ; Y2];

% X -> [Nsam*(Ntrials1+Ntrials2) x Ncha]
% Y -> [Nsam*(Ntrials1+Ntrials2) x Ncha]
W = canoncorr(X,Y);



