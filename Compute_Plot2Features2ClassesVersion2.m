function Compute_Plot2Features2ClassesVersion2(X,Y,ScatterScale)
%
% 
% ScatterScale     = 'Log';



%% COMPUTE INFORMATION

% ----------------------------------------------
% Initialize
Data.Class1Name  = 'BKG'; % Class 1
Data.Class2Name  = 'SIM'; % Class 2



%% CONTRUCT X AND Y

% ----------------------------------------------
Data.X = X;
Data.Y = Y;



%% COMPUTE THINHS

% ----------------------------------------------
% Feature space dimension
[Data.Nsamples, Data.Ndim]  = size(Data.X);

% ----------------------------------------------
% Verify number of classes
if unique(Data.Y)~=2
    error('PILAS: Esta funcion solo funciona para dos clases')
end

% ----------------------------------------------
% Separate per condition
Data.X1        = Data.X(Data.Y==1,:); Data.Y1 = 1*ones(size(Data.X1,1),1);
Data.X2        = Data.X(Data.Y==2,:); Data.Y2 = 2*ones(size(Data.X2,1),1);

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
histogram(Data.X1(:,1),'FaceAlpha',0.4,'Normalization','probability')
histogram(Data.X2(:,1),'FaceAlpha',0.4,'Normalization','probability')
box on, xlabel('x_1'), ylabel('p(x_1)'), %axis square
legend(Data.Class1Name,Data.Class2Name,'Location','NE')

subplot(2,1,2), hold on
histogram(Data.X1(:,2),'FaceAlpha',0.4,'Normalization','probability')
histogram(Data.X2(:,2),'FaceAlpha',0.4,'Normalization','probability')
box on, xlabel('x_2'), ylabel('p(x_2)'), %axis square
legend(Data.Class1Name,Data.Class2Name,'Location','NE')



%% SCATTER PLOT

figure, hold on
h1 = gscatter(Data.X(:,1),Data.X(:,2),Data.Y,'rb','..',[],'off');
box on, xlabel('x_1'), ylabel('x_2')

if strcmp(ScatterScale,'Log')
    set(gca,'Xscale','Log'), set(gca,'Yscale','Log')
else
    set(gca,'Xscale','Linear'), set(gca,'Yscale','Linear')
    plotcov2(Data.X1mean',Data.X1cova,'plot-opts',{'Color','r','LineWidth',2},'plot-axes',0,'fill-color',[]);
    plotcov2(Data.X2mean',Data.X2cova,'plot-opts',{'Color','b','LineWidth',2},'plot-axes',0,'fill-color',[]);
end

legend(Data.Class1Name,Data.Class2Name,'Location','SE')
