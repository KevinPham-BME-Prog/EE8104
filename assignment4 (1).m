er = readtable("RECORDS.txt", Delimiter='', ReadVariableNames=false);
fs = 500;
r = table2array(er);
feature_array = zeros(72, 472);
for i = (1:size(er))
    re = string(r(i));
    eeg_sig = edfread(re);
    electrode = eeg_sig.Properties.VariableNames;
    counter = 2;
    for z = electrode(1:19)
        zd = string(z);
        eeg_sig_trans = cell2mat(eeg_sig.(zd));
        [imf] = emd(eeg_sig_trans, Interpolation="pchip", MaxNumIMF=5);
        for y = 1:5
            %use hjorth parameters
            imf_y = imf(:,y);
            hjroth_act = hjorthActivity(imf_y);
            hjorth_mob = hjorthMobility(imf_y, hjroth_act);
            diff_imf = diff(imf_y);
            hjroth_com_1 = hjorthActivity(diff_imf);
            hjroth_com_2 = hjorthMobility(diff_imf, hjroth_com_1);
            hjroth_com = hjroth_com_2/hjorth_mob;
            [pxx, f] = pspectrum(imf_y, fs);
            [M, I] = max(pxx);
            peak_amp = M;
            peak_freq = f(I);
            feature_array(i, counter:(counter+4)) = [hjroth_act, hjorth_mob, hjroth_com, peak_amp, peak_freq];
            counter = counter + 5;
        end
    end
    
end


%total length is a minute



%procedure get the power spectrum of each imf
%find the amplitdue of each power spectrum and correesponding band
%width/area
%get approximate entropy
%get the power spectrum area
%get the hjorth parameters: activity, mobility, complexity (make functions)
%make it a function call to generate each signal and add it into a csv
%file/mat file