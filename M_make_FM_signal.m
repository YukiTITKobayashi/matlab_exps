% M_make_FM_signal.m
% https://jp.mathworks.com/help/matlab/ref/fft.html
% https://watlab-blog.com/2022/06/12/frequency-modulation/

clear
close all

main()


function main()

% S_FM.json
Fs = 1.0e4;
SNAP = 10*Fs;   % 十分スナップ数確保で綺麗な周波数スペクトルを描ける
fc = 10;
f_FM = 1;
df_FM = 1; % 最大偏移幅

Ts = 1 / Fs;
t = Ts * (0:(SNAP-1));

beta_FM = df_FM / f_FM;  % 変調指数

%% Make Signal
% 三角関数
% s = cos(1*2*pi * fc * t + beta_FM * sin(1*2*pi * f_FM * t));
% 複素
% s = exp(1j*2*pi * fc * t + 1j * beta_FM * sin(1*2*pi * f_FM * t));
% アダマール積表現
s = exp(1j*2*pi * fc * t) .* exp(1j * beta_FM * sin(1*2*pi * f_FM * t));

figure
title("Amplitude")
hold on
plot(t, real(s));
plot(t, imag(s));
grid on
xlim([t(1), t(end)])

figure
title("Complex Amplitude")
plot(t, abs(s));
xlim([t(1), t(end)])

%% FFT
FFT_s = fft(s);
% figure
% plot(Fs/SNAP*(0:SNAP-1), abs(FFT_s))
% title("Complex Magnitude of fft Spectrum")
% xlabel("f (Hz)"), ylabel("|fft(X)|")
% figure
% plot(Fs/SNAP*(-SNAP/2:SNAP/2-1), abs(fftshift(FFT_s)))
% title("fft Spectrum in the Positive and Negative Frequencies")
% xlabel("f (Hz)"), ylabel("|fft(X)|")

% MATLABのfftshift()で片側スペクトルを描画するのは公式にない？
P2 = abs(FFT_s/SNAP);
P1 = P2(1:SNAP/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f1 = Fs/SNAP*(0:(SNAP/2));
figure;
plot(f1,P1) 
title("Single-Sided Amplitude Spectrum of s(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
% 描画範囲を狭める
[~,idx_peak] = max(P1);
xlim([-inf, 2*f1(idx_peak)])


end
