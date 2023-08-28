%% ============================= INFO ==================================%%
% this code is written by:
%  1. Mustafa Elaraby.          +201096650226

%% ============================ clear ================================%%

clear;
clc;

%% =========================== Sampler ===============================%%

[signal,fs] = audioread("input\CantinaBand3.wav");

duration = numel(signal)/fs;
maxFs = duration*fs;

[sig,t] = Sampler(signal,maxFs);

%% =========================== Quantizer =============================%%

L = 256;
mp = max(sig);
quantization_type = 'mid-rise';
signaling_type = 'Manchester';
pulse_amplitude = 5;
bit_dur = (1/(fs*log2(512)));

[quantized,bit_q,Levels,err] = Quantizer(t,sig,L,mp,quantization_type);

%% ============================ Encoder ==============================%%

[encoded,time] = Encoder(bit_q,pulse_amplitude,bit_dur,signaling_type);

%% =========================== Add Noise =============================%%


% Calculate the SNR corresponding to 20%,15%,10%,5%,2.5% noise
signal_power = mean(abs(encoded).^2);

% noise_power = (10^(25/10));                      % 25.0 % noise level
% noise_power = (10^(20/10));                      % 20.0 % noise level
% noise_power = (10^(15/10));                      % 15.0 % noise level
% noise_power = (10^(10/10));                      % 10.0 % noise level
% noise_power = (10^(5/10));                       % 05.0 % noise level
% noise_power = (10^(2.5/10));                     % 2.50 % noise level

SNR = 10*log10(signal_power / noise_power);

% Add noise to the encoded signal
encoded_with_noise = awgn(encoded, SNR, 'measured');

%% ============================ Decoder ==============================%%

[constructed,t2] = Decoder(encoded,bit_dur,Levels,L,signaling_type);

%% =========================== Write out =============================%%

audiowrite('output\CantinaBand_NO_NOISE.wav',constructed,fs);
