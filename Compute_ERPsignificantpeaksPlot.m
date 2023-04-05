function Compute_ERPsignificantpeaksPlot(cfg,EEG1,STAT)
% INPUT:
% EEG1 -> EEG average data in fieldtrip format: EEG1.avg; EEG0.label; EEG1.time
% STAT -> STAT structure from "Compute_ERPsignificantpeaks"
% 
% cfg             = [];
% cfg.alfa        = 0.05;        -> Same as that employed in "Compute_ERPsignificantpeaks"
% cfg.Ylim        = 30;          -> Define Ylim: useful to plot several
% cfg.savefigure  = 1;           -> (1|0) - To save figure
%
% OUTPUT:
% None



%% SET PARAMETERS

% # ---------------------------------------------
% # Define cfg fields
if ~isfield(cfg,'Ylim') && isfield(cfg,'ichan')
    cfg.Ylim             = 1.1*ceil(max(abs(EEG1.avg(cfg.ichan,:)))*100)/100;
    %fprintf('Ylim: %.2f \n',cfg.Ylim)
end

if ~isfield(cfg,'savefigure')
    cfg.savefigure = 0;
end


%% PLOT CHANNEL VS TIME IMAGE WITH SIGNIFICANT DIFFERENCES 

% *****************************
% Get mask for significant positive and negative peaks
pos       = +1* (EEG1.avg>=0); maskpos   = STAT.mask.*pos;
neg       = +1* (EEG1.avg< 0); maskneg   = STAT.mask.*neg;

% *****************************
% Get final mask (positive peaks: +1; negative peaks: -1; no significant: 0)
maskfin   = maskpos - maskneg;

% *****************************
% Colormap: (positive peaks: green; negative peaks: red; no significant: white)
maskID    = sort(unique(maskfin(:)));
if     length(maskID)==3
    mymap         = [0.85,0.33,0.10 ; 1 1 1 ; 0.47,0.67,0.19];
    
elseif length(maskID)==2
    if     maskID(1)==-1 && maskID(2)== 0
        mymap     = [0.85,0.33,0.10 ; 1 1 1                 ];
    elseif maskID(1)== 0 && maskID(2)==+1
        mymap     = [                 1 1 1 ; 0.47,0.67,0.19];
    elseif maskID(1)==-1 && maskID(2)==+1
        mymap     = [0.85,0.33,0.10         ; 0.47,0.67,0.19];
    end
    
elseif lenght(maskID)==1
    if     maskID(1)==-1
        mymap     =     [0.85,0.33,0.10                         ];
    elseif maskID(1)== 0
        mymap     =     [                 1 1 1                 ];
    elseif maskID(1)==-1
        mymap     =     [                         0.47,0.67,0.19];
    end
    
else
    error('PILAS: ESTO NO PUEDE PASAR ¡¡')
end

% *****************************
% Plot channel vs time image with significant diferences
figure
imagesc(STAT.time,1:length(STAT.label),maskfin)
colormap(mymap)
grid off, box on,
xlabel('Time (s)')
ylabel('Channel')
title('Significant negative/positive peaks in red/green')
%['red: p<' num2str(cfg.alfa/2) ', green: p>' num2str(1-cfg.alfa/2)]
set(gca,'FontSize',12)
set(gca,'YTick',1:length(STAT.label),'YTickLabel',STAT.label)
line([0 0],[0 length(STAT.label)+1],'color',[0 0 0],'LineWidth',2,'LineStyle',':')
set(gca,'Xlim',[floor(EEG1.time(1)*100) ceil(EEG1.time(end)*100)]/100)
set(gca,'XTick',-2:0.1:2)


%% PLOT AN ERP WITH SIGNIFICANT PEAKS

