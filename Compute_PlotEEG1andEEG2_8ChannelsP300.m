function Compute_PlotEEG1andEEG2_8ChannelsP300(cfg,EEG)



%% PLOT PARAMETERS
% # *********************************************
% # PLOT PARAMETERS
% # *********************************************

% # ---------------------------------------------
% # Compute average for the raw EEG
cfg2              = [];

cfg2.keeptrials   = 'yes';
EEGtrials         = ft_timelockanalysis(cfg2,EEG);

cfg2.keeptrials   = 'no';
EEGavg            = ft_timelockanalysis(cfg2,EEG);

% # ---------------------------------------------
% # Plot parameters
if ~isfield(cfg,'Ylim')
    cfg.Ylim = max(EEGtrials.trial(:));
    fprintf('Ylim: %.2f \n',cfg.Ylim)
end


%% TOPOGRAPHICAL MAP OF ERP TARGET, NONTARGET
% # *********************************************
% # TOPOGRAPHICAL MAP OF ERP TARGET, NONTARGET
% # *********************************************

% # ---------------------------------------------
% # Plot ERP target, non target
figure, hold on

% # ---------------------------------------------
% # Plot channels
if strcmp(cfg.PositionSystem,'P300')
    POSITION = [2 5 7 8 9 10 12 11];
elseif strcmp(cfg.PositionSystem,'Unicorn')
    POSITION = [2 4 5 6 8 10 11 12];
end


% # ---------------------------------------------
% # Plot trials
for ichan = 1:8
    
    % *****************************
    % Plot ichan
    subplot(4,3,POSITION(ichan)), hold on    
    plot(EEGtrials.time,squeeze(EEGtrials.trial(:,ichan,:)),'Color',[0.65 0.65 0.65])
    
    plot(EEGavg.time,EEGavg.avg(ichan,:),'Color',[0 0.4470 0.7410])
    hh=jbfill(EEGavg.time,...
        EEGavg.avg(ichan,:)+sqrt(EEGavg.var(ichan,:)),...
        EEGavg.avg(ichan,:)-sqrt(EEGavg.var(ichan,:)),...
        [0 0.4470 0.7410],[0 0.4470 0.7410],0,0.4);
    set(hh,'LineStyle','none')
    
    % *****************************
    % Set properties
    grid on, box on,
    title(EEG.label(ichan),'FontSize',10)
    set(gca,'Ylim',[-cfg.Ylim-0.05 cfg.Ylim+0.05])
    set(gca,'Xlim',[EEGtrials.time(1) EEGtrials.time(end)])
    %set(gca,'XTick',-0.2:0.2:1.2,'XTickLabel',[])
    %set(gca,'YTick',-12:2:12,'YTickLabel',[])
    
end % for ichan = 1:8

% # ---------------------------------------------
% # Plot axis information
%subplot(8,3,[4 7]), cla, hold on
if strcmp(cfg.PositionSystem,'P300')
    subplot(8,3,[4 7])
elseif strcmp(cfg.PositionSystem,'Unicorn')
    subplot(4,3,1)
end
cla, hold on

line([-0.0 0.0],[-cfg.Ylim +cfg.Ylim],'color','k','LineWidth',0.3,'LineStyle','-')
line([EEGtrials.time(1) EEGtrials.time(end)],[  0   0],'color','k','LineWidth',0.5,'LineStyle','-')
xlabel('Time (s)','FontSize',10), ylabel('Amplitude (\muV)','FontSize',10)
set(gca,'Ylim',[-cfg.Ylim +cfg.Ylim])
set(gca,'Xlim',[floor(EEGtrials.time(1)*100) ceil(EEGtrials.time(end)*100)]/100)
box on, grid on
set(gca,'Color','None')

% # ---------------------------------------------
% # Print legend information
% subplot(8,3,[6 9]), cla, hold on
if strcmp(cfg.PositionSystem,'P300')
    subplot(8,3,[6 9])
elseif strcmp(cfg.PositionSystem,'Unicorn')
    subplot(4,3,3)
end
cla, hold on

p1=plot(EEGtrials.time,squeeze(EEGtrials.trial(1,ichan,:)),'Color',[0.65 0.65 0.65]);
p2=plot(EEGavg.time,EEGavg.avg(ichan,:),'Color',[0 0.4470 0.7410]);
p3=area([0 0.2],[cfg.Ylim cfg.Ylim],0,'FaceColor',[0 0.4470 0.7410],'EdgeColor',[0 0.4470 0.7410],'FaceAlpha',0.8);
p4=legend([p1 p2 p3],{'Trials','Average','One sigma'});
set(p4,'Location','North','FontSize',10,'EdgeColor','None','Color','None')
axis([1 2 1*cfg.Ylim 2*cfg.Ylim]), set(gca,'XTick',[]), set(gca,'YTick',[])
box off, axis off
set(gca,'Color','none','Xcolor','none','Ycolor','none')
set(gca,'XColor',[0.5 0.5 0.5])