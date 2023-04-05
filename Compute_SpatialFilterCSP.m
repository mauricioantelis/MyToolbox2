function [W, lambda, A] = Compute_SpatialFilterCSP(EEG1,EEG2)
% INPUT:
% EEG1 -> EEG structure with trials for class 1, each trial is [Ncha x Nsam]
% EEG2 -> EEG structure with trials for class 2, each trial is [Ncha x Nsam]
%
% OUTPUT:
% W -> Mixing matrix [ Ncha x Ncha ] where spatial filters are columns
% 
% % % NOTE: CSP-based spatial filtered signals are computed as Xsf = Xraw*W,
% % % where:
% % % Xraw -> [ Nsam x Ncha ]
% % % Xsf  -> [ Nsam x Ncha ] 
% % % W    -> [ Ncha x Ncha ]



%% GET DATA MATRIX X1 AND X2

% Construct data matrix for class 1 [ Ncha x Nsam ]
X1  = []; 
for i=1:length(EEG1.trial)
    X1 = [ X1 , EEG1.trial{i}];
end

% Construct data matrix for class 2 [ Ncha x Nsam ]
X2  = [];
for i=1:length(EEG2.trial)
    X2 = [ X2 , EEG2.trial{i}];
end



%% COMPUTE CSP

[W, lambda, A] = Compute_CSP(X1, X2);


