function [outputArg1] = Compute_regularizedLDA(Mdl)
%REGULARIZELDA Summary of this function goes here
%   Detailed explanation goes here

% Cross validation the classifier
[err,gamma,delta,numpred] = cvshrink(Mdl,'NumGamma',24,'NumDelta',24,'Verbose',1);
%plot(err,numpred,'k.')
%xlabel('Error rate')
%ylabel('Number of predictors')

%axis([0 .1 0 260]);
minerr = min(min(err));
[p,q] = find(err <= minerr);
idx = sub2ind(size(delta),p,q);
[gamma(p) delta(idx)];

low100 = min(min(err(numpred <= 100)));
lownum = min(min(numpred(err == low100)));
[low100 lownum];
[r,s] = find((err == low100) & (numpred == lownum));
% several gammas and deltas might give the minimum error rate, therefore we 
% will choose only the first one
[gamma(r(1)); delta(r(1),s(1))]  
Mdl.Gamma = gamma(r(1));
Mdl.Delta = delta(r(1),s(1));

outputArg1 = Mdl;
end

