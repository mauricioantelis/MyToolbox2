%% SIMULATE ERPS AND EXPLORE CLUSTER STATISTICS BETWEEN TWO CONDITIONS
% 
% The following code starts off with an ERP in two conditions, where it is
% slightly larger in condition 1 than 2. This simulation demonstrates a
% randomization test, correcting for multiple comparisons by using the
% largest cluster mass
% 
% Acknowledgments:
% https://www.fieldtriptoolbox.org/
% https://www.fieldtriptoolbox.org/example/use_simulated_erps_to_explore_cluster_statistics/


%% INITIALIZE
clear
close all
clc


%% CREATE SIGNATURES FOR TWO ERP

% Time vector
fs                     = 256;
ts                     = 1/fs;
tim                    = -0.2:ts:1;
Nsamples               = length(tim);

% Create ERP1
mu1                    = 0.5;
va1                    = .1^2;
erp1                   = 3.5*( 1/sqrt(2*pi*va1) ) * exp( - (1/(2*va1)) * (tim-mu1).^2) ;
% erp1                   = (1-cos(2*pi*tim))/2;

% Create ERP2
mu2                    = 0.35;
va2                    = .03^2;
erp2                   = ...
    + ( 1/sqrt(2*pi*va2) ) * exp( - (1/(2*va2)) * (tim-mu2).^2) ...
    - ( 1/sqrt(2*pi*va2) ) * exp( - (1/(2*va2)) * (tim-mu2-0.1).^2) ...
    + ( 1/sqrt(2*pi*va2*8) ) * exp( - (1/(2*va2*8)) * (tim-mu2-0.3).^2);

% Plot ERPs
figure, hold on
plot(tim, erp1, 'LineWidth',2 )
plot(tim, erp2, 'LineWidth',2)
xlabel('Time (s)')
ylabel('Amplitude (uV)')
legend('ERP1','ERP2','EdgeColor','None','Color','None')
box on, grid on
set(gca,'FontSize',12)

% Clear garbage
clear ans mu1 va1 mu2 va2 ts

%% CONSTRUCT TRIALS

% EEG for condition 1
Ntrials1               = 100;
EEG1.label             = {'Channel 1';'Channel 2'};
% EEG1.label             = {'Cz'};
EEG1.fsample           = fs;
for i=1:Ntrials1
  EEG1.time{i}         = tim;
  EEG1.trial{i}(1,:)   = 1.5*erp1 + 10*randn(size(erp1));
  EEG1.trial{i}(2,:)   = 1.6*erp2 + 10*randn(size(erp2));
end

% EEG for condition 2
Ntrials2               = 130;
EEG2.label             = {'Channel 1';'Channel 2'};
% EEG2.label             = {'Cz'};
EEG2.fsample           = fs;
for i=1:Ntrials2
  EEG2.time{i}         = tim;
  EEG2.trial{i}(1,:)   = 1.0*erp1 + 10*randn(size(erp1));
  EEG2.trial{i}(2,:)   = 1.0*erp2 + 10*randn(size(erp2));
end

% Clear garbage
clear ans tim i fs erp1 erp2

% Plot all trials
cfg                    = [];
cfg.keeptrials         = 'yes';
TLK1                   = ft_timelockanalysis(cfg, EEG1);
TLK2                   = ft_timelockanalysis(cfg, EEG2);

for ichan = 1:length(TLK1.label)
    
    figure, hold on
    
    subplot(2,1,1), hold on
    plot(TLK1.time, squeeze(TLK1.trial(:,ichan,:)), 'LineWidth', 2)
    xlabel('Time (s)')
    ylabel('Amplitude (uV)')
    title('Condition 1')
    box on, grid on
    set(gca,'FontSize',12)
    
    subplot(2,1,2), hold on
    plot(TLK2.time, squeeze(TLK2.trial(:,ichan,:)), 'LineWidth', 2)
    xlabel('Time (s)')
    ylabel('Amplitude (uV)')
    title('Condition 2')
    box on, grid on
    set(gca,'FontSize',12)
    
end
clear ans ichan TLK1 TLK2 cfg

% return

%% TIME LOCK ANALYSIS

% Compute average
cfg                    = [];
cfg.keeptrials         = 'no';
AVG1                   = ft_timelockanalysis(cfg, EEG1);
AVG2                   = ft_timelockanalysis(cfg, EEG2);

% Plot ERP
figure, hold on

