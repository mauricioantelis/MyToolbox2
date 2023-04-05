function M = Compute_ClassificationTrain(XTrain,YTrain,Classifier,Normalization)
% Learn classification model
%
% INPUT:
% XTrain -> Data matrix [Nsam x Nfea]
% YTrain -> Labels [Nsam x 1]
% Classifier    -> type of classification model: 'LDA','SVML','SVMR'
% Normalization -> Type of normalization
%
% OUTPUT:
% M     -> Learned classification model. It contains M.Wnorm and M.Model
% 


%% TRAIN CLASSIFIER

% # ---------------------------------------------
% # Normalize train data
[ XTrain, M.Wnorm ]   = Compute_Normalize(XTrain,Normalization);

% # ---------------------------------------------
% # Train classifier
if     strcmp(Classifier,'LDA')
    M.Model  = fitcdiscr(XTrain,YTrain);
    
elseif strcmp(Classifier,'rLDA')
    ModelLDA = fitcdiscr(XTrain,YTrain);
    M.Model  = Compute_regularizedLDA(ModelLDA);
    
elseif strcmp(Classifier,'SVML')
    M.Model  = fitcsvm(XTrain,YTrain,'KernelFunction','linear');
    
elseif strcmp(Classifier,'SVMR')
    M.Model  = fitcsvm(XTrain,YTrain,'KernelFunction','RBF','ScoreTransform','logit'); % ,'Prior',[0.4 0.6]
    
else
    error('PILAS: UNKNOWN CLASSIFIER')
end


% M.Model = Model;
% M.Wnorm = Model;
