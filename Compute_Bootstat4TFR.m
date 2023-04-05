function TFRSig = Compute_Bootstat4TFR(cfg,TFR,TFRbaseline)

% Compute significant ERD/ERS for the input TFR.
% The baseline is (a) the time interval "cfg.baseline" in TFR or (b) the
% full time interval in TFRbaseline



%% INITIALIZE VARIABLES


% Compute Ntrials Nchannels Nfreqs Nsamples
[Ntrials Nchannels Nfreqs Nsamples] = size(TFR.powspctrm);


% Indices de tiempo del baseline
if nargin==2 && isfield(cfg,'baseline')
    % solo los ti's dentro del intervalo de tiempo cfg.baseline
    cfg.baselntmp = find(and(TFR.time<cfg.baseline(2),TFR.time>=cfg.baseline(1)));
elseif nargin==3
    % todos los ti's de la segunda TFR
    cfg.baselntmp      = 1:length(TFRbaseline.time);
else
    error('PILAS: problema de configuracion del baseline')
end
% Parametros para el bootstraping
cfg.naccu        = 500;
cfg.formula      = 'mean(arg1,3);';
cfg.mcorrect     = 'no'; % (no|fdr)
cfg.boottype     = 'shuffle';
cfg.label        = 'ERSP';
cfg.bootside     = 'both';
cfg.dimaccu      = 2;

% Initialize TFRSig
TFRSig               = ft_freqdescriptives([],TFR);
TFRSig               = rmfield(TFRSig,'cfg');

% Save the time limits of the baseline
if nargin==2 && isfield(cfg,'baseline')
    TFRSig.baseline      = cfg.baseline;
end
TFRSig.baselinetype  = cfg.baselinetype;
TFRSig.mask          = cfg.ComputeMask;  % (yes=>NoSignificant=0,ERD=-1,ERS=+1) (no=>NoSignificant=0,ERD/ERS)
TFRSig.alpha         = cfg.alpha;

% Intilize output matrices
TFRSig.ci          = NaN(Nchannels,Nfreqs,2);
% TFRSig.cibl        = NaN(Nchannels,Nfreqs,2);
TFRSig.powspctrmbaseline       = NaN*TFRSig.powspctrm;
TFRSig.powspctrmsignificant    = NaN*TFRSig.powspctrm;
% TFRSig.pval        = NaN*TFRSig.powspctrm;
% TFRSig.hval        = NaN*TFRSig.powspctrm;




%% COMPUTE FOR EACH CHANNEL

