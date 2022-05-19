%%%%%-------------------------------30 SLPM data-------------------------%%
% fit_test_data=data_30slpm(375:498,1:2);
%fit_test_data=[time(479000:120:609000) yupper(479000:120:609000)];
%%------------------------------------------------------------------------
% l=1:length(data_13slpm)-400;
% fit_test_data=data_13slpm(l,1:2);
%%%%%%%%---------------- 40 SLPM------------------------------------------
%fit_test_data=data_40slpm(285:377,:); fit_test_data(:,2)=fit_test_data(:,2)/217.5*10^6;
%%%%%%-------------------------------------------------------------------------
%%%%%%%%---------------- 60 SLPM------------------------------------------
%fit_test_data=data_60slpm(210:242,:); fit_test_data(:,2)=fit_test_data(:,2)/217.5*10^6;
%%%%%%-------------------------------------------------------------------------
%%%%%%%%---------------- 100 SLPM------------------------------------------
% fit_test_data=data_100slpm(112:150,:); fit_test_data(:,2)=fit_test_data(:,2)/217.5*10^6;
%%%%%-------------------------------------------------------------------------
t_c=fit_test_data(end,1);
tau=t_c-fit_test_data(1:end-1,1);
y_difference=zeros(length(tau),1); rmax=zeros(length(tau),1); rmin=zeros(length(tau),1);
for i=1:length(tau)
    running_max= max(fit_test_data(1:i,2));
    running_min=min(fit_test_data(i:end,2));
    y_difference(i)=running_max-running_min;
    rmax(i)=running_max;
    rmin(i)=running_min;
end
l=1:length(tau);
hold on;
plot(tau(l),y_difference(l),'-r','LineWidth',2);
xlabel('$T_c-t$ (s)','interpreter','latex');
ylabel('y_{max}-y_{min}');
set(gca,'TickLabelInterpreter','latex');