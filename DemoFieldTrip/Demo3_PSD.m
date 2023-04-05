%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE

% Clear all
clear
close all
clc

% Agregar fieldtrip path
path(path,'C:\Antelis\fieldtrip-20200911'), ft_defaults

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA

% ----------------------------------------------
% LOAD DATA
load('EEG_P1_MotorImagery')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPROCESSING

% ----------------------------------------------
% BAND PASS FILTERING
cfg                       = [];
cfg.demean                = 'yes';
cfg.dftfilter             = 'yes';
cfg.bpfilter              = 'yes';
cfg.bpfreq                = [1 50];
EEG                       = ft_preprocessing(cfg,EEG);

% ----------------------------------------------
% REJECT NOISY TRIALS
Trials2Remove             = find(SubjectInfo.Z==0);

cfg                       = [];
cfg.trials                = 1:1:length(SubjectInfo.Arm);
cfg.trials(Trials2Remove) = []; %#ok<FNDSB>
EEG                       = ft_preprocessing(cfg,EEG);

SubjectInfo.Arm           = SubjectInfo.Arm(cfg.trials);
SubjectInfo.Session       = SubjectInfo.Session(cfg.trials);

% ----------------------------------------------
% GET DATA FROM A SINGLE ARM

% Trial only from a arm
cfg                       = [];
cfg.trials                = SubjectInfo.Arm==2; % (1:left|2:right)
EEG                       = ft_preprocessing(cfg,EEG);

% Info from that ams
SubjectInfo.Arm           = SubjectInfo.Arm(cfg.trials);
SubjectInfo.Session       = SubjectInfo.Session(cfg.trials);
SubjectInfo.Z             = SubjectInfo.Z(cfg.trials);

% ----------------------------------------------
% Eliminate unwanted structures
EEG                       = rmfield(EEG,'sampleinfo');
EEG                       = rmfield(EEG,'cfg');
SubjectInfo               = rmfield(SubjectInfo,'Z');
clear ans cfg Trials2Remove

% ----------------------------------------------
% SPLIT EEG IN REST AND MOTOR TASK
cfg                       = [];
cfg.trials                = 'all';

cfg.toilim                = [0 3];
EEG1                      = ft_redefinetrial(cfg,EEG);

cfg.toilim                = [4 7];
EEG2                      = ft_redefinetrial(cfg,EEG);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE PSD FOR THE TWO CONDITIONS

% ----------------------------------------------
% Compute PSD
cfg                       = [];
cfg.keeptrials            = 'yes';
cfg.output                = 'pow';
cfg.method                = 'mtmfft';
cfg.taper                 = 'dpss'; % ('dpss','hanning')
cfg.foi                   = 6:0.5:40;
cfg.tapsmofrq             = 2;
POW1                      = ft_freqanalysis(cfg,EEG1);
POW2                      = ft_freqanalysis(cfg,EEG2);

% ----------------------------------------------
% Compute PSD average
cfg                       = [];
cfg.variance              = 'yes';
POW1Avg                   = ft_freqdescriptives(cfg,POW1);
POW2Avg                   = ft_freqdescriptives(cfg,POW2);

% % ----------------------------------------------
% % In dB
% POW1Avg.powspctrm         = 10*log10(POW1Avg.powspctrm);
% POW2Avg.powspctrm         = 10*log10(POW2Avg.powspctrm);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PSD AVERAGE OF ONE CHANNEL IN THE TWO CONDITIONS

% ----------------------------------------------
% Select a channel
ichan = 1;

% ----------------------------------------------
% Plot PSD of the selected channel in the two conditions
figure, clf,  hold on
plot(POW1Avg.freq,POW1Avg.powspctrm(ichan,:),'LineWidth',2)
plot(POW2Avg.freq,POW2Avg.powspctrm(ichan,:),'LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Power (\muV^2/Hz)')
title(POW1Avg.label(ichan))
legend('Relax','MI','EdgeColor','None','Color','None')
grid on, box on
set(gca,'FontSize',12)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PSD AVERAGE OF ALL CHANNELS IN THE TWO CONDITIONS

% ----------------------------------------------
% 


figure, clf,  hold on

ichan = 1;
subplot(1,3,1), hold on
plot(POW1Avg.freq,POW1Avg.powspctrm(ichan,:),'LineWidth',2)
plot(POW2Avg.freq,POW2Avg.powspctrm(ichan,:),'LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Power (\muV^2/Hz)')
title(POW1Avg.label(ichan))
legend('Relax','MI','EdgeColor','None','Color','None')
grid on, box on
set(gca,'FontSize',12)

ichan = 2;
subplot(1,3,2), hold on
plot(POW1Avg.freq,POW1Avg.powspctrm(ichan,:),'LineWidth',2)
plot(POW2Avg.freq,POW2Avg.powspctrm(ichan,:),'LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Power (\muV^2/Hz)')
title(POW1Avg.label(ichan))
legend('Relax','MI','EdgeColor','None','Color','None')
grid on, box on
set(gca,'FontSize',12)

ichan = 3;
subplot(1,3,3), hold on
plot(POW1Avg.freq,POW1Avg.powspctrm(ichan,:),'LineWidth',2)
plot(POW2Avg.freq,POW2Avg.powspctrm(ichan,:),'LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Power (\muV^2/Hz)')
title(POW1Avg.label(ichan))
legend('Relax','MI','EdgeColor','None','Color','None')
grid on, box on
set(gca,'FontSize',12)

% return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT ERP TOPOGRAPHICAL MAP

% ----------------------------------------------
% Load layout
load('MyLayout')

% ----------------------------------------------
% Plot topoplot
cfg               = [];
cfg.xparam        = 'freq';
cfg.zparam        = 'powspctrm';
cfg.layout        = MyLayout;
cfg.showlabels    = 'yes';
cfg.fontsize      = 7;
cfg.box           = 'yes';
cfg.colorbar      = 'yes';
cfg.showoutline   = 'yes';
cfg.interactive   = 'yes';
ft_multiplotER(cfg,POW1Avg,POW2Avg);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FREQUENCY TOPOPLOT

% Nota: esta grafica no tiene sentido con estos datos debido al poco numero
% de electrodos
