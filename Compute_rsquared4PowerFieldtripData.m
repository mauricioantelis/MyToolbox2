function [R2, POWcond1Avg, POWcond2Avg] = Compute_rsquared4PowerFieldtripData(POWcond1,POWcond2,doplot)

% To select all features, use Nf=inf

% -----------------------------------
% 1) Compute R2

% Compute POW average
cfg              = [];
cfg.variance     = 'yes';
POWcond1Avg      = ft_freqdescriptives(cfg,POWcond1);
POWcond2Avg      = ft_freqdescriptives(cfg,POWcond2);

% Compute std
POWcond1Avg.powspctrmstd   = POWcond1Avg.powspctrmsem*sqrt(size(POWcond1Avg.powspctrm,1));
POWcond2Avg.powspctrmstd   = POWcond2Avg.powspctrmsem*sqrt(size(POWcond2Avg.powspctrm,1));

% Compute r-squared "R2"
R2.label        = POWcond1.label;
R2.dimord       = 'chan_freq';
R2.freq         = POWcond1.freq;
R2.powspctrm    = NaN(length(R2.label),length(R2.freq));
R2.powspctrm    = Compute_rsquared(permute(POWcond2.powspctrm,[3 2 1]),permute(POWcond1.powspctrm,[3 2 1]))';


%% Debugging: plot rsquared

if (doplot)
    figure, clf, hold on
    imagesc(R2.freq,1:length(R2.label),R2.powspctrm)
    axis([min(R2.freq) max(R2.freq) 0.5 length(R2.label)+0.5])
    xlabel('Frequency (Hz)','FontSize',12), ylabel('Channel','FontSize',12),
    box off, set(gca,'Ytick',1:length(R2.label)-0), set(gca,'YtickLabel',R2.label,'FontSize',12)    
    colorbar
end % if (0)


