function Compute_EEG1vsEEG2significantdifferencesPlot8ChannelsP300(cfg,EEG1,EEG0,STAT)
% INPUT:
% EEG1 -> EEG average data in fieldtrip format: EEG1.avg; EEG0.label; EEG1.time
% EEG0 -> EEG average data in fieldtrip format: EEG0.avg; EEG0.label; EEG0.time (optional)
% STAT -> STAT structure from "Compute_ERPsignificantpeaks"
% cfg             = [];
% cfg.alfa        = 0.05;        -> Same as that employed in "Compute_ERPsignificantpeaks"
% cfg.Ylim        = 30;          -> Define Ylim: useful to plot several
% cfg.savefigure  = 1;           -> (1|0) - To save figure
% cfg.filename1   = 'FileName1'; -> Sin extension - Se guardan PNG y EPS
% cfg.filename2   = 'FileName2'; -> Sin extension - Se guardan PNG y EPS
%
% OUTPUT:
% None
% 



%% SET PARAMETERS
% # *********************************************
% # SET PARAMETERS
% # *********************************************

% # ---------------------------------------------
% # Define cfg fields
if ~isfield(cfg,'Ylim')
    Ylim1     = ceil(max(max(abs(EEG1.avg)))*100)/100;
    Ylim0     = ceil(max(max(abs(EEG0.avg)))*100)/100;
    cfg.Ylim  = max([Ylim1 Ylim0]);
    fprintf('Ylim: %.2f \n',cfg.Ylim)
end
if ~isfield(cfg,'savefigure')
    cfg.savefigure = 0;
end

% # ---------------------------------------------
% # Define P300 position of the 8 channels in a 4x3 grid
POSITION = [2 5 7 8 9 10 12 11];



%% COMPUTE MASK
% # *********************************************
% # COMPUTE MASK
% # *********************************************

% # ---------------------------------------------
% # Confidence level
if isfield(cfg,'bonferroni')
    if strcmp(cfg.bonferroni,'yes')
        alpha2 = cfg.alpha/numel(STAT.prob);
    end
else
    alpha2 = cfg.alpha;
end

% # ---------------------------------------------
% # Compute mask
STAT.mask = STAT.prob<alpha2;



%% TOPOGRAPHICAL MAP OF ERP1, ERP0 AND SIGNIFICANT PEAKS IN ERP1
% # *********************************************
% # TOPOGRAPHICAL MAP OF ERP1, ERP0 AND SIGNIFICANT PEAKS IN ERP1
% # *********************************************

% # ---------------------------------------------
% # Plot topographical map or ERP1, ERP0 and significant peaks in EPR1
figure, hold on

% # ---------------------------------------------
% # For each channel
for ichan = 1:8
    
    % *****************************
    % Subllot for the current channel
    subplot(4,3,POSITION(ichan)), hold on
    
    % *****************************
    % Plot lines at x=0 and y=0
    line([-0.0 0.0]                   ,[-cfg.Ylim +cfg.Ylim],'color','k','LineWidth',0.3,'LineStyle','-')
    line([EEG1.time(1) EEG1.time(end)],[  0   0]            ,'color','k','LineWidth',0.5,'LineStyle','-')
        
    % *****************************
    % Plot ERPs: ERP1 and ERP0
    plot(EEG1.time,EEG1.avg(ichan,:),'LineWidth',1,'Color',[0.00,0.45,0.74]);
    plot(EEG0.time,EEG0.avg(ichan,:),'LineWidth',1,'Color',[0.85,0.33,0.10]);
    
    % *****************************
    % Plot significant differences as points
    plot(EEG1.time(STAT.mask(ichan,:)),-cfg.Ylim+0*EEG1.avg(ichan,STAT.mask(ichan,:)),'.','MarkerSize',12,'Color',[1 0 1])
    
    % *****************************
    % Plot significant differences as area
    % Opcion 1
    %     x_roof                      = EEG1.avg(ichan,:);
    %     x_roof(~STAT.mask(ichan,:)) = 0;
    %     x_roof( STAT.mask(ichan,:)) = cfg.Ylim;
    %     p3a1=jbfill(EEG1.time,+x_roof,zeros(size(x_roof)),[0.5 0.5 0.5],[0.5 0.5 0.5],0,0.8);
    %     p3a2=jbfill(EEG1.time,-x_roof,zeros(size(x_roof)),[0.5 0.5 0.5],[0.5 0.5 0.5],0,0.8);
    %     set(p3a1,'LineStyle','none')
    %     set(p3a2,'LineStyle','none')
    % Opcion 2
    %     x_roof                      = EEG1.avg(ichan,:);
    %     x_flor                      = EEG0.avg(ichan,:);
    %     x_roof(~STAT.mask(ichan,:)) = 0;
    %     x_flor(~STAT.mask(ichan,:)) = 0;
    %     p3a1=jbfill(EEG1.time,x_roof,x_flor,[0.5 0.5 0.5],[0.5 0.5 0.5],0,0.8);
    %     set(p3a1,'LineStyle','none')
    
    
    % *****************************
    % Set properties
    grid on, box on,
    title(EEG1.label(ichan),'FontSize',10)
    set(gca,'Ylim',[-cfg.Ylim-0.05 cfg.Ylim+0.05])
    set(gca,'Xlim',[EEG1.time(1) EEG1.time(end)])
    set(gca,'XTick',[]), set(gca,'YTick',[])
    set(gca,'YTick',-10:1:10    ,'YTickLabel',[])
    set(gca,'XTick',-0.2:0.2:1.2,'XTickLabel',[])
    
