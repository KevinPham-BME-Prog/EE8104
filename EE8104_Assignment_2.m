
audiowrite('autosignal1.wav', autoreg_sig1_a5 , 8000);
%% section 1 find the Linear prediction coefficents for 5,25
Fs = 8000;
signal1 = load("voice002.txt"); %hyperkinetic dysphonia
signal2 = load("voice030.txt"); % reflux laryngitis
signal3 = load("voice025.txt"); %healthy

[sig1_a5, sig1_g5] = lpc(signal1, 5);
[sig1_a25, sig1_g25] = lpc(signal1, 10);

[sig2_a5, sig2_g5] = lpc(signal2, 5);
[sig2_a25, sig2_g25] = lpc(signal2, 10);

[sig3_a5, sig3_g5] = lpc(signal3, 5);
[sig3_a25, sig3_g25] = lpc(signal3, 10);

%% find autoregressive signal of each order

autoreg_sig1_a5 = filter(sig1_a5, 1, signal1);
autoreg_sig1_a25 = filter(sig1_a25, 1, signal1);

autoreg_sig2_a5 = filter(sig2_a5, 1, signal2);
autoreg_sig2_a25 = filter(sig2_a25, 1, signal2);

autoreg_sig3_a5 = filter(sig3_a5, 1, signal3);
autoreg_sig3_a25 = filter(sig3_a25, 1, signal3);

figure(2)
err_51 = (sig1_a5 - autoreg_sig1_a25);
err_52 = (sig2_a5 - autoreg_sig1_a25);
err_53 = (sig3_a5 - autoreg_sig1_a25);

subplot(3,1,1)
hist1 = histogram(err_51);
title("Reconstruction Error Signal 1 Order 25")
ylabel('Frequency')
xlabel('Error')
axis tight

subplot(3,1,2)
hist2 = histogram(err_52);
title("Reconstruction Error Signal 2 Order 25")
ylabel('Frequency')
xlabel('Error')
axis tight

subplot(3,1,3)
hist3 = histogram(err_53);
title("Reconstruction Error Signal 3 Order 25")
ylabel('Frequency')
xlabel('Error')
axis tight

%% reconstruct signal using proper coefficents

recon_sig1_a5 = filter(1, 0 - sig1_a5(2:end),signal1);
recon_sig1_a25 = filter(1,0 -  sig1_a25(2:end),signal1);

recon_sig2_a5 = filter(1, 0 - sig2_a5(2:end), signal2);
recon_sig2_a25 = filter(1, 0 - sig2_a25(2:end),signal2);

recon_sig3_a5 = filter(1, 0- sig3_a5(2:end), signal3);
recon_sig3_a25 = filter(1, 0 -  sig3_a25(2:end),signal3);


audiowrite('resignal15.wav', recon_sig1_a5 , 8000);
audiowrite('resignal125.wav', recon_sig1_a25 , 8000);

%% reconstruct using different coefficents

recon_sig12_a5 = filter(1, 0 - sig2_a5(2:end),signal1);
recon_sig12_a25 = filter(1, 0 - sig2_a25(2:end),signal1);

recon_sig13_a5 = filter(1, 0 - sig3_a5(2:end),signal1);
recon_sig13_a25 = filter(1, 0 - sig3_a25(2:end),signal1);

recon_sig21_a5 = filter(1, 0 - sig1_a5(2:end), signal2);
recon_sig21_a25 = filter(1, 0 - sig1_a25(2:end),signal2);

recon_sig23_a5 = filter(1, 0 - sig3_a5(2:end), signal2);
recon_sig23_a25 = filter(1, 0 - sig3_a25(2:end),signal2);

recon_sig31_a5 = filter(1, 0 - sig1_a5(2:end), signal3);
recon_sig31_a25 = filter(1, 0 - sig1_a25(2:end),signal3);

recon_sig32_a5 = filter(1, 0 - sig2_a5(2:end), signal3);
recon_sig32_a25 = filter(1, 0 - sig2_a25(2:end),signal3);


audiowrite('resignal125.wav', recon_sig12_a5 , 8000);
audiowrite('resignal1225.wav', recon_sig12_a25 , 8000);
audiowrite('resignal135.wav', recon_sig13_a5 , 8000);
audiowrite('resignal1325.wav', recon_sig13_a25 , 8000);