if isfield(cfg,'ichan')
    
    % # ---------------------------------------------
    % # Plot ERP and significant peaks
    figure, hold on
    
    % # ---------------------------------------------
    % # Selected channel
    ichan = cfg.ichan;
    
    % # ---------------------------------------------
    % # Plot lines at x=0 and y=0
    line([-0.0 0.0]                   ,[-cfg.Ylim +cfg.Ylim],'color','k','LineWidth',0.3,'LineStyle','-')
    line([EEG1.time(1) EEG1.time(end)],[  0   0]            ,'color','k','LineWidth',0.5,'LineStyle','-')
    
    % # ---------------------------------------------
    % # Plot Significant peaks
    icdfk_inf = STAT.icdfk_inf(ichan);
    icdfk_sup = STAT.icdfk_sup(ichan);
    t_points  = EEG1.time;
    x_points  = EEG1.avg(ichan,:);
    lim = icdfk_sup; Ind_lim = (x_points<lim); t_lim = t_points; x_lim = x_points; x_lim(Ind_lim) = lim;
    p3a=jbfill(t_lim,x_lim,lim*ones(size(x_lim)),[0.47,0.67,0.19],[0.47,0.67,0.19],0,0.8);
    set(p3a,'LineStyle','none')
    lim = icdfk_inf; Ind_lim = (x_points>lim); t_lim = t_points; x_lim = x_points; x_lim(Ind_lim) = lim;
    p3b=jbfill(t_lim,x_lim,lim*ones(size(x_lim)),[0.85,0.33,0.10],[0.85,0.33,0.10],0,0.8);
    set(p3b,'LineStyle','none')
    
    % # ---------------------------------------------
    % # Plot ERPs
    p1 = plot(EEG1.time,EEG1.avg(ichan,:),'LineWidth',2,'Color',[0.00,0.45,0.74]);
    
    % # ---------------------------------------------
    % # Plot lower and upper significant limits
    line(get(gca,'XLim'),[icdfk_inf icdfk_inf],'LineStyle',':','Color',[0.85,0.33,0.10],'LineWidth',1)
    line(get(gca,'XLim'),[icdfk_sup icdfk_sup],'LineStyle',':','Color',[0.47,0.67,0.19],'LineWidth',1)
    
    % # ---------------------------------------------
    % # Set properties
    grid on, box on
    title(EEG1.label(ichan),'FontSize',10)
    xlabel('Time (s)','FontSize',10), ylabel('Amplitude (\muV)','FontSize',10)
    set(gca,'Ylim',[-cfg.Ylim +cfg.Ylim],'YTick',-20:2:20)
    %set(gca,'Xlim',[floor(EEG1.time(1)*100) ceil(EEG1.time(end)*100)]/100,'XTick',-0.2:0.1:1.2)
    set(gca,'Xlim',[EEG1.time(1) EEG1.time(end)],'XTick',-0.2:0.1:1.2)
    box on, grid on
    set(gca,'FontSize',12)
    
    % # ---------------------------------------------
    % # Print legend information
    p2a = area([1 2]+EEG1.time(end),[cfg.Ylim cfg.Ylim],0,'FaceColor',[0.47,0.67,0.19],'EdgeColor',[0.47,0.67,0.19],'FaceAlpha',0.8);
    p2b = area([1 2]+EEG1.time(end),[cfg.Ylim cfg.Ylim],0,'FaceColor',[0.85,0.33,0.10],'EdgeColor',[0.85,0.33,0.10],'FaceAlpha',0.8);
    p4  = legend([p1 p2a p2b],{'ERP',['p>' num2str(1-STAT.cfg.alfa/2)],['p<' num2str(STAT.cfg.alfa/2)]}); %,'Interpreter','Latex');
    set(p4,'Location','NorthEast','FontSize',10,'EdgeColor','None','Color','None')
    
end % if ~isempty(cfg.ichan)

%% PLOT CHANNELS WITH SIGNIFICANT DIFFERENCES IN A GIVEN TIME INSTANT

% # ---------------------------------------------
% # Plot significant channels at specific time samples
if isfield(cfg,'layout') && isfield(cfg,'time2plot')
    
    % Get time sample
    [~,idx]       = min(abs(STAT.time-cfg.time2plot));
    cfg.itime     = idx;
    cfg.time2plot = STAT.time(idx);
    
    % Plot channels with significant differences
    cfg2                  = [];
    cfg2.style            = 'blank';
    cfg2.layout           = cfg.layout;
    cfg2.comment          = 'no';
    
    cfg2.marker           = 'on'; % 'on', 'labels'
    cfg2.markersymbol     = '.';
    cfg2.markercolor      = [0 0 0];
    cfg2.markersize       = 20;
    cfg2.highlight        = 'on';
    cfg2.highlightchannel = find(STAT.mask(:,cfg.itime));
    cfg2.highlightsymbol  = '.';
    cfg2.highlightcolor   = [0 0.4470 0.7410];
    cfg2.highlightsize    = 60;
    
    cfg2.comment          = ['Channels with differences at ' num2str(cfg.time2plot) ' s'];
    cfg2.commentpos       = 'title';
    
    figure; ft_topoplotER(cfg2, EEG1)
    
    %warning('PILAS: graficar como verdes y rojos para mostrar si los picos son pos o neg')
    
end



%% PLOT CHANNEL ERP TARGET, NONTARGET AND SIGNIFICANT DIFFERENCES 
% # *********************************************
% # PLOT CHANNEL ERP TARGET, NONTARGET AND SIGNIFICANT DIFFERENCES 
% # *********************************************

