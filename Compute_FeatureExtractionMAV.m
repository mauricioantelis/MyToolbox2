function [X, EEG2] = Compute_FeatureExtractionMAV(EEG1)
% Feature extraction based on mean average value
%
% INPUT:
% EEG1 -> EEG structure with trials, each trial is [Ncha x Nsam]
%
% OUTPUT:
% X -> Feature matrix [ Ntrials x Nfeatures ]
% 



%% COMPUTE INFORMATION

% ----------------------------------------------
% Compute constants
Ntrials           = length(EEG1.trial);

% ----------------------------------------------
% Compute ABS: option 1, using our own code
% EEG2  = EEG1;
% for i=1:Ntrials
%     EEG2.trial{i} = abs(EEG1.trial{i});
% end
% Compute ABS: option 2, using fieldtrip
cfg               = [];
cfg.trials        = 'all';
cfg.rectify       = 'yes';
EEG2              = ft_preprocessing(cfg,EEG1);

% % ----------------------------------------------
% % Plot for debugging
% itrial            =  1; % Choose a trial
% ichannel          =  2; % Choose a trial
% 
% % Plot data
% figure, hold on
% plot(EEG1.time{itrial},EEG1.trial{itrial}(ichannel,:),'LineWidth',2)
% plot(EEG2.time{itrial},EEG2.trial{itrial}(ichannel,:),'LineWidth',1)
% xlabel('Time (s)'), ylabel('Amplitude (\muV)')
% title('Plot for debugging')
% set(gca,'Xlim',[min(EEG1.time{itrial}) max(EEG1.time{itrial})])
% box on, axis on

% ----------------------------------------------
% Compute the mean of the absolute signals of each electrode
EEG3  = EEG2;
for i=1:Ntrials
    EEG3.trial{i} = mean(EEG2.trial{i},2);
end



%% COMPUTE MATRIX X

% ----------------------------------------------
% Feature vector for each trial
% x = [MAV(Channel_1), MAV(Channel_2),...,MAV(Channel_Ncha)]
% x is a vector of [ 1 x Nfeatures ] where Nfeatures is equal to Ncha
% 
% Matriz of featutes
% X = [x1 ; x2 ; ... ; xNtrials]
% X is a matrix of [ Ntrials x Nfeatures ]

% ----------------------------------------------
% Construct X
X = zeros(Ntrials,2);
for i=1:Ntrials
    X(i,:) = EEG3.trial{i}';
end

