%% section 1 compare the properties of resampling on the signal 2fs and 1/2fs
signal = load("voice015.txt");
signal = transpose(signal);
original_fs = 8000;
higherfs = 2*original_fs;
lowerfs = original_fs/2;
t1 = (0:1:(length(signal)-1))/original_fs;
x_higher = resample(signal, 2, 1);
t2 = (0:1:(length(x_higher)-1))/higherfs;
x_lower = resample(signal, 1,2);
t3 = (0:1:(length(x_lower)-1))/lowerfs;
figure(1)
subplot(3,1,1)
plot(signal)
title('Reflux signal with sampling frequency of 8000Hz')
ylabel('Amplitude')
xlabel('Samples')
subplot(3,1,2)
plot(x_higher)
title('Reflux signal with resampled frequency of 16000Hz')
ylabel('Amplitude')
xlabel('Samples')
subplot(3,1,3)
plot(x_lower)
title('Reflux signal with resampled frequency of 4000Hz')
ylabel('Amplitude')
xlabel('Samples')
max1 = max(signal);
max2 = max(x_higher);
max3 = max(x_lower);
percentmax1 = max2/max1*100;
percentmax2 = max3/max1*100;

min1 = min(signal);
min2 = min(x_higher);
min3 = max(x_lower);
percentmin1 = abs(min2/min1*100);
percentmin2 = abs(min3/min1*100);

%% section 2 compare the properties of quantization on the signal to lower bits context higher and lower preferebly, 
q1 = quantizer('float','floor',[32 4]);
q2 = quantizer('float','floor',[32 3]);
q1_signal = quantize(q1,signal);
q2_signal = quantize(q2,signal);
figure(2)
subplot(3,1,1)
plot(t1, signal)
title("Reflux signal (32bits)")
ylabel('Amplitude')
xlabel('Time')
subplot(3,1,2)
plot(t1, q1_signal)
title("Reflux signal quantize to 4 bits")
ylabel('Amplitude')
xlabel('Time')
subplot(3,1,3)
plot(t1, q2_signal)
title("Reflux signal quantize to 3 bits")
ylabel('Amplitude')
xlabel('Time')
figure(10)
subplot(2,1,1)
h = histogram(signal - q1_signal);
title("Reflux Orginal vs Requantize 4 bits")
subplot(2,1,2)
h2 = histogram(signal - q2_signal);
title("Reflux Orginal vs Requantize 2 bits")

%% section 3 include random noise and use a synchronized averaging filter (5 vs 10 vs 15) and compare it to the corresponding original signal

noise_1 = signal + 0.1*rand(size(t1));
noise_2 = signal + 0.5*rand(size(t1));
noise_3 = signal + 0.2*rand(size(t1));
noise_4 = signal + 0.3*rand(size(t1));
noise_5 = signal + 0.4*rand(size(t1));
noise_6 = signal + 0.7*rand(size(t1));
noise_7 = signal + 0.8*rand(size(t1));
noise_8 = signal + 0.23*rand(size(t1));
noise_9 = signal + 0.64*rand(size(t1));
noise_10 = signal + 0.35*rand(size(t1));


figure(3)
subplot(3,1,1)
plot(t1, signal)
title("Reflux Orignal Signal")
sync_avg_1 = (noise_1 + noise_2 + noise_3 + noise_4 + noise_5)/5;
sync_avg_2 = (noise_1 + noise_2 + noise_3 + noise_4 + noise_5 + noise_6 + noise_7 + noise_8 + noise_9 + noise_10)/10;
subplot(3,1,2)
plot(t1, sync_avg_1)
title("Synchronized average Signal using 5 noisy images")
subplot(3,1,3)
plot(t1, sync_avg_2)
title("Synchronized average Signal using 10 noisy images")
figure(20)
subplot(2,1,1)
h = histogram(signal - sync_avg_1);
title("Reflux Orginal vs Syncronized Average (5 points)")
subplot(2,1,2)
h2 = histogram(signal - sync_avg_2);
title("Reflux Orginal vs Syncronized Average (10 points)")
SNR1 = snr(signal, sync_avg_1)
SNR2 = snr(signal, sync_avg_2)
%% section 4 repeat section 3 using a moving average filter (4,8,16) and compare it to orignal signal

windowsize1 = 8;
windowsize2 = 16;
windowsize3 = 32;
b1 = (1/windowsize1)*ones(1,windowsize1);
b2 = (1/windowsize2)*ones(1,windowsize2);
b3 = (1/windowsize3)*ones(1,windowsize3);
a = 1;
ma_1_sig = filter(b1, a, noise_1);
ma_2_sig = filter(b2, a, noise_1);
ma_3_sig = filter(b3, a, noise_1);
figure(4)
subplot(4,1,1)
plot(t1, signal)
title("Orignal signal")
subplot(4,1,2)
plot(t1, noise_1)
title("Noisy signal")
subplot(4,1,3)
plot(t1, ma_1_sig)
title("Noisy signal with moving average filter (8 points)")
subplot(4,1,4)
plot(t1, ma_2_sig)
title("Noisy signal with moving average filter (16 points)")


figure(19)
subplot(2,1,1)
h = histogram(signal - sync_avg_1);
title("Reflux Orginal vs Moving Average (8 points)")
subplot(2,1,2)
h2 = histogram(signal - sync_avg_2);
title("Reflux Orginal vs Moving Average (16 points)")
SNR1 = snr(signal, ma_1_sig)
SNR2 = snr(signal, ma_2_sig)

%% make a table of the conditions
type = [];
name = [];
for i = 1:1:45
    s1 = int2str(i);
    if i < 10
        doc_check = strcat("voice00", s1, "-info.txt");
    end
    if i > 10
        doc_check = strcat("voice0", s1, "-info.txt");
    end
    diagnosis = readtable(doc_check);
    result = diagnosis{3,2};
    type = [type, string(result)];
    name = [name, doc_check];
    
end
c = unique(type);
count1 = sum(strcmp(type, c{1}));
count3 = sum(strcmp(type, c{3}));
count4 = sum(strcmp(type, c{4}));
count5 = sum(strcmp(type, c{5}));
count6 = sum(strcmp(type, c{6}));
count2 = 45 - count1 - count3 - count4 - count5;
t = table(transpose(name), transpose(type));