for ichan = 1:Nchannels
    fprintf('PILAS: Computing statistics for channel %i of %i \n',ichan,Nchannels);
    
    % Get the TFR for all trials
    P    = squeeze(TFR.powspctrm(:,ichan,:,:));
    P    = permute(P,[2 3 1]); % Nfreq x Nsamples x Nrep
    Pavg = mean(P,3);
    
    % Calcular el intervalo de confianza del baseline, usando...
    if nargin==2 && isfield(cfg,'baseline')
        % ...el intervalo de tiempo cfg.baseline de la misma TFR
        [ ci Pboottrialstmp Pboottrials] = Compute_Bootstat(P,cfg);        
    elseif nargin==3
        % Get the TFRbaseline for all trials
        Pbaseline    = squeeze(TFRbaseline.powspctrm(:,ichan,:,:));
        Pbaseline    = permute(Pbaseline,[2 3 1]); % Nfreq x Nsamples x Nrep
        Pbaselineavg = mean(Pbaseline,3);
        % ...todo el intervalo de tiempo de la segunda TFR
        [ ci Pboottrialstmp Pboottrials] = Compute_Bootstat(Pbaseline,cfg);
    end    
    
    % Plot for debug
    if (0)
        ifreq  = 10;
        
        timebl = TFR.time(cfg.baselntmp);
        
        figure, hold on
        plot(timebl,Pboottrials(:,ifreq),'r','LineWidth',4)
        plot(timebl,squeeze(Pboottrialstmp(1,ifreq,:)))
        line([timebl(1) timebl(end)],[ci(ifreq,1) ci(ifreq,1)],'Color','k','LineStyle','--','LineWidth',4)
        legend('accumulative','surrogate','ci')
        line([timebl(1) timebl(end)],[ci(ifreq,2) ci(ifreq,2)],'Color','k','LineStyle','--','LineWidth',4)
        xlabel('Time (s)'), ylabel('Power'), box on
        title(['Freq=' num2str(TFR.freq(ifreq)) 'Hz   |   CI=[' num2str(ci(ifreq,:)) ']'])
        set(gca,'Xlim',[timebl(1) timebl(end)])
    end
    
    
    % Calcular el baseline usando...
    if nargin==2 && isfield(cfg,'baseline')
        % ...el intervalo de tiempo cfg.baseline de la misma TFR
        bl = mean(Pavg(:,cfg.baselntmp),2);
    elseif nargin==3
        % ...todo el intervalo de tiempo de la segunda TFR
        bl = mean(Pbaselineavg(:,cfg.baselntmp),2);
    end
    
    
    % Apply baseline to the TFRavg
    if strcmp(cfg.baselinetype,'relative')
        
        % Apply baseline to the TFRavg
        Pavgbl = Pavg./repmat(bl,1,Nsamples);
        
        % Apply baseline to the ci
        cibl = ci./[bl bl];
                
        % Compute the significant TFRavg
        Pavgblsig = Pavgbl;
        
        if strcmp(cfg.ComputeMask,'yes')
            % Valores menores a 1 indican desincronizacion
            Pavgblsig(Pavgblsig<1)=-1;
            % Valores mayores a 1 indican desincronizacion
            Pavgblsig(Pavgblsig>1)=+1;
            
            LimsPlotTFRSig = [-1 1];
        else
            LimsPlotTFRSig = [0.5 1.5];
        end
        LimsPlotTFRSig = [0.5 1.5];
        
        % Valores dentro del ci indican que no hay diff significativas
        for ifreq=1:size(Pavgblsig,1)
            IndNoSing = and(Pavgbl(ifreq,:)>cibl(ifreq,1),Pavgbl(ifreq,:)<cibl(ifreq,2));
            if  strcmp(cfg.ComputeMask,'yes')
                Pavgblsig(ifreq,IndNoSing) = 0;
            else
                Pavgblsig(ifreq,IndNoSing) = 1;
            end
        end              
        
    elseif strcmp(cfg.baselinetype,'absolute')
        
        % Apply baseline to the TFRavg
        Pavgbl = (Pavg - repmat(bl,1,Nsamples));
        
        % Apply baseline to the ci
        cibl = ci - [bl bl];
        
        % Compute the significant TFRavg
        Pavgblsig = Pavgbl;
        
        
        if strcmp(cfg.ComputeMask,'yes')
            % Valores menores a 0 indican desincronizacion
            Pavgblsig(Pavgblsig<0)=-1;
            % Valores mayores a 0 indican sincronizacion
            Pavgblsig(Pavgblsig>0)=+1;
            
            LimsPlotTFRSig = [-1 1];
        else
            LimsPlotTFRSig = 0.5*[-max(max(abs(Pavgbl))) max(max(abs(Pavgbl)))];
        end
        LimsPlotTFRSig = 0.5*[-max(max(abs(Pavgbl))) max(max(abs(Pavgbl)))];
        
        % Valores dentro del ci indican que no hay diff significativas
        for ifreq=1:size(Pavgblsig,1)
            IndNoSing = and(Pavgbl(ifreq,:)>cibl(ifreq,1),Pavgbl(ifreq,:)<cibl(ifreq,2));
            Pavgblsig(ifreq,IndNoSing) = 0;
        end
        
    elseif strcmp(cfg.baselinetype,'percentage')
        
        % Apply baseline to the TFRavg
        Pavgbl = (Pavg - repmat(bl,1,Nsamples)) ./ repmat(bl,1,Nsamples) * 100;
        
        % Apply baseline to the ci
        cibl = (ci - [bl bl]) ./ [bl bl] * 100 ;
        
        % Compute the significant TFRavg
        Pavgblsig = Pavgbl;
        
        
        if strcmp(cfg.ComputeMask,'yes')
            % Valores menores a 0 indican desincronizacion
            Pavgblsig(Pavgblsig<0)=-1;
            % Valores mayores a 0 indican desincronizacion
            Pavgblsig(Pavgblsig>0)=+1;
            
            LimsPlotTFRSig = [-1 1];
        else
            LimsPlotTFRSig = 0.5*[-max(max(abs(Pavgbl))) max(max(abs(Pavgbl)))];
        end
        LimsPlotTFRSig = 0.5*[-max(max(abs(Pavgbl))) max(max(abs(Pavgbl)))];
        
        % Valores dentro del ci indican que no hay diff significativas
        for ifreq=1:size(Pavgblsig,1)
            IndNoSing = and(Pavgbl(ifreq,:)>cibl(ifreq,1),Pavgbl(ifreq,:)<cibl(ifreq,2));
            Pavgblsig(ifreq,IndNoSing) = 0;
        end  
        
    else
        error('PILAS: unknown baseline type')
    end
    
    
    % Plot for debug
    if (0)
        figure, clf, imagesc(TFRSig.time,TFRSig.freq,Pavgbl,LimsPlotTFRSig), 
        set(gca,'Ydir','normal'), ylabel('Frequency (Hz)'), xlabel('Time (s)'), title(['TFR relative to [' num2str(cfg.baseline) ']s'])
        %figure(12), imagesc(TFRSig.time,TFRSig.freq,pval),
        %set(gca,'Ydir','normal'), ylabel('Frequency (Hz)'), xlabel('Time (s)'), title('pval')
        %figure(13), imagesc(TFRSig.time,TFRSig.freq,hval),
        %set(gca,'Ydir','normal'), ylabel('Frequency (Hz)'), xlabel('Time (s)'), title('hval')
        figure, clf, imagesc(TFRSig.time,TFRSig.freq,Pavgblsig,LimsPlotTFRSig),
        set(gca,'Ydir','normal'), ylabel('Frequency (Hz)'), xlabel('Time (s)'), title(['Significant TFR relative to [' num2str(cfg.baseline) ']s'])
    end
    
    
    % Save data for the actual channel
    TFRSig.ci(ichan,:,:)         = ci;
    % TFRSig.cibl(ichan,:,:)       = cibl;
    
    TFRSig.powspctrmbaseline(ichan,:,:)      = Pavgbl;
    TFRSig.powspctrmsignificant(ichan,:,:)   = Pavgblsig;
    
    % TFRSig.pval(ichan,:,:)       = pval;
    % TFRSig.hval(ichan,:,:)       = hval;
    
    
    
end % for ichan = 1:Nchannels


clear ans hval ichan pval cfg Pboottrialstmp Pboottrials ci cibl bl
clear ans Pavgbl Pavgblsig pval hval IndSiSing ifreq ComputeMask
clear ans ichan Nchannels Nfreqs Nsamples Ntrials P Pavg TFR
clear ans bl_Nchan bl_Nfreqs

%% Calcular limites para plotear

if strcmp(TFRSig.mask,'yes')
    TFRSig.zlim = [-1.5 1.5];
    
    
elseif strcmp(TFRSig.mask,'no')    
    if strcmp(TFRSig.baselinetype,'relative')
        TFRSig.zlim = [0.5 1.5];
        
    elseif strcmp(TFRSig.baselinetype,'absolute')
        maxabs = max(max(max(abs(TFRSig.powspctrmsignificant))));
        TFRSig.zlim = 0.1*[-maxabs maxabs];
        
    elseif strcmp(TFRSig.baselinetype,'percentage')
        TFRSig.zlim = [-50 50];
        
    end
else
    error('PILAS PERRO...')
end