%% magnitude analysis order 5 signal 1

figure(1)
x = signal1(2500:2600);
%orignal signal slice
t1 = (0:1:(length(x)-1))/Fs;
seg_sig = signal1(2500:2600);
subplot(3,1,1)
plot(t1, seg_sig)
axis tight
xlabel('Time')
ylabel('Amplitude')
title('Segemented Speech Signal')

% autoregressive of orignal
seg_autoreg_sig1_a5 = autoreg_sig1_a5(2500:2600);
subplot(3,1,2)
plot(t1, seg_autoreg_sig1_a5)
axis tight
axis tight
xlabel('Time')
ylabel('Amplitude')
title('Segemented Autoregressive Signal Order 5')

%reconstructed using  lin coefficent
seg_recon_sig1_a5 = recon_sig1_a5(2500:2600);
seg_recon_sig12_a5 = recon_sig12_a5(2500:2600);
seg_recon_sig13_a5 = recon_sig13_a5(2500:2600);

subplot(3,1,3)
plot(t1, seg_recon_sig1_a5, t1, seg_recon_sig12_a5, t1, seg_recon_sig13_a5)
axis tight
legend('Orignal LPC', 'Reconstruct Signal 2 LPC', 'Reconstruct Signal 3 LPC')
axis tight
xlabel('Time')
ylabel('Amplitude')
title('Reconstructed Speech Signal Order 5')

figure(2)
err_251 = (signal1 - recon_sig1_a25);
err_252 = (signal1 - recon_sig12_a25);
err_253 = (signal1 - recon_sig13_a25);

subplot(3,1,1)
hist1 = histogram(err_51);
title("Reconstruction Error Orignal LPC")
ylabel('Frequency')
xlabel('Error')
axis tight
subplot(3,1,2)
hist2 = histogram(err_52);
title("Reconstruction Error LPC 2")
ylabel('Frequency')
xlabel('Error')
axis tight

subplot(3,1,3)
hist3 = histogram(err_53);
title("Reconstruction Error LPC 3")
ylabel('Frequency')
xlabel('Error')
axis tight


%% magnitude analysis order 25 signal 1

figure(3)

%orignal signal slice
seg_sig = signal1(2500:2600);
t1 = (0:1:(length(seg_sig)-1))/Fs;
subplot(3,1,1)
plot(t1, seg_sig)
axis tight
xlabel('Time')
ylabel('Amplitude')
title('Segemented Speech Signal')

% autoregressive of orignal
seg_autoreg_sig1_a25 = autoreg_sig1_a25(2500:2600);
subplot(3,1,2)
plot(t1, seg_autoreg_sig1_a25)
axis tight
xlabel('Time')
ylabel('Amplitude')
title('Segemented Autoregressive Signal Order 25')

%reconstructed using  lin coefficent
seg_recon_sig1_a25 = recon_sig1_a25(2500:2600);
seg_recon_sig12_a25 = recon_sig12_a25(2500:2600);
seg_recon_sig13_a25 = recon_sig13_a25(2500:2600);

subplot(3,1,3)
plot(t1, seg_recon_sig1_a25, t1, seg_recon_sig12_a25, t1, seg_recon_sig13_a25)
legend('Orignal LPC', 'Reconstruct Signal 2 LPC', 'Reconstruct Signal 3 LPC')
axis tight
xlabel('Time')
ylabel('Amplitude')
title('Reconstructed Speech Signal Order 25')



figure(4)
err_251 = (signal1 - recon_sig1_a25);
err_252 = (signal1 - recon_sig12_a25);
err_253 = (signal1 - recon_sig13_a25);

subplot(3,1,1)
hist1 = histogram(err_251);
title("Reconstruction Error Orignal LPC Order 25")
ylabel('Frequency')
xlabel('Error')
axis tight
subplot(3,1,2)
hist2 = histogram(err_252);
title("Reconstruction Error LPC 2 Order 25")
ylabel('Frequency')
xlabel('Error')
axis tight

subplot(3,1,3)
hist3 = histogram(err_253);
title("Reconstruction Error LPC 3 Order 25")
ylabel('Frequency')
xlabel('Error')
axis tight