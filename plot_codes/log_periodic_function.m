%%%%%-----Computation of the Log-periodic parameters------%%%%%

error_tc_vs_t2=[];
global data A B C1 C2 tc
load('max_freq_per_window_freq_5_to_50Hz.mat');
fit_test_data=max_freq_per_window(5105:10:6925,[1 3]);
fid2=fopen('final_point_error_tc_vs_t2.txt','a');
t2=[0:3];
for j1=1                                            %%%%% starting point of the test set window
    abc_matrix=[];
    for j2_n=1:length(t2)                               %%%%% to change the end point of the window
        j2=t2(j2_n);
        abc_matrix=[];
        norm_vec=[];min_val_matrix=[]; raw_norm_vec=[];
        w_it=j1;
        w_len=length(fit_test_data)-10-j2*10;
        t=fit_test_data(w_it:w_len,1);
        f=fit_test_data(w_it:w_len,2);
        for abc=1:100
            disp(abc);
            norm_vec=[];min_val_matrix=[];
            p_min=[max(t) 1.5 4]; p_max=[max(t)+10 10 25];
            n_iter=500;
            test_sse=[];%norm_vec=[];
            y_data=f;
            data=[t y_data];
            for it=1:n_iter
                rand_val=[(p_max(1)-p_min(1))*rand(1,1) (p_max(2)-p_min(2))*rand(1,1) (p_max(3)-p_min(3))*rand(1,1)]+p_min;
                t=data(:,1);
                y_data=data(:,2);
                %p_init=[1.7 10];
                p_init=rand_val;
                a11 = 0; a12 = 0; a13 = 0; a14 = 0; a22 = 0; a23 = 0; a24 = 0; a33 = 0; a34 = 0; a44 = 0; e11 = 0; e21 = 0; e31 = 0; e41 = 0; count = 0;
                t_c=p_init(1);
                m=p_init(2);omega=p_init(3);
                for i=1:length(data)
                    var1 = data(i,:); t_i = var1(1); var_i = var1(2); 
                    a11 = a11+1; 
                    f_i = trial_functions(t_c,t_i,m); 
                    g_i = trial_functions(t_c,t_i,m)*cos(omega*log(t_c-t_i)); 
                    h_i = trial_functions(t_c,t_i,m)*sin(omega*log(t_c-t_i)); 
                    a12 = a12+f_i; a13 = a13+g_i; a14 = a14+h_i; 
                    a22 = f_i^2+a22; a23 = f_i*g_i+a23; a24 = f_i*h_i+a24;
                    a33 = g_i^2+a33; a34 = g_i*h_i+a34; 
                    a44 = h_i^2; 
                    e11 = e11+var_i; e21 = f_i*var_i+e21; e31 = g_i*var_i+e31; e41 = h_i*var_i+e41; 
                    count = count+1;
                end
                X=[a11 a12 a13 a14;...
                   a12 a22 a23 a24;...
                   a13 a23 a33 a34;...
                   a14 a24 a34 a44;];
                b=[e11; e21; e31; e41];
                if abs(det(X))>1e-2
                    y=inv(X)*b;
                    A = y(1); B = y(2); C1 = y(3); C2 = y(4);
                    sse=sum((y_data-lm_lp_modified(p_init,t)).^2);
                    test_sse=[test_sse; sse A B C1 C2 p_init];
                    opt=optimset('display','off','TolX',1e-8,'TolFun',1e-6);
                    [bestParams,fval,exitflag,output] = fminsearch(@errFun,p_init,opt);
                    norm_vec=[norm_vec; exitflag fval bestParams A B C1 C2 p_init sse t(1) t(end)];
                end
            end
            nnv=[];
            l=find(norm_vec(:,end-1)==t(1) & norm_vec(:,end)==t(end));
            id=find(norm_vec(l,1)>0 & imag(norm_vec(l,2))==0 & norm_vec(l,4)>1);
            nnv=norm_vec(l(id),:);
            raw_norm_vec=[raw_norm_vec;nnv];
            min_index=find(nnv(:,2)==min(nnv(:,2)));
            min_val_matrix=[min_val_matrix; nnv(min_index,:)];
            sr=sortrows(min_val_matrix,2);
            abc_matrix=[abc_matrix; sr];
        end
        [lb_cl_tc mean_tc ub_cl_tc]=confidence_interval(abc_matrix,3);
        [lb_cl_m mean_m ub_cl_m]=confidence_interval(abc_matrix,4);
        [lb_cl_omega mean_omega ub_cl_omega]=confidence_interval(abc_matrix,5);
        error_tc_vs_t2=[error_tc_vs_t2; lb_cl_tc mean_tc ub_cl_tc lb_cl_m mean_m ub_cl_m lb_cl_omega mean_omega ub_cl_omega sr(end,end)];
        fprintf(fid2,'%6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t %6.4f\t \n',lb_cl_tc,mean_tc,ub_cl_tc,lb_cl_m,mean_m,ub_cl_m,lb_cl_omega,mean_omega,ub_cl_omega,sr(end,end));
        idx=num2str(j2_n);
        filename=strcat('abc_',idx);
        abcName=sprintf('%s.mat',filename);
        save(abcName,'abc_matrix');
        filename=strcat('rnv_',idx);
        rnvName=sprintf('%s.mat',filename);
        save(rnvName,'raw_norm_vec');
    end
end