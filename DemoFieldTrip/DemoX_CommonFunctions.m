%*****************************************
%% Definicion de la estructura de datos usada por fieldtrip
% Datos.fsample:        1x1
% Datos.trial:          {1xNtrials cell}
% Datos.time:           {1xNtrials cell}
% Datos.label:          {Nchannelsx1 cell}

%*****************************************
%% Get some trials

% Option 1
cfg         = [];
cfg.trials  = [0 0 1 0 1 1 1 0 0 0 1];
EEGcond1    = ft_preprocessing(cfg,EEG);

% Option 2
cfg         = [];
cfg.trials  = [1 2 4 7 8 19 23 24 25 26 27 28 29 30];
EEGcond2    = ft_preprocessing(cfg,EEG);

% Option 3
Trials2Remove             = [1 2 4 7 8 19 23 24 25 26 27 28 29 30];
cfg                       = [];
cfg.trials                = 1:1:length(EEG.trial);
cfg.trials(Trials2Remove) = [];
EEG                       = ft_preprocessing(cfg,EEG);

%*****************************************
% Get a time segment
cfg             = [];
cfg.trials      = 'all';
cfg.toilim      = [1.2 3.7];
EEGnew          = ft_redefinetrial(cfg,EEG);

%*****************************************
% Get some channels
cfg            = [];
cfg.channel    = {'F3';'Fz';'F4';'C3';'Cz';'C4';'P3';'Pz';'P4'};
EEG            = ft_preprocessing(cfg,DATA);

cfg            = [];
cfg.channel    = {'M1';'M2';'M3';'M4'};
EMG            = ft_preprocessing(cfg,DATA);

% Remove frontal channels Fp1 and Fp2
cfg                       = [];
cfg.channel               = {'all', '-Fp1', '-Fp2'};
EEG                       = ft_preprocessing(cfg,EEG);

%*****************************************
% Resampling
cfg                    = [];
cfg.resamplefs         = 160;
cfg.detrend            = 'no';
EEGnew                 = ft_resampledata(cfg,EEG);


%*****************************************
% Commom average reference filtering
cfg                   = [];
cfg.reref             = 'yes';
cfg.refchannel        = 'all';
EEGcar                = ft_preprocessing(cfg,EEG);

%*****************************************
% Append data (todas deben tener los mismos canales)

% Option 1
cfg                 = [];
cfg.keepsampleinfo  =  'no';
EEG                 = ft_appenddata(cfg,EEG1,EEG2,EEG3);

% Option 2
X{1} = EEG1;
X{2} = EEG2;
X{3} = EEG3;
X{4} = EEG4;
cfg                 = [];
cfg.keepsampleinfo  =  'no';
EEG                 = ft_appenddata(cfg,X{:});

%*****************************************
% Preprocessing
cfg                  = [];
cfg.demean           = 'no';
cfg.detrend          = 'no';
cfg.dftfilter        = 'no';
cfg.bpfilter         = 'yes';
cfg.bpfreq           = [4 30];

EEG1F                = ft_preprocessing(cfg,EEG1F);


% % Baseline correction
cfg                  = [];
cfg.demean           = 'yes';
cfg.baselinewindow   = [-10 0];
EEG                  = ft_preprocessing(cfg,EEG);

%*****************************************
% Randomly choose a percentage of trials
cfg                  = [];
cfg.pct              = 10; % Percentage of trials to choose (randomly)
cfg.Nt1              = length(EEG.trial);
cfg.ind1             = sort( randperm( cfg.Nt1,round(cfg.Nt1/cfg.pct) ) );
EEG.trial            = EEG.trial(cfg.ind1);
EEG.time             = EEG.time(cfg.ind1);



%% *****************************************
%  Averaging across a spectral band these days is done with the ft_selectdata function:

cfg = [];
cfg.frequency = [low high]
cfg.avgoverfreq = ‘yes’;
dataout = ft_freqanalysis(cfg, datain);

%*****************************************
% 


%*****************************************
% 

%*****************************************
% 


%*****************************************
% 

%*****************************************
% 


%*****************************************
% 

%*****************************************
% 
cfg = [];
cfg.operation = 'x1-x2';
cfg.parameter = 'avg';
difference = ft_math(cfg, avg1, avg2);