% if isfield(cfg,'chan2plot')
%     if (cfg.chan2plot>=1 && cfg.chan2plot<=length(STAT.label))
%         
%         % # ---------------------------------------------
%         % # Define Ylim
%         if ~isfield(cfg,'Ylim_chan2plot')
%             cfg.Ylim_chan2plot = ceil(max(abs(EEG1.avg(cfg.chan2plot,:))));
%         end
%         
%         
%         
%         % # ---------------------------------------------
%         % # Plot channel ERP target, non target and significant differences
%         figure, hold on
%         
%         % *****************************
%         % Plot lines at x=0 and y=0
%         line([-0.0 0.0],[-Ylim +Ylim],'color','k','LineWidth',0.3,'LineStyle','-')
%         line([-0.2 0.8],[  0   0],'color','k','LineWidth',0.5,'LineStyle','-')
%         
%         % *****************************
%         % Plot Significant peaks
%         % Ind=find(STAT.mask(cfg.chan2plot,:));
%         % plot(EEG1.time(Ind),EEG1.avg(cfg.chan2plot,Ind),'.k','MarkerSize',12)
%         icdfk_inf = STAT.icdfk_inf(cfg.chan2plot);
%         icdfk_sup = STAT.icdfk_sup(cfg.chan2plot);
%         t_points  = EEG1.time;
%         x_points  = EEG1.avg(cfg.chan2plot,:);
%         lim = icdfk_sup; Ind_lim = (x_points<lim); t_lim = t_points; x_lim = x_points; x_lim(Ind_lim) = lim;
%         p3a=jbfill(t_lim,x_lim,lim*ones(size(x_lim)),[0.47,0.67,0.19],[0.47,0.67,0.19],0,0.8);
%         set(p3a,'LineStyle','none')
%         lim = icdfk_inf; Ind_lim = (x_points>lim); t_lim = t_points; x_lim = x_points; x_lim(Ind_lim) = lim;
%         p3b=jbfill(t_lim,x_lim,lim*ones(size(x_lim)),[0.85,0.33,0.10],[0.85,0.33,0.10],0,0.8);
%         set(p3b,'LineStyle','none')
%         
%         % *****************************
%         % Plot ERP: target and non-target
%         p1 = plot(EEG1.time,EEG1.avg(cfg.chan2plot,:),'LineWidth',2,'Color',[0.00,0.45,0.74]);
%         if ~isempty(EEG0)
%             p2 = plot(EEG0.time,EEG0.avg(cfg.chan2plot,:),'LineWidth',2,'Color',[0.85,0.33,0.10]);
%         end
%         
%         % *****************************
%         % Plot lower and upper significant limits
%         line(get(gca,'XLim'),[icdfk_inf icdfk_inf],'LineStyle',':','Color',[.65 .65 .65],'LineWidth',1)
%         line(get(gca,'XLim'),[icdfk_sup icdfk_sup],'LineStyle',':','Color',[.65 .65 .65],'LineWidth',1)
%         
%         % *****************************
%         % Plot legend
%         if ~isempty(EEG0)
%             p4 = legend([p1 p2 p3],{'Target','Non-target',['p<' num2str(cfg.alfa)]}); %'Interpreter','Latex');
%         else
%             %p4 = legend([p1 p3a],{'ERP',['p<' num2str(cfg.alfa)]}); %'Interpreter','Latex');
%             p4 = legend([p1 p3b p3a],{'ERP',['p<' num2str(cfg.alfa/2)],['p>' num2str(1-cfg.alfa/2)]}); %,'Interpreter','Latex');
%         end
%         set(p4,'Location','Southeast','FontSize',14,'EdgeColor','None','Color','None')
%         
%         % *****************************
%         % Set properties
%         set(gca,'FontSize',14)
%         grid on, box on,
%         xlabel('Time (s)','FontSize',16)
%         ylabel('Amplitude (\muV)','FontSize',16)
%         title(EEG1.label(cfg.chan2plot),'FontSize',16)
%         
%         set(gca,'Ylim',[-Ylim_chan2plot +Ylim_chan2plot])
%         set(gca,'YTick',-10:2:10)
%         set(gca,'Xlim',[floor(EEG1.time(1)*100) ceil(EEG1.time(end)*100)]/100)
%         set(gca,'XTick',-0.2:0.2:0.8)
%         
%         % *****************************
%         % Save figure
%         if cfg.savefigure==1 && isfield(cfg,'figureFN2')
%             saveas(gcf,[cfg.figureFN2 '.png'])
%             saveas(gcf,cfg.figureFN2,'epsc')
%         end
%         
%     end
% end