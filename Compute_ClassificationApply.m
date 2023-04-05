function [YEsti, YScore] = Compute_ClassificationApply(XTest,M,Classifier,Normalization)
% Apply inputs to a trainned classification algorithm
%
% INPUT:
% XTest -> Data matrix [Nsam x Nfea]
% M     -> Learned classification model. It contains M.Wnorm and M.Model
% Classifier    -> type of classification model: 'LDA','SVML','SVMR'
% Normalization -> Type of normalization
%
% OUTPUT:
% YEsti  -> Classification label, estimated label [Nsam x 1]
% YScore -> Classification scores [Nsam x 1]
% 



%% TEST CLASSIFIER

% # ---------------------------------------------
% # Apply normalization to the Xtest data
XTest = Compute_Normalize(XTest,Normalization,M.Wnorm);

% # ---------------------------------------------
% # Classify XTest data
if     strcmp(Classifier,'LDA')
    [YEsti, YScore]  = predict(M.Model,XTest);
    
elseif strcmp(Classifier,'rLDA')
    [YEsti, YScore]  = predict(M.Model,XTest);
    
elseif strcmp(Classifier,'SVML')
    [YEsti, YScore]  = predict(M.Model,XTest);
    %addpath('C:\Antelis\mexlibSVM')
    %YEsti = svmpredict(YTest,XTest,Model);
    
elseif strcmp(Classifier,'SVMR')
    [YEsti, YScore]  = predict(M.Model,XTest);
    %addpath('C:\Antelis\mexlibSVM')
    %YEsti = svmpredict(YTest,XTest,Model);
    
else
    error('PILAS: UNKNOWN CLASSIFIER')
end
