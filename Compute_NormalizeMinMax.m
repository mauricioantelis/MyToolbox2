function [ Xout Xmin Xmax] = Compute_NormalizeMinMax(X,Xmin,Xmax)
% Esta funcion realiza la normalizacion minmax de la matriz de entrada o
% aplica la normalizacion minmax de la matriz de entrada con los parametros
% de entrada

% X ->  Nsamples x Ndims


[ Nsam Ndim ] = size(X);


if nargin==1
    % Perform minmax normalization con los parametros de esta matrix
    Xmin = min(X);
    Xmax = max(X);
    
    X    = X -  repmat(Xmin,Nsam,1);
    X    = X ./ repmat(Xmax-Xmin,Nsam,1);
    Xout = 2*X - ones(Nsam,Ndim);
    
elseif nargin==3
    % Perform minmax normalization con los parametros de entrada
    X    = X -  repmat(Xmin,Nsam,1);
    X    = X ./ repmat(Xmax-Xmin,Nsam,1);
    Xout = 2*X - ones(Nsam,Ndim);
    
else
    error('PILAS: numero incorrecto de argumentos de entrada')
end




