function X = Compute_SpatialFilterCSPapply(EEG,W,Nsf)
% Apply spatial filter based on CSP
%
% INPUT:
% EEG -> EEG structure with trials for class 1, each trial is [Ncha x Nsam]
% W -> Mixing matrix [ Ncha x Ncha ]
% Nsf -> Number of spatial filters
%
% OUTPUT:
% EEGsf -> EEG structure with trials after spatial filter, each trial is [2*Nsf x Nsam]
% X -> feature matrix [Nsam*Ntrials 2*Nsf]
% 
% % NOTE: CSP-based spatial filters signals are computed as Xsf = W'*Xraw;
% % Xraw -> [ Ncha x Nsam ]
% % Xsp -> [Ncha x Nsamp]
% % W -> [ Ncha x Ncha ]
% % or, if Nsf<=Ncha/2 spatial filters are used, then Xsf = W(:,[1:Nsf (Nchan-Nsf+1):Nchan])'*Xraw,
% % where:
% % Xraw -> [ Ncha x Nsam ]
% % Xsf -> [ 2*Nsf x Nsam ] 
% % W(:,[1:Nsf (Nchan-Nsf+1):Nchan]) -> [ Ncha x 2*Nsf ]



%% COMPUTE PARAMETERS

% Compute parameter
Nchan = size(W,1);
ipt   = [1:Nsf (Nchan-Nsf+1):Nchan];



%% COMPUTE CSP

Ntrials = length(EEG.trial);

X       = zeros(length(EEG.trial),2*Nsf);

for i=1:Ntrials
    
    Xcsp    = W' * EEG.trial{i};
    Xcsp    = Xcsp(ipt,:);
  
    fp      = var(Xcsp,0,2)';
    fp      = fp/sum(fp);
    
    X(i,:)  =  fp;
end


