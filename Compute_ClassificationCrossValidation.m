function [ ACC, TPR, TNR, FPR, O ] = Compute_ClassificationCrossValidation(X,Y,Nfolds,Classifier,Normalization,Shuffling,DoPrint)
% To carry out K-fold cross-validation to the dataset {X,Y}
%
% INPUT:
% X              -> Data matrix [Nsam x Nfea]
% Y              -> Label vector [Nsam x 1]
% Nfolds         -> 5 or 10
% Classifier     -> type of classification model: 'LDA','SVML','SVMR'
% Shuffling      -> To carry out data shuffling:  'YES','NO'
% Normalization  -> To carry out data shuffling:  'zscore','minmax','none'
% DoPrint        -> Print classification results: 1 or 0
%
% OUTPUT:
% ACC, TPR, TNR, FPR, O -> Classification results
% 



%% DO NOT EXECUTE IF THE NUMBER OF INSTANCES IS LOWER THAN X

if length(Y)<10
    error('PILAS: NOT SUFFICIENT NUMBER OF SAMPLES')
end



%% SET PARAMETERS

if     nargin==1
    error('PILAS: se requiere al menos de entrada dos parametetros, X y Y')
elseif nargin==2
    Nfolds        = 10;
    Classifier    = 'LDA';
    Normalization = 'zscore';
    Shuffling     = 'NO';
    DoPrint       = 1;
elseif nargin==3
    Classifier    = 'LDA';
    Normalization = 'zscore';
    Shuffling     = 'NO';
    DoPrint       = 1;
elseif nargin==4
    Normalization = 'zscore';
    Shuffling     = 'NO';
    DoPrint       = 1;
elseif nargin==5
    Shuffling     = 'NO';
    DoPrint       = 1;
elseif nargin==6
    DoPrint       = 1;
elseif nargin==7
    % Do nothing: all parameters were inputted
end



%% RANDOMIZE DATA ORGANIZATION: NO NECESARIO PERO ES BUENA PRACTICA

Ns = length(Y);
Ir = randperm(Ns);

Y = Y(Ir);
X = X(Ir,:);



%% ENSURE THAT THE LABELS ARE 1, 2, 3, 4

currentlabels = unique(Y); % Asegurar que "currentlabels" quede ordenado ascendente
Nclasses       = length(currentlabels);
if     Nclasses==2
    Y(Y==currentlabels(1)) = 1;
    Y(Y==currentlabels(2)) = 2;
elseif Nclasses==3
    Y(Y==currentlabels(1)) = 1;
    Y(Y==currentlabels(2)) = 2;
    Y(Y==currentlabels(3)) = 3;
elseif Nclasses==4
    Y(Y==currentlabels(1)) = 1;
    Y(Y==currentlabels(2)) = 2;
    Y(Y==currentlabels(3)) = 3;
    Y(Y==currentlabels(3)) = 4;
else
    error('PILAS: MORE THAN 3 CLASSES ARE NOT SUPORTED')
end
clear ans currentlabels



%% INITIALIZE VARIABLES

Nsamples      = size(X,1);
IndCroossVal  = crossvalind('Kfold',Nsamples,Nfolds);

if Nclasses==2    
    % Solo calcular ACC, TPR, FPR, y TNR si hay dos clases
    ACC       = zeros(Nfolds,1);
    TPR       = zeros(Nfolds,1);
    FPR       = zeros(Nfolds,1);
    TNR       = zeros(Nfolds,1);
else
    % No calcular ACC, TPR, FPR, y TNR si hay mas de 2 clases
    ACC       = [];
    TPR       = [];
    FPR       = [];
    TNR       = [];
end

% Labels
O.YTest       = [];
O.YEsti       = [];
O.YScore      = [];


%% TRAINNING AND VALIDATION FOR EACH FOLD

% # ---------------------------------------------
% # If doplot
if DoPrint==1
    fprintf('********************************* \n')
end

% # ---------------------------------------------
% # Train, test and measure performance ofr each fold
for ifold = 1:Nfolds
    if DoPrint==1
        fprintf('Fold %i of %i \n',ifold,Nfolds)
    end
    
    % # --------------------------------------------
    % # Indices of the train and test sets
    Ind_test  = (IndCroossVal == ifold);
    Ind_train = ~Ind_test;    
    
    % # --------------------------------------------
    % # Get train and test data for
    XTrain = X(Ind_train,:);   YTrain = Y(Ind_train);
    XTest  = X(Ind_test,:);    YTest  = Y(Ind_test); 
    
    %if DoPrint==1
    %    fprintf('Nexamples: %i | Ntrain: %i | Ntest = %i \n',length(Y),length(YTrain),length(YTest))
    %end
    
    % # --------------------------------------------
    % # Suffling data
    if strcmp(Shuffling,'YES')
        IndRandom  = randperm(length(YTrain));
        YTrain     = YTrain(IndRandom);
    end    
    
    % # --------------------------------------------
    % # Train and apply classification model
    M               = Compute_ClassificationTrain(XTrain,YTrain,Classifier,Normalization);
    [YEsti,YScore]  = Compute_ClassificationApply(XTest,M,Classifier,Normalization);
    
    % # --------------------------------------------
    % # Compute metrics
    if     Nclasses==2
        [ ACC(ifold), TPR(ifold), FPR(ifold), TNR(ifold)] = Compute_ClassificationMetrics2Classes(YTest,YEsti);
    end
    
    % # --------------------------------------------
    % # Append YTest and YEsti across folds
    %fprintf('YTest: %i | YEsti: %i | YScore = %i \n',length(YTest),length(YEsti),length(YScore))
    O.YTest        = [ O.YTest ; YTest ];
    O.YEsti        = [ O.YEsti ; YEsti ];
    O.YScore       = [ O.YScore ; YScore ];
    
end % for ifold = 1:Nfolds

% # --------------------------------------------
% # Print results
if DoPrint==1 && Nclasses==2
    fprintf('Cross-validation results \n')
    fprintf('ACC=%1.4f  |   TPR=%1.4f  |   TNR=%1.4f \n',mean(ACC),mean(TPR),mean(TNR))
end
