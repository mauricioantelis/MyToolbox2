function STAT = Compute_EEG1vsEEG2significantdifferences(cfg,EEG1,EEG0)
% TEST DIFFERENCES BETWEEN CONDITIONS IN A BETWEEN-TRIALS EXPERIMENT
% 
% INPUT:
% EEG1 -> EEG triela data in fieldtrip format: EEG1.trial; EEG1.label; EEG1.time; EEG1.fsample
% EEG0 -> EEG triela data in fieldtrip format: EEG0.trial; EEG0.label; EEG0.time; EEG0.fsample
% cfg      = [];
% cfg.alfa = 0.05;
% 
% OUTPUT:
% STAT -> STAT structure as from fieldtrip
% 

% https://www.fieldtriptoolbox.org/tutorial/cluster_permutation_timelock/
% https://www.fieldtriptoolbox.org/example/use_simulated_erps_to_explore_cluster_statistics/


%% NON-PARAMETRIC STATISTICAL TEST (PERMUTATION TEST) IN ALL CHANNELS AND TIMES

% # ---------------------------------------------
% # Non-parametric statistal test (permutation test) in all channels & times

cfg2                  = [];

cfg2.channel          = 'all';
cfg2.parameter        = 'trial';

if ~isfield(cfg,'latency')
    cfg2.avgovertime  = 'no';
else
    cfg2.avgovertime  = 'yes';
    cfg2.latency      = cfg.latency;
end

cfg2.method           = 'montecarlo';
cfg2.statistic        = 'ft_statfun_indepsamplesT';
cfg2.numrandomization = 5000; % round((2^length(EEG1ALLAVG))/2); %'all';  % There are 15 subjects, so 2^15=32768 possible permutations
cfg2.correctm         = 'no';

if ~isfield(cfg,'alpha')
    cfg2.alpha        = 0.05;
else
    cfg2.alpha        = cfg.alpha;
end

cfg2.tail             = 0;
cfg2.correcttail      = 'prob';

% cfg2.computecritval   = 'no';
% cfg2.computestat      = 'no';
% cfg2.computeprob      = 'no';

cfg2.Ntrials1         = length(EEG1.trial);
cfg2.Ntrials0         = length(EEG0.trial);
cfg2.Ntrials          = cfg2.Ntrials1 + cfg2.Ntrials0;

cfg2.design(1,:)      = [1*ones(1,cfg2.Ntrials1) 2*ones(1,cfg2.Ntrials0)];
cfg2.design(2,:)      = [1:cfg2.Ntrials1 1:cfg2.Ntrials0];
cfg2.ivar             = 1; % 1st row in cfg2.design: independent variable

STAT                 = ft_timelockstatistics(cfg2, EEG1, EEG0);

% % # ---------------------------------------------
% % # Info
% The minimum p-value is min(min(abs(STAT.prob)))
% The minimum p-value is 1/cfg2.numrandomization