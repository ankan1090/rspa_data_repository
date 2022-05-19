% power_law_function
%t_c=sr(1,3); m=sr(1,4); A=sr(1,5); B=sr(1,6);
t_c=fit_test_data(end,1);
tau=t_c-fit_test_data(1:end-1,1);
index=find(log(tau)>0);
tau=t_c-fit_test_data(index,1);
t=fit_test_data(index,1);
y_data=fit_test_data(1:end-1,2);
% l=1:99;
l=index;
dtrend_y=(y_data(l)-A)./trial_functions(t_c,t(l),m);
% dtrend_y=y_difference(index);
mean_dtrend_y=mean(dtrend_y);
sd_dtrend_y=sqrt(var(dtrend_y));
plot(log(t_c-t(l)),(dtrend_y-mean_dtrend_y)/sd_dtrend_y);
[pxx,freq]=plomb(flip(dtrend_y),log(flip(tau)),'normalized');
omega=freq*2*pi;
[pk,f0] = findpeaks(pxx,omega,'MinPeakHeight',5);
% plot(freq*2*pi,pxx,f0,pk,'o');