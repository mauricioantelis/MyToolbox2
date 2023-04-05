function Trials2Remove = Compute_NoisyTrialsIdentifyBandRatio(cfgin,EEG)
% Identify noisy trials using the band ratio
%
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
% cfgin.doplot -> Plot for debugging
%
% OUTPUT:
% Trials2Remove -> Trial with Upper/Full>cfg.umbral in at least one of the channels [ Ntrials x 1 ]
%

% EEG            = EEG1RAW;
% cfgin.doplot   = 1;
% cfgin.umbral   = 0.5;


% # ---------------------------------------------
% # Initialize
Ntrials         = length(EEG.trial);
Trials2Remove   = zeros(Ntrials,1);

% # ---------------------------------------------
% # Get EEG in the two band
cfg                  = [];
cfg.bpfilter         = 'yes';

cfg.bpfreq           = [20 40];
EEG_upper            = ft_preprocessing(cfg,EEG);

cfg.bpfreq           = [04 40];
EEG_full             = ft_preprocessing(cfg,EEG);

% # ---------------------------------------------
% # Identify trials to remove
for itrial=1:Ntrials
    % fprintf('Trial %i of %i\n',itrial,Ntrials)
    
    % Get the current trial
    Trial_upper        = EEG_upper.trial{itrial}';
    Trial_full         = EEG_full.trial{itrial}';
    
    % Energy of each channel
    Energy_upper       = sum(Trial_upper.^2);
    Energy_full        = sum(Trial_full.^2);
    
    % COmpute ratio of each channel
    ratio              = Energy_upper./Energy_full;
    
    % Get noisy channels
    IndNoisy           = ratio > cfgin.umbral;
    
    % Determine if remove trial
    Trials2Remove(itrial) = any(IndNoisy);
    
    % Plor for debugging
    if cfgin.doplot==1 %&& Trials2Remove(itrial)==1
        
        Ylim = max([ abs(Trial_upper(:)) ; abs(Trial_full(:)) ]);
        
        Time               = EEG.time{itrial};
        
        figure(1),clf
        
        subplot(2,1,1), plot(Time,Trial_upper), grid on, box on
        xlabel('Time (s)'), ylabel('Upper: [20 40]Hz')
        set(gca,'Ylim',[-Ylim Ylim])
        
        subplot(2,1,2), plot(Time,Trial_full), grid on, box on
        xlabel('Time (s)'), ylabel('Full: [04 40]Hz')
        set(gca,'Ylim',[-Ylim Ylim])
        
        subplot(2,1,1)
        if Trials2Remove(itrial)==0
            title(['Trial ' num2str(itrial) ': clean'],'Color','b')
        else
            title(['Trial ' num2str(itrial) ': NOISY'],'Color','r','FontSize',18)
        end
        
        pause
    end % if cfg.plotdebugging==1
    
end % for i=1:Ntrials