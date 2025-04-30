%% initialization
fs = 8000;
%signal choice
signal_1 = load("ECGPCG0010.mat"); %sitting on armchair signal
signal_2 = load("ECGPCG0013.mat"); %laying on bed signal
signal_3 = load("ECGPCG0042.mat"); %walking at constant speed 3.7km/h
chosen_signal = load("ECGPCG0030.mat"); %pedaling a stationary bicycle
chosen_ECG = chosen_signal.ECG(100001:140000);
chosen_PCG = chosen_signal.PCG(100001:140000);
t = (0:1:(40000-1)) / 8000;
%% filter and noise initlization
rls_10 = dsp.RLSFilter(10, 'ForgettingFactor', 0.98);

lms_10 = dsp.LMSFilter('Length',10,'StepSize',0.008);


pink = dsp.ColoredNoise('pink', SamplesPerFrame=40000);
pink_x = pink();
pink_x = transpose(pink_x);

%% signal selection, image naming and noise development
fig_num = 1;
for i = 1:1:3
    if i == 1
        target_ECG = signal_1.ECG(100001:140000);
        target_PCG = signal_1.PCG(100001:140000);
        img_name = "sitting_on_chair"
    elseif i == 2
        target_ECG = signal_2.ECG(100001:140000);
        target_PCG = signal_2.PCG(100001:140000);
        img_name = "laying_on_bed"
    else
        target_ECG = signal_3.ECG(100001:140000);
        target_PCG = signal_3.PCG(100001:140000);
        img_name = "walking"
    end
%plot the noisy signal
    for x = 1:1:2
        if x == 1
            target_sig = target_ECG;
            overlapped_signal = target_sig + chosen_ECG;
            imgtype = "ecg"
        else
            target_sig = target_PCG;
            overlapped_signal = target_sig + chosen_PCG;
            imgtype = "pcg"
        end
        noise_1_5 = awgn(target_sig, 5, "measured");
        noise_1_10 = awgn(target_sig, 10, "measured");
        pink_noise = target_sig + pink_x;

        figure(fig_num)
        subplot(5,1,1)
        plot(t, target_sig)
        xlabel("Time")
        ylabel("Amplitude")
        title("Target Signal")

        subplot(5,1,2)
        plot(t, noise_1_5)
        xlabel("Time")
        ylabel("Amplitude")
        title("White Noise 5dB Signal")

        subplot(5,1,3)
        plot(t, noise_1_10)
        xlabel("Time")
        ylabel("Amplitude")
        title("White Noise 10 dB Signal")

        subplot(5,1,4)
        plot(t, pink_noise)
        xlabel("Time")
        ylabel("Amplitude")
        title("Pink Noise Signal")

        subplot(5,1,5)
        plot(t, overlapped_signal)
        xlabel("Time")
        ylabel("Amplitude")
        title("Overlapped Signal Noise Signal")


        fig_num = fig_num + 1;


        %use the adaptive filter

        for z = 1:1:4
            if z == 1
                noisy_sig = noise_1_5;
            elseif z == 2
                noisy_sig = noise_1_10;
            elseif z == 3
                noisy_sig = pink_noise;
            else
                noisy_sig = overlapped_signal;
            end

                if size(noisy_sig) ~= size(target_sig)
                    target_sig = transpose(target_sig);
                end
                [r1, re1] = rls_10(noisy_sig,target_sig);
                mse1 = msesim(rls_10, noisy_sig, target_sig);
                

                noisy_sig = transpose(noisy_sig);
                target_sig = transpose(target_sig);
                [l1, le1, w] = lms_10(noisy_sig,target_sig);
                mse2 = msesim(lms_10, noisy_sig, target_sig);
                

                %plot filtered results rls vs lms
                if size(mse1) == 1
                    mse1 = mse1.*ones(size(mse2));
                end

                figure(fig_num)
                subplot(3,1,1)

                plot(t, r1)
                xlabel("Time")
                ylabel("Amplitude")
                title("RLS Signal")
                subplot(3,1,2)

                plot(t, l1)
                xlabel("Time")
                ylabel("Amplitude")
                title("LMS Signal")
                
                subplot(3,1,3)
                semilogy(0:1:(40000-1), mse1 , 0:1:(40000-1), mse2)
                xlabel('Iteration')
                ylabel('MSE(dB)')
                title('learning curve')
       

                fig_num = fig_num + 1;
        end


    end
end



%% find the P wave, QRS and the T wave
%% find s1 and s2 of phonocardiogramgram using the P wave and T wave