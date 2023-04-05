function Compute_PlotTwoFeaturesTwoClassesVersion1(X1,X2,ScatterScale)
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
% Data.NameClass1    = 'BKG'; % (Class 1,BKG)
% Data.NameClass2    = 'SIM'; % (Class 2,SIM)

Data.NameClass1    = 'L1'; % (Class 1,BKG)
Data.NameClass2    = 'H1'; % (Class 2,SIM)

Data.NameFeature1  = 'FNR'; % (x_1,\rho_1)
Data.NameFeature2  = 'TNR'; % (x_2,\rho_2)



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

figure, hold on

subplot(2,1,1), hold on
histogram(Data.X1(:,1),'FaceAlpha',0.4,'Normalization','count')
histogram(Data.X2(:,1),'FaceAlpha',0.4,'Normalization','count')
% box on, xlabel(Data.NameFeature1), ylabel(['p(' Data.NameFeature1 ')']), %axis square
box on, xlabel(Data.NameFeature1), ylabel('Count'), %axis square
legend(Data.NameClass1,Data.NameClass2,'Location','NE')

subplot(2,1,2), hold on
histogram(Data.X1(:,2),'FaceAlpha',0.4,'Normalization','count')
histogram(Data.X2(:,2),'FaceAlpha',0.4,'Normalization','count')
%box on, xlabel(Data.NameFeature2), ylabel(['p(' Data.NameFeature2 ')']), %axis square
box on, xlabel(Data.NameFeature2), ylabel('Count'), %axis square
legend(Data.NameClass1,Data.NameClass2,'Location','NE')



%% SCATTER PLOT

figure, hold on
gscatter(Data.X(:,1),Data.X(:,2),Data.Y,'rb','..',[],'off');
box on, xlabel(Data.NameFeature1), ylabel(Data.NameFeature2), %axis square

if strcmp(ScatterScale,'Log')
    set(gca,'Xscale','Log'), set(gca,'Yscale','Log')
else
    set(gca,'Xscale','Linear'), set(gca,'Yscale','Linear')
    plotcov2(Data.X1mean',Data.X1cova,'plot-opts',{'Color','r','LineWidth',2},'plot-axes',0,'fill-color',[]);
    plotcov2(Data.X2mean',Data.X2cova,'plot-opts',{'Color','b','LineWidth',2},'plot-axes',0,'fill-color',[]);
end

legend(Data.NameClass1,Data.NameClass2,'Location','SE')
