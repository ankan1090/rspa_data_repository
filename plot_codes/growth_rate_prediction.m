fit_test_data=max_freq_per_window([2857:10:3751 3751],[1 3]); alpha=1.4; %%%%% 40 slpm/s
% fit_test_data=max_freq_per_window(3754:5011,[1 3]); %%%%% 30 slpm/s
% fit_test_data=max_freq_per_window([5260:10:6925],[1 3]); alpha=1.25; %%%%% 20 slpm/s
% fit_test_data(:,2)=2*fit_test_data(:,2);
fit_test_data(:,1)=fit_test_data(end,1)-fit_test_data(:,1);
bdd=max(abs(diff(fit_test_data(:,2))))/2;
% fit_test_data(:,2)=log(fit_test_data(:,2));
alpha_data=[];
alpha_data=[fit_test_data(end,:)];
last_index=length(fit_test_data(:,2));
temp_y_val=alpha_data(end,2)/alpha;
temp_index=find(fit_test_data(1:last_index-1,2)>temp_y_val-bdd & fit_test_data(1:last_index-1,2)<temp_y_val+bdd);
while (~isempty(temp_index))
        temp_time_length=abs(fit_test_data(temp_index,1)-alpha_data(end,1));
        temp_arr=[fit_test_data(temp_index,:) temp_time_length];
        [trow,tcol]=size(temp_arr);
        sort_arr=sortrows(temp_arr,tcol);
        alpha_data=[alpha_data;sort_arr(end,1:2)];
        last_index=find(fit_test_data(:,1)==alpha_data(end,1));
        temp_y_val=alpha_data(end,2)/alpha;
        temp_index=find(fit_test_data(1:last_index-1,2)>temp_y_val-bdd & fit_test_data(1:last_index-1,2)<temp_y_val+bdd);
end
diff(alpha_data(:,1))
