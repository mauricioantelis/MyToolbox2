function Trials2Remove = Compute_NoisyTrialsIdentifyVstd(cfg,EEG)
% Identify noisy trials using the standard deviation voltage threshold
% 
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
% cfg.umbralVstd -> Voltage standar deviation threshold
% cfg.doplot -> Plot for debugging
%
% OUTPUT:
% Trials2Remove -> Trial with Vstd>cfg.umbral in at least one of the channels [ Ntrials x 1 ]
% 

% # ---------------------------------------------
% # Initialize
Ntrials         = length(EEG.trial);
Trials2Remove   = zeros(Ntrials,1);

% # ---------------------------------------------
% # Identify trials to remove
for itrial=1:Ntrials
    % fprintf('Trial %i of %i\n',itrial,Ntrials)
    
    % Get the current trial
    Trial              = EEG.trial{itrial}';
    
    % Compute voltaje pico a pico
    Vstd               = std(Trial)';
    
    %     % Plot for debugging
    %     for i=1:length(EEG.label)
    %         time = EEG.time{itrial};
    %
    %         figure(1), clf, hold on
    %         plot(time,Trial(:,i)), grid on, box on
    %         xlabel('Time (s)'), ylabel('Amplitude (\mu V)'), title(['Channel ' EEG.label{i} '    |    V_{std}=' num2str(Vstd(i))])
    %         LimX = get(gca,'Xlim');
    %         line(LimX,+[1 1]*Vstd(i),'color','r','LineWidth',1,'LineStyle','-')
    %         line(LimX,-[1 1]*Vstd(i),'color','r','LineWidth',1,'LineStyle','-')
    %         line(LimX,+[1 1]*cfg.umbralVstd,'color','r','LineWidth',2,'LineStyle','--')
    %         line(LimX,-[1 1]*cfg.umbralVstd,'color','r','LineWidth',2,'LineStyle','--')
    %         pause
    %     end
    
    % Get noisy channels
    IndNoisy   = Vstd > +cfg.umbralVstd;
    
    % Determine if remove trial
    Trials2Remove(itrial) = any(IndNoisy);
    
    % Plor for debugging
    if cfg.doplot==1 && Trials2Remove(itrial)==1
        
        Time               = EEG.time{itrial};
        
        figure(1),clf
        plot(Time,Trial), grid on, box on
        xlabel('Time (s)'), ylabel('Amplitude (\mu V)')
        if Trials2Remove(itrial)==0
            title(['Trial ' num2str(itrial) ': clean'])
        else
            title(['Trial ' num2str(itrial) ': noisy'])
        end
        LimX = get(gca,'Xlim');
        line(LimX,+[1 1]*cfg.umbralVstd,'color','r','LineWidth',2,'LineStyle','--')
        line(LimX,-[1 1]*cfg.umbralVstd,'color','r','LineWidth',2,'LineStyle','--')        
        pause
    end % if cfg.plotdebugging==1
     
    
    
end % for i=1:Ntrials