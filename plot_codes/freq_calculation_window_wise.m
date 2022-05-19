data=[];
test_set=X1;
time=test_set(:,1)-test_set(1,1);
test_set(:,2)=test_set(:,2)/217.5*10^6;
window_size=12000;
wf=1.0; %%%%% decides the length of the time window
count=0;
data_cell={};
for i=0*window_size:window_size/10:length(test_set)-wf*window_size
    str=test_set(i+1:i+wf*window_size,:);
    str(:,2)=str(:,2)-mean(str(:,2));
    [nfft,freq,psd,FT_coeff]=myfft(str,window_size);
    coeff = (2/nfft)*(sqrt( real(FT_coeff).^2 + imag(FT_coeff).^2 ));
    argz = atan(imag(FT_coeff)./real(FT_coeff));
    temp_psd=2*psd(2:nfft/2+1);
    count=count+1;
    data_cell(count,:)={time(i+1)+wf, freq(2:end)', coeff(2:nfft/2+1), argz(2:nfft/2+1), FT_coeff(2:nfft/2+1), (2/nfft)*psd(2:nfft/2+1)};
end
save all_window_frequencies.mat data_cell -v7.3

[row col]=size(data_cell);
time=[data_cell{:,1}];
max_freq_per_window=[];
for i=1:row
    [i_row i_col]=size(data_cell{i,end});
    temp_Four_all=[data_cell{i,2:end}];
    temp_indx=find(temp_Four_all(:,1)>6 & temp_Four_all(:,1)<34);
    temp_max_freq=max(real(temp_Four_all(temp_indx,end)));
    indx_max_freq=find(real(temp_Four_all(:,end))==temp_max_freq);
    max_freq_per_window=[max_freq_per_window; time(i) temp_Four_all(indx_max_freq,:)];
end
plot(max_freq_per_window(:,1),real(max_freq_per_window(:,3)))
save max_freq_per_window_freq_6_to_34Hz.mat max_freq_per_window -v7.3