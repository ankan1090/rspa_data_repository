% clear
% d= load('1.txt');
data = d(:,2);
time_t = d(:,1)-d(1,1);
L = length(data);
fs = 12000;
w = fs;
w_skip = w/10;
k=[1:w_skip:L-w+1];
n=length(k);
hurs=zeros(1,n-1);
frange = [5 25];
for k1 =1:n-1
    datawin(k1,:)= k(k1):k(k1)+w-1;
    wdata=data(datawin(k1,:));
    p=wdata(:);
    ind_t = datawin(k1)+w;
    time_w_end(k1) = time_t(ind_t);
    pp=p-mean(p);
    N = length(p);
    T=1/fs;
    
    %     NFFT=floor(1*fs/1);
    %     NFFT=floor(fs/2);
    NFFT = 2^(nextpow2(N));
    f = fs/2*linspace(0, 1, NFFT/2+1);
    %     p=p(1:NFFT).*h;             %% applying Hann window
    
    P = fft(pp, NFFT)/N;
    Y1 = abs(P(1:NFFT/2+1));
    %   FFT_peak=max(P2(2:end));
    %   f=fs/2*linspace(0,1,NFFT/2+1);
    
    factor = 2;
    fkHz = f./1000;
    %     ffta=factor*((abs(Y1(1:(NFFT/2+1))))).^1;  % amplitude spectrum
    ffta = factor*((abs(Y1(1:(NFFT/2+1))))).^1;  %  power spectrum
    %     FFT_peak(fileNumb1)=factor*max(Y1((3:NFFT/2+1)));
    %   figure;
    %     plot(fkHz,ffta,'k','LineWidth',1.2) %1.2,fontsize12, x,y axis14
    %     set(gca,'FontSize',16,'LineWidth',1,'FontName','Trebuchet MS','FontWeight','normal','XLim',[0 0.5],'YLim',[0 1.7]);
    %     xlabel('Frequency(kHz)','FontSize',16);
    %     ylabel('|P(f)|','FontSize',16);
    fres  = (fs/(NFFT));
    frange1 = floor(frange/fres);
    
    [f0a,ind_f0] = max(ffta(frange1(1):frange1(2)));
    ind_f0 = frange1(1)+ind_f0;
    FFT_peak(k1) = f0a;
    dom_f(k1) = fkHz(ind_f0);
end
            
 plot(time_w_end,FFT_peak)            