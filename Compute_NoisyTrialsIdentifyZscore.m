function OUT_Trials2Remove = Compute_GetNoisyTrialsZscore(cfg,EEG)

% EEG = EEG1RAW;
% cfg                  = [];
% cfg.cutoff           = 10;
% cfg.plotdebugging    = 0;
% cfg.VppTH            = 50; % \mu V - Just for debugging/plotting purposes

%% # ---------------------------------------------
% # 1) Identify segments within the trials with artefacts
cfgsegments                                  = [];
% Channel selection, cutoff and padding
cfgsegments.artfctdef.zvalue.channel         = 'EEG';
cfgsegments.artfctdef.zvalue.cutoff          = cfg.cutoff;
cfgsegments.artfctdef.zvalue.trlpadding      = 0;
cfgsegments.artfctdef.zvalue.artpadding      = 0;
cfgsegments.artfctdef.zvalue.fltpadding      = 0;
% Algorithmic parameters
cfgsegments.artfctdef.zvalue.cumulative      = 'yes';
cfgsegments.artfctdef.zvalue.medianfilter    = 'yes';
cfgsegments.artfctdef.zvalue.medianfiltord   = 9;
cfgsegments.artfctdef.zvalue.absdiff         = 'yes';
cfgsegments.continuous                       = 'no';
cfgsegments.artfctdef.zvalue.interactive     = 'no';
[cfgsegmentsout,~]                     = ft_artifact_zvalue(cfgsegments,EEG);


%% # ---------------------------------------------
% # NOTE: NOISY TRIALS CAN BE DISCHARGED AS FOLLOWS.
% # HOWEVER, WE ARE INTERESTED IN IDENTYFING THE NOYSY TRIALS

% [cfgsegmentsout,sam2eli]                     = ft_artifact_zvalue(cfgsegments,EEG);
% 
% cfg                                  = [];
% cfg.artfctdef.reject                 = 'complete';
% cfg.artfctdef.jump.artifact          = sam2eli;
% cfg.feedback                         = 'no';
% EEGfree                              = ft_rejectartifact(cfg,EEG);


%% # ---------------------------------------------
% # Identify trials to remove


% Initialize vector for Trials2Remove
OUT_Trials2Remove   = zeros(length(EEG.trial),1);
OUT_NoisySamples    = cell(length(EEG.trial),1);


% Muestras de ini and end de cada trial
SampleIniFinTrials  = cfgsegmentsout.artfctdef.zvalue.trl;


% Muestras ini and end de cada artifactual segment
Ai                  = cfgsegmentsout.artfctdef.zvalue.artifact(:,1);
As                  = cfgsegmentsout.artfctdef.zvalue.artifact(:,2);


% Number of trials and artifactual segments
Nnoisysegments      = size(Ai,1);
Ntrials             = size(SampleIniFinTrials,1);


% Check
if length(EEG.trial)~=Ntrials
    error('PILAS PERRITO: esto no puede pasar')
end % if length(EEG.trial)~=Ntrials


% For each trial: determine if there are a noisy segments and get the samples
for itrial=1:Ntrials
    
    
    % Muestra de inicio y de fin del trial actual
    Li   = SampleIniFinTrials(itrial,1);         
    Ls   = SampleIniFinTrials(itrial,2);
    % Replicar Li y Ls para que sea igual al numero de noisy segments
    Li   = repmat(Li,Nnoisysegments,1);  
    Ls   = repmat(Ls,Nnoisysegments,1);
    
    
    % Encontrar los indices de los noisy segments dentro del trial actual
    NoisySegments       = find(and(As>Li,Ai<=Ls));
    
    
    % Determinar si hay noisy segments dentro del trial actual
    FlagNoisySegments   = any(NoisySegments);
    
    
    % Si efectivamente hay noisy segments:
    if FlagNoisySegments==1
        if cfg.plotdebugging==1
            fprintf('Trial %i of %i -  There are %i artifactual segments \n',itrial,Ntrials,length(NoisySegments))
        end 
        % Save flag indicating that this is a noisy trial
        OUT_Trials2Remove(itrial)   = true;
        
        % Get the number of samples in the current trial
        NSamples = length(EEG.time{itrial});
        
        % Indice de inicio y de fin del trial
        Trial_li = Li(NoisySegments);
        Trial_ls = Ls(NoisySegments);
        % Indice de inicio y de fin de los noisy segments: entre [Trial_li y Trial_ls]
        Segme_li = Ai(NoisySegments);
        Segme_ls = As(NoisySegments);
        
        % Indices de ini y fin de los noisy segments: entre [1 y NSamples]
        SampleIniFinNoisySeg   = [ Segme_li Segme_ls ]-(itrial-1)*NSamples;
        SamplesRuidosas        = [];
        for itmp = 1:size(SampleIniFinNoisySeg,1)
            SamplesRuidosas   = [ SamplesRuidosas SampleIniFinNoisySeg(itmp,1):SampleIniFinNoisySeg(itmp,2) ];
        end
        OUT_NoisySamples{itrial}    = SamplesRuidosas;
        
        % Print for debugging
        if cfg.plotdebugging==1
            disp([Trial_li Segme_li Segme_ls Trial_ls])
            disp([Trial_li Segme_li Segme_ls Trial_ls]-(itrial-1)*NSamples)
            disp(SampleIniFinNoisySeg)
            disp(SamplesRuidosas)
        end
        
    else
        if cfg.plotdebugging==1
            fprintf('Trial %i of %i \n',itrial,Ntrials)
        end
        
        % Save flag indicating that this is a clean trial
        OUT_Trials2Remove(itrial)   = false;
        OUT_NoisySamples{itrial}    = [];
    end
    
    
    % Plor for debugging
    if cfg.plotdebugging==1 && OUT_Trials2Remove(itrial)==1
        
        % Get the current trial
        Trial              = EEG.trial{itrial};
        Time               = EEG.time{itrial};
        
        % Plot for debugging
        figure(1), clf, hold on
        plot(Time,Trial)
        grid on, box on
        xlabel('Time (s)'), ylabel('Amplitude (\mu V)')
        if OUT_Trials2Remove(itrial)==0
            title(['Trial ' num2str(itrial) ': clean'])
        else
            plot(Time(SamplesRuidosas),Trial(:,SamplesRuidosas),'o'), 
            title(['Trial ' num2str(itrial) ': noisy'])
        end
        LimX = get(gca,'Xlim');
        line(LimX,+[1 1]*cfg.VppTH,'color','r','LineWidth',2,'LineStyle','-')
        line(LimX,-[1 1]*cfg.VppTH,'color','r','LineWidth',2,'LineStyle','-')
        
        pause
    end % if cfg.plotdebugging==1
    
    
    
end % i=1:Ntrials
