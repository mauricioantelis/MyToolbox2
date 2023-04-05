function [ Xout Xmean Xstde] = Compute_NormalizeZscore(X,Xmean,Xstde)
% Esta funcion realiza la normalizacion zscore de la matriz de entrada o
% aplica la normalizacion zscore de la matriz de entrada con los parametros
% de entrada

DoNormalization = 'yes';



if strcmp(DoNormalization,'yes')
    
    
    
    
    
    
    if nargin==1 
        % Perform zscore normalization con los parametros de esta matrix
        [ Xout Xmean Xstde ] = zscore(X);
        
    elseif nargin==3
        % Perform zscore normalization con los parametros de entrada
        Xout = bsxfun(@minus,X,Xmean);
        Xout = bsxfun(@rdivide,Xout,Xstde);
        
    else
        error('PILAS: numero incorrecto de argumentos de entrada')
    end
    
    
    
    
    
    
    
else
    Xmean = zeros(1,size(X,2));
    Xstde = ones(1,size(X,2));
end