subplot(2,1,1), hold on
plot(AVG1.time, AVG1.avg(1,:), 'LineWidth', 2)
plot(AVG2.time, AVG2.avg(1,:), 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Amplitude (uV)')
title('ERP Channel 1')
legend('Cond1','Cond2','EdgeColor','None','Color','None')
box on, grid on
set(gca,'FontSize',12)

subplot(2,1,2), hold on
plot(AVG1.time, AVG1.avg(2,:), 'LineWidth', 2)
plot(AVG2.time, AVG2.avg(2,:), 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Amplitude (uV)')
title('ERP Channel 2')
legend('Cond1','Cond2','EdgeColor','None','Color','None')
box on, grid on
set(gca,'FontSize',12)

% return

%% CALCULATE DIFFERENCE

cfg                    = [];
cfg.operation          = 'x1-x2';
cfg.parameter          = 'avg';
DIFF                   = ft_math(cfg, AVG1, AVG2);

% Plot DIFF
figure, hold on

subplot(2,1,1), hold on
plot(DIFF.time, DIFF.avg(1,:), 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Amplitude (uV)')
title('ERP DIFF')
legend(DIFF.label{1},'EdgeColor','None','Color','None')
box on, grid on
set(gca,'FontSize',12)

subplot(2,1,2), hold on
plot(DIFF.time, DIFF.avg(2,:), 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Amplitude (uV)')
title('ERP DIFF')
legend(DIFF.label{2},'EdgeColor','None','Color','None')
box on, grid on
set(gca,'FontSize',12)


%% STATISTICAL TEST

% Compute the variance over the individual trials
cfg                    = [];
cfg.keeptrials         = 'yes';
TLK1                   = ft_timelockanalysis(cfg, EEG1);
TLK2                   = ft_timelockanalysis(cfg, EEG2);

% Perform statistical test
cfg                    = [];
cfg.design             = [ 1*ones(1,Ntrials1) 2*ones(1,Ntrials2) ];
cfg.ivar               = 1;
cfg.method             = 'montecarlo';
cfg.statistic          = 'indepsamplesT';
cfg.correctm           = 'cluster';
cfg.numrandomization   = 2000;
cfg.neighbours         = []; % Only cluster over time, not over channels
cfg.spmversion         = 'spm12'; % the default spm8 has mex file problems on recent macOS versions
STAT                   = ft_timelockstatistics(cfg, TLK1, TLK2);


%% PLOT RESULTS STATISTICAL TEST

for ichan = 1:length(AVG1.label)
    
    figure
    
    subplot(4,1,1), hold on
    plot(AVG1.time, AVG1.avg(ichan,:), 'LineWidth', 2)
    plot(AVG2.time, AVG2.avg(ichan,:), 'LineWidth', 2)
    plot(DIFF.time, DIFF.avg(ichan,:), 'LineWidth', 2)
    box on, grid on, ylabel('uV'), title(AVG1.label{ichan})
    legend('Cond1','Cond2','Diff','EdgeColor','None','Color','None')
    set(gca,'XLim',[min(AVG1.time) max(AVG1.time)])
    
    subplot(4,1,2)
    plot(STAT.time, STAT.stat(ichan,:), 'LineWidth', 2)
    box on, grid on, ylabel('t-val')
    set(gca,'XLim',[min(AVG1.time) max(AVG1.time)])
    
    subplot(4,1,3)
    semilogy(STAT.time, STAT.prob(ichan,:), 'LineWidth', 2)
    box on, grid on, ylabel('prob'),
    set(gca,'XLim',[min(AVG1.time) max(AVG1.time)],'Ylim',[0.00001 2])
    
    subplot(4,1,4)
    plot(STAT.time, STAT.mask(ichan,:), 'LineWidth', 2)
    box on, grid on, ylabel('sig')
    set(gca,'XLim',[min(AVG1.time) max(AVG1.time)],'Ylim',[-0.1 1.1])
    
end

%% PLOT NEG AND POR CLUSTERS 

% figure
% 
% subplot(2,1,1)
% hist(STAT.negdistribution, 200)
% axis([-10 10 0 100])
% for i=1:numel(STAT.negclusters)
%   X = [STAT.negclusters(i).clusterstat STAT.negclusters(i).clusterstat];
%   Y = [0 100];
%   line(X, Y, 'color', 'r')
% end
% 
% subplot(2,1,2)
% hist(STAT.posdistribution, 200)
% axis([-10 10 0 100])
% for i=1:numel(STAT.posclusters)
%   X = [STAT.posclusters(i).clusterstat STAT.posclusters(i).clusterstat];
%   Y = [0 100];
%   line(X, Y, 'color', 'r')
% end