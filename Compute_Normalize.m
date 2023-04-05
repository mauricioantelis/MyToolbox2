function [ X, W ] = Compute_Normalize(X,Normalization,W)
% Compute or apply normalization
%
% INPUT:
% X -> Data matrix [Nsam x Nfea]
% Normalization -> Type of normalization
% W -> Normalization data
%
% OUTPUT:
% X -> Normalized data matrix [Nsam x Nfea]
% W -> Normalization data
% 



    % -------------------------------------
    % NORMALIZE DATA
if nargin==2 && nargout==2
    
    if strcmp(Normalization,'zscore')
        [ X, W.Xmean, W.Xstde] = Compute_NormalizeZscore(X);
        
    elseif strcmp(Normalization,'minmax')
        [ X, W.Xmin, W.Xmax ] = Compute_NormalizeMinMax(X);
        
    elseif strcmp(Normalization,'none')
        % Do not apply normalization
        W = [];
        
    else
        % Do not apply normalization
        W = [];
        
    end
    
    
    
    % -------------------------------------
    % APPLY NORMALIZATION TO THE DATA
elseif nargin==3 && nargout==1
    
    if strcmp(Normalization,'zscore')
        X = Compute_NormalizeZscore(X,W.Xmean,W.Xstde);
    elseif strcmp(Normalization,'minmax')
        X = Compute_NormalizeMinMax(X,W.Xmin,W.Xmax);
    elseif strcmp(Normalization,'none')
        % Do not apply normalization
    else
        % Do not apply normalization
    end
    
else
    error('PILAS: ')
    
end % if nargin==2 && nargout==2