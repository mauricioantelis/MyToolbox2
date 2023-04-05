function Compute_PlotAllTrialsInImage(cfgin,EEG)
%Function that plot trial x time in a ERPimage and the average of all trials
% EEG = EEG1;

%% GET DATA AND COMPUTE AVERAGE

% Number of trials
Ntrials              = length(EEG.trial);

% # Get all trials for the selected channel
cfg                  = [];
cfg.channel          = cfgin.channel;
cfg.keeptrials       = 'yes';
TLA1                 = ft_timelockanalysis(cfg,EEG);
TLA1.trial           = squeeze(TLA1.trial(:,1,:));

% Compute average
TLA1.avg             = mean(TLA1.trial,1);


%% PLOT RESULTS

% Plot image of trial x time
figure 
subplot(10,1,1:7)
imagesc(TLA1.time,1:Ntrials,TLA1.trial)
colorbar;
xline(0,'-','LineWidth',2)
ylabel('Trial')
title(cfg.channel)
ax1          = gca;
ax1.FontSize = 12;
ax1.XTick    = [];
ax1.XLim     = [min(TLA1.time) max(TLA1.time)];
ax1.Position = [0.1300    0.3615    0.6554    0.5635];

% Plot ERP
subplot(10,1,8:10)
plot(TLA1.time,TLA1.avg,'LineWidth',2)
xline(0,'-','LineWidth',2),
yline(0,'-')
box on, grid on
xlabel('Time (s)'), ylabel('\muV')
ax2          = gca;
ax2.FontSize = 12;
ax2.XLim     = [min(TLA1.time) max(TLA1.time)];
ax2.Position = [ax1.Position(1)    0.1100    ax1.Position(3)    0.2281];
