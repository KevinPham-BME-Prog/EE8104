function hjorth_mobility = hjorthMobility(eeg_signal, hjorthActivity)
    n = length(eeg_signal) - 1;
    eeg_diff = diff(eeg_signal);
    mean_d = mean(eeg_diff);
    sum_eeg = sum((eeg_signal - mean_d) .^2);
    var_d = sum_eeg / n;
    hjorth_mobility = sqrt(var_d/hjorthActivity);
    %takes an eeg signal the activity aka the variance of the signal and
    %get the mobility of the signal
    %note if you need to solve for the complexity, you need to plug the
    %equation for complexity solve for the variance/hjroth activity and
    %then input it back with the eeg_signal as the derivative
    