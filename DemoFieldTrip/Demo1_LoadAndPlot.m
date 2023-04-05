%% INITIALIZE

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
% PLOT DATA

% ----------------------------------------------
% Plot EEG
cfg                      = [];
cfg.viewmode             = 'vertical';
cfg.continuous           = 'no';
cfg.ylim                 = [-15 15];
ft_databrowser(cfg,EEG)
