function STAT = Compute_ERPsignificantpeaks(cfg,EEGAVG)
% INPUT:
% EEG1 -> EEG average data in fieldtrip format: EEG1.avg; EEG0.label; EEG1.time
% cfg               = [];
% cfg.alfa          = 0.05;    -> Same as that employed in "Compute_ERPsignificantpeaks"
% cfg.bl            = [li lf]; ->
% cfg.plotdebugging = 1;       ->
% 
% OUTPUT:
% STAT -> STAT structure as from fieldtrip
% 



%% INITIALIZE OUTPUT

STAT                 = [];
STAT.tipo            = 'KDE';
STAT.probkde         = []; % [Nchan×Nsamples]
STAT.mask            = NaN(length(EEGAVG.label),length(EEGAVG.time));
STAT.dimord          = 'chan_time';
STAT.label           = EEGAVG.label;
STAT.time            = EEGAVG.time;
STAT.cfg             = cfg;

if ~isfield(cfg,'plotdebugging')
    cfg.plotdebugging = 0;
end


%% DO THE TEST FOR EACH CHANNEL

% # ---------------------------------------------
% # Get indexes of the baseline
bl_ind               = EEGAVG.time>=cfg.bl(1) & EEGAVG.time<=cfg.bl(2);

% # ---------------------------------------------
% # For each channel
for ichan = 1:length(STAT.label)
    fprintf('Channel %i of %i\n',ichan,length(STAT.label))
    
    % # ---------------------------------------------
    % # Get data from the baseline
    t_data               = EEGAVG.time(bl_ind);
    x_data               = EEGAVG.avg(ichan,bl_ind);
    
    % # ---------------------------------------------
    % # Get the current data
    t_points             = EEGAVG.time;
    x_points             = EEGAVG.avg(ichan,:);
    
    % # ---------------------------------------------
    % # Kernel density estimate
    [pk, xk]             = ksdensity(x_data);
    
    icdfk_inf            = ksdensity(x_data,cfg.alfa/2,'function','icdf');
    icdfk_sup            = ksdensity(x_data,1- cfg.alfa/2,'function','icdf');
    
    cdfk_pnt             = ksdensity(x_data,x_points,'function','cdf');
    hk                   = cdfk_pnt>(1-cfg.alfa/2) | cdfk_pnt<cfg.alfa/2;
    
    % # ---------------------------------------------
    % # Save results
    STAT.icdfk_inf(ichan,1)= icdfk_inf;
    STAT.icdfk_sup(ichan,1)= icdfk_sup;
    
    STAT.probkde(ichan,:)= cdfk_pnt;
    STAT.mask(ichan,:)   = hk;
    
    % # ---------------------------------------------
    % # Plot for debugging
    if cfg.plotdebugging==1
        
        MaxAbsVol = ceil(max(abs(x_points)));
        
        figure(1), clf, hold on
        
        % Plot normalized histogram and estimated density
        subplot(1,3,1), hold on
        histogram(x_data,'Normalization','pdf','FaceAlpha',0.2,'EdgeAlpha',0.2,...
            'FaceColor',[0.49,0.18,0.56])
        plot(xk,pk,'LineWidth',2,'Color',[0.49,0.18,0.56])
        xlabel('Amplitude (\muV)'), ylabel(''), title('Baseline density estimate')
        box on, grid on
        set(gca,'Xlim',[-MaxAbsVol +MaxAbsVol])
        set(gca,'Ylim',[0 ceil(max(pk)*10)/10],'YTick',0:0.2:2,'YTickLabel',[])
        set(gca,'FontSize',10,'Color','none','Xcolor','k','Ycolor','k')
        camroll(90)
        line([icdfk_inf icdfk_inf],get(gca,'YLim'),'LineStyle',':','Color','k','LineWidth',1)
        line([icdfk_sup icdfk_sup],get(gca,'YLim'),'LineStyle',':','Color','k','LineWidth',1)
        set(gca,'XAxisLocation','top')
        
        % Plot ERP, baseline and significant peaks
        subplot(1,3,2:3), hold on
        xlabel('Time (s)'), ylabel('Amplitude (\muV)'), title(['ERP for channel ' EEGAVG.label{ichan}])
        box on, grid on
        set(gca,'Ylim',[-MaxAbsVol +MaxAbsVol])
        set(gca,'FontSize',10,'Color','none')
        set(gca,'YAxisLocation','right')
        
        % v1:
        %p3=area(STAT.time,hk*+MaxAbsVol,0,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'FaceAlpha',0.4);
        %area(STAT.time,hk*-MaxAbsVol,0,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'FaceAlpha',0.4)
        
        % v2:
        %p3=area(STAT.time,hk.*x_points,0,'FaceColor',[0.85,0.33,0.10],'EdgeColor',[0.85,0.33,0.10],'FaceAlpha',0.4,'ShowBaseLine','off');
        
        % v3: PILAS, al poner la segunda area, entonces la 
        %xx1 = x_points; hh1 = hk;
        %hh1(xx1<=icdfk_sup) = icdfk_sup;
        %xx1(xx1<=icdfk_sup) = icdfk_sup;
        %p3=area(STAT.time,hh1.*xx1,icdfk_sup,'FaceColor',[0.47 0.67 0.19],'EdgeColor',[0.47 0.67 0.19],'FaceAlpha',0.4,'ShowBaseLine','off');
        %set(p3,'BaseValue',icdfk_sup)

        %xx2 = x_points; hh2 = hk;
        %hh2(xx2>=icdfk_inf) = icdfk_inf;
        %xx2(xx2>=icdfk_inf) = icdfk_inf;
        %p6=area(STAT.time,hh2.*xx2,icdfk_inf,'FaceColor',[0.47 0.19 0.67],'EdgeColor',[0.47 0.19 0.67],'FaceAlpha',0.4,'ShowBaseLine','off');
        %set(p6,'BaseValue',icdfk_inf)

        % v4:
        lim = icdfk_sup; Ind_lim = (x_points<lim); t_lim = t_points; x_lim = x_points; x_lim(Ind_lim) = lim;
        p3=jbfill(t_lim,x_lim,lim*ones(size(x_lim)),[0.47,0.67,0.19],[0.47,0.67,0.19],0,0.8);
        
        lim = icdfk_inf; Ind_lim = (x_points>lim); t_lim = t_points; x_lim = x_points; x_lim(Ind_lim) = lim;
        p4=jbfill(t_lim,x_lim,lim*ones(size(x_lim)),[0.85,0.33,0.10],[0.85,0.33,0.10],0,0.8);

        p2=plot(t_data,x_data,':','LineWidth',3,'Color',[0.49,0.18,0.56]);
        p1=plot(t_points,x_points,'LineWidth',1,'Color',[0.00,0.45,0.74]);
        line(get(gca,'XLim'),[icdfk_inf icdfk_inf],'LineStyle',':','Color','k','LineWidth',1)
        line(get(gca,'XLim'),[icdfk_sup icdfk_sup],'LineStyle',':','Color','k','LineWidth',1)
        
        set(gca,'XLim',[min(t_points) max(t_points)])
        
        p=legend([p1 p2 p3 p4],{'ERP','Baseline',['p>' num2str(1-cfg.alfa/2)],['p<' num2str(cfg.alfa/2)]}); %,'Interpreter','Latex');
        set(p,'Location','SouthEast','FontSize',10,'EdgeColor','None','Color','None')
        
        pause
    end % if doplot==1
    
end % for ichan = 1:length(STAT.label)