function STAT = Compute_EEG1vsEEG2significantdifferences_WRST(cfg,EEG1,EEG2)
% TEST DIFFERENCES BETWEEN CONDITIONS IN A BETWEEN-TRIALS EXPERIMENT
% 
% INPUT:
% EEG1 -> EEG triela data in fieldtrip format: EEG1.trial; EEG1.label; EEG1.time; EEG1.fsample
% EEG0 -> EEG triela data in fieldtrip format: EEG0.trial; EEG0.label; EEG0.time; EEG0.fsample
% cfg      = [];
% cfg.alfa = 0.05;
% cfg.bonferroni = 'yes';
% 
% OUTPUT:
% STAT -> STAT structure as from fieldtrip
% 


%% SET ALPHA

% ----------------------------------------------
% # Set alpha
if ~isfield(cfg,'alpha')
    cfg.alpha        = 0.05;
else
    % Do nothing
end

% # ---------------------------------------------
% # Bonferroni correction
if ~isfield(cfg,'bonferroni')
    cfg.bonferroni = 'no';
else
    % Do nothing
end


%% SET PARAMETERS

% # ---------------------------------------------
% # Compute number of channels and time samples
Nchan = length(EEG1.label);
Nsamp = size(EEG1.time{1},2);

% # ----------------------------------------------
% # Compute data matriz
cfg2                 = [];
cfg2.keeptrials      = 'yes';
AVG1                 = ft_timelockanalysis(cfg2, EEG1);
AVG2                 = ft_timelockanalysis(cfg2, EEG2);

% # ----------------------------------------------
% # Intialize output
STAT                 = [];
STAT.alpha           = cfg.alpha;
STAT.bonferroni      = cfg.bonferroni;
STAT.prob            = NaN(Nchan,Nsamp);
STAT.mask            = NaN(Nchan,Nsamp);
STAT.dimord          = 'chan_time';
STAT.label           = AVG1.label;
STAT.time            = AVG1.time;




%% NON-PARAMETRIC STATISTICAL TEST (WILCOXON RANK SUM TEST) IN ALL CHANNELS AND TIMES

% # ---------------------------------------------
% # Non-parametric statistal test (Wilcoxon rank sum test) in all channels & times

for ichan = 1:Nchan
    for isamp = 1:Nsamp
        
        % Get data for the current channel and time sample
        x1     = squeeze(AVG1.trial(:,ichan,isamp));
        x2     = squeeze(AVG2.trial(:,ichan,isamp));
        
        % Compute p-value of the two-sided Wilcoxon rank sum test
        STAT.prob(ichan,isamp)   = ranksum(x1, x2, 'alpha', cfg.alpha);
        
    end % for isamp = 1:Nsamp
end % for ichan = 1:Nchan



%% COMPUTE MASK

% # ---------------------------------------------
% # Bonferroni correction
if strcmp(cfg.bonferroni,'yes')
    cfg.alpha = cfg.alpha/numel(STAT.prob);
else
    % Do nothing
end

% # ---------------------------------------------
% # Compute mask
STAT.mask = STAT.prob<cfg.alpha;
