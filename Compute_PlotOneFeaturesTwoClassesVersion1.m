function Compute_PlotOneFeaturesTwoClassesVersion1(X1,X2,ScatterScale)
%
% 



%% COMPUTE INFORMATION

% ----------------------------------------------
% 
if nargin==2
    ScatterScale       = 'Linear'; % (Log,X)
end

% ----------------------------------------------
% Initialize
% Data.NameClass1    = 'TNR'; % (TNR,Class 1,BKG)
% Data.NameClass2    = 'FNR'; % (FNR,Class 2,SIM)
Data.NameClass1    = 'BKG';
Data.NameClass2    = 'SIM';

Data.NameFeature1  = 'Rate'; % (x_1,\rho_1)



%% CONTRUCT X AND Y

% ----------------------------------------------
% Construct X and Y
Data.X1 = X1;
Data.Y1 = +1*ones(size(Data.X1,1),1);

Data.X2 = X2;
Data.Y2 = +2*ones(size(Data.X2,1),1);

Data.X  = [Data.X1 ; Data.X2];
Data.Y  = [Data.Y1 ; Data.Y2];



%% COMPUTE THINHS

% ----------------------------------------------
% Feature space dimension
[Data.Nsamples, Data.Ndim]  = size(Data.X);

% ----------------------------------------------
% Compute mean and std for each class
Data.X1mean    = mean(Data.X1);
Data.X1cova    = cov(Data.X1);
Data.X2mean    = mean(Data.X2);
Data.X2cova    = cov(Data.X2);



%% SCATTER PLOT MATRIZ FOR EACH CLASS

% figure, plotmatrix(Data.X1)
% figure, plotmatrix(Data.X2)


%% PLOT HISTOGRAMS FOR EACH FEATURE IN EACH CLASS

% figure, 
hold on

histogram(Data.X1(:,1),'FaceAlpha',0.2,'Normalization','count')
histogram(Data.X2(:,1),'FaceAlpha',0.2,'Normalization','count')
% box on, xlabel(Data.NameFeature1), ylabel(['p(' Data.NameFeature1 ')']), %axis square
box on, xlabel(Data.NameFeature1), ylabel('Count'), %axis square
legend(Data.NameClass1,Data.NameClass2,'Location','NE')

if strcmp(ScatterScale,'Log')
    set(gca,'Xscale','Log'), set(gca,'Yscale','Log')
else
    set(gca,'Xscale','Linear'), set(gca,'Yscale','Linear')
end
