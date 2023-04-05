# Toolbox for EEG
Matlab functions for EEG processing and analysis



## Acknowledgments

1) The EEG data structure and many functions used here are from the Fieldtrip toolbox (https://www.fieldtriptoolbox.org/).

Reference: Robert Oostenveld, Pascal Fries, Eric Maris, and Jan-Mathijs Schoffelen. FieldTrip: Open Source Software for Advanced Analysis of MEG, EEG, and Invasive Electrophysiological Data. Computational Intelligence and Neuroscience, 2011; 2011:156869.

2) There are other functions from third parties. See references in the information of the functions

3) Please, let me know if there are functions, code, or methods that are not properly acknowledge, and I will amend it.



## EEG data structure 

- We used the EEG data structure of the Fieldtrip toolbox (https://www.fieldtriptoolbox.org/)

- Example 

EEG.fsample    = 256;

EEG.trial      = cell(1,Ntrials);

EEG.time       = cell(1,Ntrials);

EEG.label      = cell(Nchannels,1);

- Description

EEG.trial --> 1 × Ntrials cell array
{Nchannels×Nsamples double} {Nchannels×Nsamples double} ... {Nchannels×Nsamples double}

EEG.time --> 1 × Ntrials cell array
{1×Nsamples double} {1×Nsamples double} ... {1×Nsamples double}

EEG.label --> Nchannels × 1 cell array
    {'Fp1'}
    {'Fp2'}
    ...
    {'O2' }

