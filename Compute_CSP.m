function [W, lambda, A] = Compute_CSP(X1,X2)
% INPUT:
% X1 -> Data for class 1, [Ncha x Nsam]
% X2 -> Data for class 2, [Ncha x Nsam]
%
% OUTPUT:
% W -> Mixing matrix [ Ncha x Ncha ] where spatial filters are columns
% 



%% COMPUTE CSP

% Compute the covariance matrix of each class
S1      = cov(X1');           % [ Nchan x Nchan ]
S2      = cov(X2');           % [ Nchan x Nchan ]

% Solve the eigenvalue problem to get the mixing matrix
[W,L]   = eig(S1, S1 + S2);   
lambda  = diag(L);            % Eigenvalues
A       = (inv(W))';          



