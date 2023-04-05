function Compute_EEG1vsEEG2significantdifferencesPlot(cfg,X1,X2,STAT)
% cfg                  = [];
% cfg.LineWidth        = 2;
% cfg.alpha            = 0.05;
% cfg.bonferroni       = 'no';
% cfg.ichan            = 12;
% cfg.Legend1          = 'Q1';
% cfg.Legend2          = 'Q2';
% cfg.layout           = layout;
% cfg.time2plot        = 0.20;
% X1=AVG1; X2=AVG2; STAT=STAT;
% 
% INPUT:
% X1 -> EEG average data in fieldtrip format: X1.avg; X2.label; X1.time
% X2 -> EEG average data in fieldtrip format: X2.avg; X2.label; X2.time (optional)
% STAT -> STAT structure from "Compute_ERPsignificantpeaks"
% 
% cfg             = [];
% cfg.alfa        = 0.05;        -> Same as that employed in "Compute_ERPsignificantpeaks"
% cfg.Ylim        = 30;          -> Define Ylim: useful to plot several
% cfg.bonferroni  = 'no';        -> Do Bonferroni correction
% cfg.ichan       = 1;           -> Channel to plot
%
% OUTPUT:
% None
% 



%% SET PARAMETERS

% # ---------------------------------------------
% # Define cfg fields
if size(STAT.prob,2)~=1
    if ~isfield(cfg,'Ylim') && isfield(cfg,'ichan')
        Ylim1     = ceil( max( abs( X1.avg(cfg.ichan,:) ) ) *100)/100;
        Ylim0     = ceil( max( abs( X2.avg(cfg.ichan,:) ) ) *100)/100;
        cfg.Ylim  = max([Ylim1 Ylim0]);
        %fprintf('Ylim: %.2f \n',cfg.Ylim)
    end
end % if size(STAT.prob,2)~=1



%% COMPUTE MASK

% # ---------------------------------------------
% # Confidence level
if isfield(cfg,'bonferroni') && strcmp(cfg.bonferroni,'yes')
    alpha2 = cfg.alpha/numel(STAT.prob);
else
    alpha2 = cfg.alpha;
end

% # ---------------------------------------------
% # Compute mask
STAT.mask = STAT.prob<alpha2;


%% PLOT CHANNEL VS TIME IMAGE WITH SIGNIFICANT DIFFERENCES 


if size(STAT.prob,2)~=1
    
    % # ---------------------------------------------
    % # Colormap: (significant: black; no significant: white)
    mymap     = [1 1 1 ; 0 0 0];
    
    % # ---------------------------------------------
    % # Plot channel vs time image with significant diferences
    figure
    
    imagesc(STAT.time,1:length(STAT.label),STAT.mask), colormap(mymap)
    xline(0 , 'Color','k','LineWidth',1, 'LineStyle','-')
    
    grid off, box on,
    xlabel('Time (s)','FontSize',16)
    ylabel('Channel','FontSize',16)
    title('Significant differences between the two conditions')
    set(gca,'Ylim',[0.5 length(STAT.label)+0.5] ,'YTick',1:length(STAT.label),'YTickLabel',STAT.label)
    set(gca,'Xlim',[STAT.time(1) STAT.time(end)],'XTick',-2:0.1:2)
    set(gca,'FontSize',12)
    
end % if size(STAT.prob,2)~=1


%% PLOT ERPS OF A CHANNEL AND THEIR SIGNIFICANT DIFFERENCES ALONG TIME

if size(STAT.prob,2)~=1
    
    % # ---------------------------------------------
    % # Plot ERPs and significant differences along time
    
    % # Identify the time points with significant differences
    Tsig = X1.time(STAT.mask(cfg.ichan,:));
    
    if ~isempty(Tsig)
        
        % # ---------------------------------------------
        % # Plot significant differences as points        
        figure, hold on
        
        plot(Tsig,-cfg.Ylim+0*X1.avg(cfg.ichan,STAT.mask(cfg.ichan,:)),'.','MarkerSize',12,'Color',[1 0 1])
        plot(Tsig,+cfg.Ylim+0*X1.avg(cfg.ichan,STAT.mask(cfg.ichan,:)),'.','MarkerSize',12,'Color',[1 0 1])
        for i=1:length(Tsig)-1
            xline(Tsig(i) , 'Color','Magenta','LineWidth',3, 'LineStyle','-','Alpha',0.2)
        end
        p3=xline(Tsig(i+1) , 'Color','Magenta','LineWidth',3, 'LineStyle','-','Alpha',0.2);
        
        % # ---------------------------------------------
        % # Plot ERPs
        p1=plot(X1.time,X1.avg(cfg.ichan,:),'LineWidth',1,'Color',[0.00,0.45,0.74],'LineWidth',cfg.LineWidth);
        p2=plot(X2.time,X2.avg(cfg.ichan,:),'LineWidth',1,'Color',[0.85,0.33,0.10],'LineWidth',cfg.LineWidth);
        
        % # ---------------------------------------------
        % # Plot lines
        xline(0 , 'Color','k','LineWidth',1, 'LineStyle','-')
        yline(0 , 'Color','k','LineWidth',1, 'LineStyle','-')
        
        % # ---------------------------------------------
        % Set properties
        xlabel('Time (s)'), ylabel('\muV'), grid on, box on
        title(X1.label(cfg.ichan),'FontSize',10)
        set(gca,'Ylim',[-cfg.Ylim-0.05 cfg.Ylim+0.05],'YTick',-10:2:10)
        set(gca,'Xlim',[X1.time(1) X1.time(end)] ,'XTick',-2:0.1:2)
        set(gca,'FontSize',12)
        
        % # ---------------------------------------------
        % Legend
        % ax = legend(cfg.Legend1,cfg.Legend2); %
        ax = legend( [p1 p2 p3],{cfg.Legend1,cfg.Legend2,['p<' num2str(alpha2)]} );
        ax.EdgeColor = 'None';
        ax.Color     = 'None';
        ax.FontSize  = 12;
        % ax.Location  = 'North';
        % ax.Position  = [0.8030 0.8718 0.1304 0.1107];
        
    end
    
end % if size(STAT.prob,2)~=1


%% PLOT CHANNELS WITH SIGNIFICANT DIFFERENCES IN A GIVEN TIME INSTANT

% # ---------------------------------------------
% # Plot significant channels at specific time samples
if isfield(cfg,'layout') && isfield(cfg,'time2plot')
    
    % Get time sample
    [~,idx]    = min(abs(STAT.time-cfg.time2plot));
    cfg.itime  = idx;
    
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
    
    figure; ft_topoplotER(cfg2, X1)
    
%         cfg.markerfontsize    = 16;
    
    %warning('PILAS: graficar como verdes y rojos para mostrar si los picos son pos o neg')
    
end




