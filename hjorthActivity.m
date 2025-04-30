function hjorth_activity =  hjorthActivity(eeg_sig)
    n = length(eeg_signal);
    mean_eeg = mean(eeg_sig);
    diff_eeg = eeg_sig - mean_eeg;
    sum_eeg = sum(diff_eeg.^2);
    hjorth_activity = 1/n*sum_eeg;
%returns the hjorth activity parameter that is calculated
% as the mean square value of the amplitude
%filter it into the specific frequency aka one of the imf
%also needs to be in the time domain