end % for ichan = 1:8
clear ans CHANNELS EEGdiff POSITION

% # ---------------------------------------------
% # Plot information axis: x and y limits and labels
subplot(8,3,[4 7]), cla, hold on
line([-0.0 0.0]                   ,[-cfg.Ylim +cfg.Ylim],'color','k','LineWidth',0.3,'LineStyle','-')
line([EEG1.time(1) EEG1.time(end)],[  0   0]            ,'color','k','LineWidth',0.5,'LineStyle','-')
xlabel('Time (s)','FontSize',10), ylabel('Amplitude (\muV)','FontSize',10)
set(gca,'Ylim',[-cfg.Ylim +cfg.Ylim],'YTick',-10:1:10)
set(gca,'Xlim',[floor(EEG1.time(1)*100) ceil(EEG1.time(end)*100)]/100,'XTick',-0.2:0.2:1.2)
box on, grid on
set(gca,'Color','None')

% # ---------------------------------------------
% # Print legend information
subplot(8,3,[6 9]), cla, hold on
p1=plot(EEG1.time,EEG1.avg(ichan,:),'LineWidth',1,'Color',[0.00,0.45,0.74]);
p2=plot(EEG0.time,EEG0.avg(ichan,:),'LineWidth',1,'Color',[0.85,0.33,0.10]);
p3=plot([0 0],[0 0],'.','MarkerSize',24,'Color',[1 0 1]);
% p4=area([0 0.2],[cfg.Ylim cfg.Ylim],0,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'FaceAlpha',0.8);

p5=legend([p1 p2 p3],{'Target','Non-target',['p<' num2str(cfg.alpha)]});
% p5=legend([p1 p2 p3 p4],{'Target','Non-target',['p<' num2str(cfg.alfa)],['p<' num2str(cfg.alfa)]});
set(p5,'Location','North','FontSize',10,'EdgeColor','None','Color','None')
axis([1 2 1*cfg.Ylim 2*cfg.Ylim]), set(gca,'XTick',[]), set(gca,'YTick',[])
box off, axis off
set(gca,'Color','none','Xcolor','none','Ycolor','none')
set(gca,'XColor',[0.5 0.5 0.5])

% # ---------------------------------------------
% # Save figure
if cfg.savefigure==1
    saveas(gcf,[cfg.filename1 '.png'])
    %saveas(gcf,cfg.filename1,'epsc')
end



%% PLOT CHANNEL VS TIME IMAGE WITH SIGNIFICANT DIFFERENCES 
% # *********************************************
% # PLOT CHANNEL VS TIME IMAGE WITH SIGNIFICANT DIFFERENCES
% # *********************************************

% % *****************************
% % Colormap: (significant: black; no significant: white)
% mymap     = [1 1 1 ; 0 0 0];
% 
% % *****************************
% % Plot channel vs time image with significant diferences
% figure
% imagesc(STAT.time,1:8,STAT.mask)
% colormap(mymap)
% grid off, box on,
% xlabel('Time (s)','FontSize',16)
% ylabel('Channel','FontSize',16)
% title('Significant differences between the two conditions')
% %['red: p<' num2str(cfg.alfa/2) ', green: p>' num2str(1-cfg.alfa/2)]
% set(gca,'FontSize',14)
% set(gca,'YTickLabel',STAT.label,'FontSize',14)
% line([0 0],[0 9],'color',[0 0 0],'LineWidth',2,'LineStyle',':')
% set(gca,'Xlim',[floor(STAT.time(1)*100) ceil(STAT.time(end)*100)]/100)
% set(gca,'XTick',-0.2:0.2:0.8)
% 
% % *****************************
% % Save figure
% if cfg.savefigure==1
%     saveas(gcf,[cfg.filename2 '.png'])
%     %saveas(gcf,cfg.filename2,'epsc')
% end
