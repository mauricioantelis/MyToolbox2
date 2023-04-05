function [EEGclean, cfgout] = Compute_NoisyTrialsRemove(cfgin,EEG)
% Identify noisy trials using several criteria
% 
% INPUT:
% EEG -> EEG structure with trials, each trial is [Ncha x Nsam]
% cfg.umbralVpp -> Voltage peak peak threshold
% cfg.umbralVstd -> Voltage standar deviation threshold
% cfg.doplot -> Plot for debugging
%
% OUTPUT:
% Trials2Remove -> Trial with Vpp>cfg.umbral in at least one of the
%                  channels [ Ntrials x 1 ] 
% 



%% INITIALIZE

% # ---------------------------------------------
% # Compute number of trials
Ntrials = length(EEG.trial);



%% VPOS

% # ---------------------------------------------
% # Identify trials to remove: if Vpos>umbralVpos
if isfield(cfgin,'umbralVpos')
    cfgVpp                    = [];
    cfgVpp.doplot             = 0;
    cfgVpp.umbralVpos         = cfgin.umbralVpos;
    Tri2RemVpos               = Compute_NoisyTrialsIdentifyVpos(cfgVpp,EEG);
    fprintf('There are %i trials with Vpos>%i \n',sum(Tri2RemVpos),cfgin.umbralVpos)
else
    Tri2RemVpos               = zeros(Ntrials,1);
end



%% VNEG

% # ---------------------------------------------
% # Identify trials to remove: if Vneg<umbralVneg
if isfield(cfgin,'umbralVneg')
    cfgVpp                    = [];
    cfgVpp.doplot             = 0;
    cfgVpp.umbralVneg         = cfgin.umbralVneg;
    Tri2RemVneg               = Compute_NoisyTrialsIdentifyVneg(cfgVpp,EEG);
    fprintf('There are %i trials with Vneg<%i \n',sum(Tri2RemVneg),cfgin.umbralVneg)
else
    Tri2RemVneg               = zeros(Ntrials,1);
end



%% VPP

% # ---------------------------------------------
% # Identify trials to remove: if Vpp>umbralVpp
if isfield(cfgin,'umbralVpp')
    cfgVpp                    = [];
    cfgVpp.doplot             = 0;
    cfgVpp.umbralVpp          = cfgin.umbralVpp;
    Tri2RemVpp                = Compute_NoisyTrialsIdentifyVpp(cfgVpp,EEG);
    fprintf('There are %i trials with Vpp>%i \n',sum(Tri2RemVpp),cfgin.umbralVpp)
else
    Tri2RemVpp                = zeros(Ntrials,1);
end


%% VSTD

% # ---------------------------------------------
% # Identify trials to remove: if Vstd>umbralVstd
if isfield(cfgin,'umbralVstd')
    cfgVstd                   = [];
    cfgVstd.doplot            = 0;
    cfgVstd.umbralVstd        = cfgin.umbralVstd;
    Tri2RemVstd               = Compute_NoisyTrialsIdentifyVstd(cfgVstd,EEG);
    fprintf('There are %i trials with Vstd>%i \n',sum(Tri2RemVstd),cfgin.umbralVstd)
else
    Tri2RemVstd               = zeros(Ntrials,1);
end



%% RATIO [20-40]/[4-40]>0.6

% # ---------------------------------------------
% # Identify trials to remove: if ...
if isfield(cfgin,'ratiobands')
    cfgBand                   = [];
    cfgBand.doplot            = 0;
    cfgBand.umbral            = 0.6;
    Tri2RemBand               = Compute_NoisyTrialsIdentifyBandRatio(cfgBand,EEG);
    fprintf('There are %i trials with BandRatio>%.1f \n',sum(Tri2RemBand),cfgBand.umbral)
else
    Tri2RemBand               = zeros(Ntrials,1);
end



%% REMOVE NOISY TRIALS

% # ---------------------------------------------
% # Trials to remove if: Vpos>+100 or Vneg<-100 or Vpp>200 or Vstd>50 or ...
Trials2Remove1            = or(Tri2RemVpos,Tri2RemVneg);
Trials2Remove2            = or(Tri2RemVpp,Tri2RemVstd);
Trials2Remove             = or(Trials2Remove1,Trials2Remove2);
Trials2Remove             = or(Trials2Remove,Tri2RemBand);

% # ---------------------------------------------
% # Remove noisy trials
cfgtem                       = [];
cfgtem.trials                = 1:1:length(EEG.trial);
cfgtem.trials(Trials2Remove) = [];
cfgtem.feedback              = 'None';
EEGclean                     = ft_preprocessing(cfgtem,EEG);



%% PRINT INFO

% # ---------------------------------------------
% # Output information
cfgout.Trials2Remove      = Trials2Remove;
cfgout.NtrialsOriginal    = length(EEG.trial);
cfgout.NtrialsClean       = length(EEGclean.trial);
cfgout.NtrialsRemoved     = cfgout.NtrialsOriginal - cfgout.NtrialsClean;
cfgout.PercentageRemoved  = 100* (cfgout.NtrialsRemoved/cfgout.NtrialsOriginal);
fprintf('***********************************\n')
fprintf('Removing %i of %i trials - %3.1f%%\n',cfgout.NtrialsRemoved,cfgout.NtrialsOriginal,cfgout.PercentageRemoved)
fprintf('Original number of trials %i\n',cfgout.NtrialsOriginal)
fprintf('Removed number of trials  %i\n',cfgout.NtrialsRemoved)
fprintf('The new number of trials  %i\n',cfgout.NtrialsClean)
fprintf('***********************************\n')



%% PLOT FOR DEBUGGING

% # ---------------------------------------------
% # Plot for debugging
if cfgin.doplot==1
    
    %a = [EEG.trial{:}];
    %Ylim = abs(max(a(:)));
    Ylim = cfgin.umbralVpp;
    
    for itrial=1:length(EEG.trial)
        
        Time               = EEG.time{itrial};
        Trial              = EEG.trial{itrial}';
        
        if 1 % && Trials2Remove(itrial)==1
            figure(1),clf
            plot(Time,Trial), grid on, box on
            xlabel('Time (s)'), ylabel('Amplitude (\mu V)')
            if Trials2Remove(itrial)==0
                title(['Trial ' num2str(itrial) ': clean'],'FontSize',18,'Color','b')
            else
                title(['Trial ' num2str(itrial) ': NOISY'],'FontSize',18,'Color','r')
            end
            set(gca,'Ylim',[-Ylim Ylim])
            pause
        end
        
        
    end
    
end % if cfg.doplot==1

