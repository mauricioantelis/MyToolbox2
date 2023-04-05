function Compute_PlotERP1andERP2_8ChannelsP300(cfg,EEG1AVG,EEG0AVG)



%% PLOT PARAMETERS
% # *********************************************
% # PLOT PARAMETERS
% # *********************************************

% # ---------------------------------------------
% # Plot parameters
if ~isfield(cfg,'Ylim')
    if ~isempty(EEG0AVG)
        cfg.Ylim     = ceil(max(abs([EEG1AVG.avg(:) ; EEG0AVG.avg(:)])));
    else
        cfg.Ylim     = ceil(max(max(abs(EEG1AVG.avg))));
    end    
    fprintf('Ylim: %.2f \n',cfg.Ylim)
end
if ~isfield(cfg,'savefigure')
    cfg.savefigure = 0;
end

% # ---------------------------------------------
% # Define P300 position of the 8 channels in a 4x3 grid
POSITION = [2 5 7 8 9 10 12 11];



%% TOPOGRAPHICAL MAP OF ERP TARGET, NONTARGET
% # *********************************************
% # TOPOGRAPHICAL MAP OF ERP TARGET, NONTARGET
% # *********************************************

% # ---------------------------------------------
% # Plot ERP target, non target
figure, hold on

% # ---------------------------------------------
% # Plot ERPs
for ichan = 1:8
    
    % *****************************
    % Plot ichan
    subplot(4,3,POSITION(ichan)), hold on

    % *****************************
    % Plot lines at x=0 and y=0
    line([-0.0 0.0],[-cfg.Ylim +cfg.Ylim],'color','k','LineWidth',0.3,'LineStyle','-')
    line([EEG1AVG.time(1) EEG1AVG.time(end)],[  0   0],'color','k','LineWidth',0.5,'LineStyle','-')

    % *****************************
    % Plot ERP: target and non-target
    plot(EEG1AVG.time,EEG1AVG.avg(ichan,:),'LineWidth',1,'Color',[0.00,0.45,0.74]);
    if ~isempty(EEG0AVG)
        plot(EEG0AVG.time,EEG0AVG.avg(ichan,:),'LineWidth',1,'Color',[0.85,0.33,0.10]);
    end
    
    %     % *****************************
    %     % Plot ERP area: target and non-target
    %     hh=jbfill(EEG1AVG.time,...
    %         EEG1AVG.avg(ichan,:)+sqrt(EEG1AVG.var(ichan,:)),...
    %         EEG1AVG.avg(ichan,:)-sqrt(EEG1AVG.var(ichan,:)),...
    %         [0.00,0.45,0.74],[0.00,0.45,0.74],0,0.4);
    %     set(hh,'LineStyle','none')
    %     if ~isempty(EEG0AVG)
    %         hh=jbfill(EEG0AVG.time,...
    %             EEG0AVG.avg(ichan,:)+sqrt(EEG0AVG.var(ichan,:)),...
    %             EEG0AVG.avg(ichan,:)-sqrt(EEG0AVG.var(ichan,:)),...
    %             [0.85,0.33,0.10],[0.85,0.33,0.10],0,0.4);
    %         set(hh,'LineStyle','none')
    %     end
    
    % *****************************
    % Set properties
    grid on, box on,
    title(EEG1AVG.label(ichan),'FontSize',10)
    set(gca,'Ylim',[-cfg.Ylim-0.05 cfg.Ylim+0.05])
    set(gca,'Xlim',[EEG1AVG.time(1) EEG1AVG.time(end)])
    set(gca,'XTick',-0.2:0.2:1.2,'XTickLabel',{'','','','','','','',''})
    set(gca,'YTick',-12:2:12,'YTickLabel',{'','','','','','','','','','','','','','','','','','','','','','','','',''})
    
end % for ichan = 1:8
clear ans CHANNELS EEGdiff POSITION

% # ---------------------------------------------
% # Plot axis information
subplot(8,3,[4 7]), cla, hold on
line([-0.0 0.0],[-cfg.Ylim +cfg.Ylim],'color','k','LineWidth',0.3,'LineStyle','-')
line([EEG1AVG.time(1) EEG1AVG.time(end)],[  0   0],'color','k','LineWidth',0.5,'LineStyle','-')
xlabel('Time (s)','FontSize',10), ylabel('Amplitude (\muV)','FontSize',10)
set(gca,'Ylim',[-cfg.Ylim +cfg.Ylim],'YTick',-10:2:10)
set(gca,'Xlim',[floor(EEG1AVG.time(1)*100) ceil(EEG1AVG.time(end)*100)]/100,'XTick',-0.2:0.2:1.2)
box on, grid on
set(gca,'Color','None')

% # ---------------------------------------------
% # Print legend
subplot(8,3,[6 9]), cla, hold on
p1=plot(EEG1AVG.time,EEG1AVG.avg(ichan,:),'LineWidth',1,'Color',[0.00,0.45,0.74]);
if ~isempty(EEG0AVG)
    p2=plot(EEG0AVG.time,EEG0AVG.avg(ichan,:),'LineWidth',1,'Color',[0.85,0.33,0.10]);
end

if ~isempty(EEG0AVG)
    p4=legend([p1 p2],{cfg.Label1,cfg.Label2}); %,'Interpreter','Latex');
else
    p4=legend(p1,cfg.Label1); %,'Interpreter','Latex');
end
set(p4,'Location','North','FontSize',10,'EdgeColor','None','Color','None')
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