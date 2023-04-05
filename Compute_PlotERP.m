function Compute_PlotERP(cfgin,EEG1AVG,EEG0AVG)



%% PLOT ALL TRIALS
% # *********************************************
% # PLOT ALL TRIALS
% # *********************************************





%% TOPOGRAPHICAL MAP OF ERP TARGET, NONTARGET AND DIFFERENCE
% # *********************************************
% # TOPOGRAPHICAL MAP OF ERP TARGET, NONTARGET AND DIFFERENCE
% # *********************************************

% # ---------------------------------------------
% # Calculate the difference between both conditions
cfg                  = [];
cfg.operation        = 'subtract';
cfg.parameter        = 'avg';
EEGdiff              = ft_math(cfg, EEG1AVG, EEG0AVG);

% # ---------------------------------------------
% # Plot topographical map Target, Non target and difference
cfg                  = [];
cfg.showlabels       = 'yes';
cfg.fontsize         = 10;
cfg.layout           = cfgin.layout;
cfg.box              = 'yes';
cfg.showoutline      = 'yes';
cfg.linewidth        = 1;
cfg.showscale        = 'yes';
cfg.showcomment      = 'yes';
ft_multiplotER(cfg,EEG1AVG,EEG0AVG,EEGdiff);
% ft_multiplotER(cfg,EEG1AVG,EEG0AVG);


%% PLOT ERP TARGET, NONTARGET AND DIFFERENCE
% # *********************************************
% # PLOT ERP TARGET, NONTARGET AND DIFFERENCE
% # *********************************************

% % # ---------------------------------------------
% % # Plot channel ERP target, non target and difference
% figure, hold on
% set(gcf,'Position',[403   363   560   303])
% 
% p1 = plot(EEG1AVG.time,EEG1AVG.avg(chan2plot,:),'LineWidth',2);
% p2 = plot(EEG0AVG.time,EEG0AVG.avg(chan2plot,:),'LineWidth',2);
% % p3 = plot(EEGdiff.time,EEGdiff.avg(chan2plot,:),'LineWidth',2);
% % plot(EEGdiff.time,EEGdiff.avg(chan2plot,:)+1,'LineWidth',2);
% % plot(EEGdiff.time,EEGdiff.avg(chan2plot,:)+2,'LineWidth',2);
% % plot(EEGdiff.time,EEGdiff.avg(chan2plot,:)+3,'LineWidth',2);
% % plot(EEGdiff.time,EEGdiff.avg(chan2plot,:)+4,'LineWidth',2);
% % plot(EEGdiff.time,EEGdiff.avg(chan2plot,:)+5,'LineWidth',2);
% % plot(EEGdiff.time,EEGdiff.avg(chan2plot,:)+6,'LineWidth',2);
% % plot(EEGdiff.time,EEGdiff.avg(chan2plot,:)+7,'LineWidth',2);
% 
% set(gca,'FontSize',12)
% grid on, box on,
% xlabel('Time (s)','FontSize',14)
% ylabel('Amplitude (\muV)','FontSize',14)
% title(EEG1AVG.label(chan2plot),'FontSize',14)
% 
% %Ylim = ceil(max(abs([EEG1AVG.avg(chan2plot,:) EEG0AVG.avg(chan2plot,:) EEGdiff.avg(chan2plot,:)])));
% Ylim = ceil(max(abs([EEG1AVG.avg(chan2plot,:) EEG0AVG.avg(chan2plot,:)])));
% set(gca,'Ylim',[-Ylim Ylim])
% set(gca,'XTick',-0.2:0.2:0.8)
% 
% line([-0.0 0.0],[-Ylim +Ylim],'color','k','LineWidth',1,'LineStyle',':')
% line([-0.2 0.8],[  0   0],'color','k','LineWidth',1,'LineStyle',':')
% 
% %p4 = legend([p1 p2 p3],{'Target','Non target','Difference'});
% p4 = legend([p1 p2],{'Target','Non target','Difference'});
% set(p4,'Location','Southeast','FontSize',10,'EdgeColor','None','Color','None')
