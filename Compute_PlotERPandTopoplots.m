function Compute_PlotERPandTopoplots(cfg,AVG)
% cfg                 = [];
% cfg.LineWidth       = 1;
% cfg.layout          = layout;
% cfg.Tcen            = [0.2109 0.3359 0.4492]';
% cfg.Twid            = 0.01;
% % cfg.ichan           = 10;
% AVG = AVG1;



%% SET PARAMETERS

% # ---------------------------------------------
% # Define cfg fields
if ~isfield(cfg,'Ylim')
    if isfield(cfg,'ichan')
        cfg.Ylim     = ceil( max( abs( AVG.avg(cfg.ichan,:) ) ) *100)/100;
    else
        cfg.Ylim     = ceil( max( abs( AVG.avg(:) ) ) *100)/100;
    end
end

colors = distinguishable_colors(size(AVG.avg,1),{'w','k'});
% colors = linspecer(size(AVG.avg,1));
% Visualize the colors:
% c1 = distinguishable_colors(16,{'w','k'});
% c2 = linspecer(16);
% figure
% subplot(2,1,1), image(reshape(c1,[1 size(c1)]))
% subplot(2,1,2), image(reshape(c2,[1 size(c2)]))


%% PLOT ERP

% # ---------------------------------------------
% # Initialize figure
figure

% # ---------------------------------------------
% # Plot ERP
subplot(2,1,1), hold on
if isfield(cfg,'ichan')
    plot(AVG.time,AVG.avg(cfg.ichan,:),'Color',[0.00,0.45,0.74],'LineWidth',cfg.LineWidth);
else
    for ichan=1:size(AVG.avg,1)
        plot(AVG.time,AVG.avg(ichan,:),'Color',[0.00,0.45,0.74],'LineWidth',cfg.LineWidth,'Color',colors(ichan,:));
    end
end
xline(0 , 'Color','k','LineWidth',1, 'LineStyle','-')
yline(0 , 'Color','k','LineWidth',1, 'LineStyle','-')
xlabel('Time (s)'), ylabel('\muV'), grid on, box on
% if isfield(cfg,'ichan'), title(AVG.label(cfg.ichan),'FontSize',10)
% else, title('ERP all channels','FontSize',10)
% end
set(gca,'Ylim',[-cfg.Ylim-0.05 cfg.Ylim+0.05],'YTick',-10:2:10)
set(gca,'Xlim',[AVG.time(1) AVG.time(end)] ,'XTick',-2:0.1:2)
set(gca,'FontSize',12)


for i=1:length(cfg.Tcen)
    xline(cfg.Tcen(i) , 'Color','k','LineWidth',2, 'LineStyle',':')
end


%% PLOT TOPOLOTS

cfg.commentpos       = 'middlebottom';
cfg.colorbar         = 'no';
cfg.colorbartext     = '\muV';
cfg.zlim             = [-cfg.Ylim-0.05 cfg.Ylim+0.05];
cfg.interactive      = 'no';

% # ---------------------------------------------
% # Plot topoplots
% subplot(2,5, 6)
% axis off

cfg.colorbar         = 'WestOutside';
subplot(2,3,4)%subplot(2,5, 7)
cfg.xlim                  = cfg.Tcen(1)+cfg.Twid*[-1 +1];
tt                        = round(cfg.Tcen(1),3,'significant');
ss                        = num2str(tt);
cfg.comment               = [ss ' s'];
% cfg.comment               = [num2str(cfg.Tcen(1)) ' s'];
ft_topoplotER(cfg, AVG);
axis square

cfg.colorbar         = 'no';
subplot(2,3,5)%subplot(2,5, 8)
cfg.xlim                  = cfg.Tcen(2)+cfg.Twid*[-1 +1];
tt                        = round(cfg.Tcen(2),3,'significant');
ss                        = num2str(tt);
cfg.comment               = [ss ' s'];
% cfg.comment               = [num2str(cfg.Tcen(2)) ' s'];
ft_topoplotER(cfg, AVG);
axis square


cfg.colorbar         = 'no';
subplot(2,3,6)%subplot(2,5, 9)
cfg.xlim                  = cfg.Tcen(3)+cfg.Twid*[-1 +1];
tt                        = round(cfg.Tcen(3),3,'significant');
ss                        = num2str(tt);
cfg.comment               = [ss ' s'];
%cfg.comment               = [num2str(cfg.Tcen(3)) ' s'];
ft_topoplotER(cfg, AVG);
axis square

% subplot(2,5,10)
% axis off