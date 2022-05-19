function [nfft,freq,psd,FT_coef]=myfft(str,sample_freq)

L=length(str(:,2));
y=str(:,2);
hanning_y=hann(L,'periodic');
Fs=sample_freq;
%--------------------------------------------------------------------------

NFFT = 2^(nextpow2(L)); % Next power of 2 from length of y
Y = fft(y,NFFT);
f = Fs/2*linspace(0,1,NFFT/2+1); %%%%%Nyquist frequency
PSD=Y.*conj(Y);

nfft=NFFT; freq=f; psd=PSD; FT_coef=Y;
