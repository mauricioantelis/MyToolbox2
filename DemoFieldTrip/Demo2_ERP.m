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
cfg                       = [];
cfg.trials                = SubjectInfo.Arm==1; % (1|2)
EEG                       = ft_preprocessing(cfg,EEG);

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
% GET EEG DURING THE MOTOR TASK
cfg                       = [];
cfg.trials                = 'all';
cfg.toilim                = [2.8 4];
EEG                       = ft_redefinetrial(cfg,EEG);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE GRAND AVERAGE

% ----------------------------------------------
% Compute average
cfg                       = [];
cfg.keeptrials            = 'no';
EEGavg                    = ft_timelockanalysis(cfg,EEG);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT GRAND AVERAGE RESULTS

% ----------------------------------------------
% Plot EEGavg results: all channels in the same figure
figure, hold on
plot(EEGavg.time,EEGavg.avg,'LineWidth',2)
xline(3,'--'), box on, grid on, legend(EEGavg.label)
xlabel('Time (s)'), ylabel('Amplitude (\muV)'), title('ERP')

% ----------------------------------------------
% Plot EEGavg results: each channel in one subplot
figure, hold on

subplot(1,3,1), plot(EEGavg.time,EEGavg.avg(1,:),'LineWidth',2)
xline(3,'--'), box on, grid on, axis square
xlabel('Time (s)'), ylabel('Amplitude (\muV)'), title(EEGavg.label(1))

subplot(1,3,2), plot(EEGavg.time,EEGavg.avg(2,:),'LineWidth',2)
xline(3,'--'), box on, grid on, axis square
xlabel('Time (s)'), ylabel('Amplitude (\muV)'), title(EEGavg.label(2))

subplot(1,3,3), plot(EEGavg.time,EEGavg.avg(3,:),'LineWidth',2)
xline(3,'--'), box on, grid on, axis square
xlabel('Time (s)'), ylabel('Amplitude (\muV)'), title(EEGavg.label(3))


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT ERP TOPOGRAPHICAL MAP

% ----------------------------------------------
% Load layout
load('MyLayout')

% ----------------------------------------------
% Plot topographical map
cfg                       = [];
cfg.showlabels            = 'yes';
cfg.fontsize              = 8;
cfg.layout                = MyLayout;
cfg.box                   = 'yes';
cfg.showoutline           = 'yes';
cfg.linewidth             = 1;
cfg.comment               = '';
cfg.interactive           = 'yes';
%cfg.ylim                  = [-2 2];
ft_multiplotER(cfg,EEGavg);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT ERP TOPOPLOT

% Nota: esta grafica no tiene sentido con estos datos debido al poco numero
% de electrodos

% Plot topoplot en un tiempo
figure
cfg                       = [];
cfg.layout                = MyLayout;
cfg.comment               = 'xlim';
cfg.commentpos            = 'middlebottom';
cfg.colorbar              = 'yes';
cfg.xlim                  = [3.36 3.36];
ft_topoplotER(cfg,EEGavg);

% Plot topoplots en un rango (average)
figure
cfg                       = [];
cfg.layout                = MyLayout;
cfg.comment               = 'xlim';
cfg.commentpos            = 'middlebottom';
cfg.colorbar              = 'yes';
cfg.xlim                  = [3.3 3.4];
ft_topoplotER(cfg,EEGavg);

% Plot topoplots at different latencies
figure
cfg                       = [];
cfg.layout                = MyLayout;
cfg.comment               = 'xlim';
cfg.commentpos            = 'middlebottom';
cfg.colorbar              = 'no';

subplot(1,4,1), cfg.xlim = [3.3 3.4]; ft_topoplotER(cfg,EEGavg);
subplot(1,4,2), cfg.xlim = [3.4 3.5]; ft_topoplotER(cfg,EEGavg);
subplot(1,4,3), cfg.xlim = [3.5 3.6]; ft_topoplotER(cfg,EEGavg);
subplot(1,4,4), cfg.xlim = [3.6 3.7]; ft_topoplotER(cfg,EEGavg);


