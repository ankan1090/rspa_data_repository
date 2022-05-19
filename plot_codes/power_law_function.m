clc
Tc=280.0;
global data A B C1 C2
C1=0; C2=0;
fid3=fopen('power_law_error_tc_vs_t2.txt','a');
raw_norn_vec=[]; error_tc_vs_t2=[];
t2=[0];
for j1=1 %%%%% starting point of moving window
    abc_matrix=[];
    for j2_n=1:length(t2)  %for loop for moving window
        j2=t2(j2_n);
        abc_matrix=[]; norm_vec=[]; min_val_matrix=[];
        w_it=1;
        w_len=length(fit_test_data)-10-j2*10;
        t=fit_test_data(w_it:w_len,1);
        f=fit_test_data(w_it:w_len,2);
        for abc=1:10
            p_min=[max(t) 1.1]; p_max=[max(t)+10 10];
            n_iter=200;
            test_sse=[];
            for it=1:n_iter
                y_data=f;
                data=[t y_data];
                rand_val=[(p_max(1)-p_min(1))*rand(1,1) (p_max(2)-p_min(2))*rand(1,1)]+p_min;
                t=data(:,1);
                y_data=data(:,2);
                p_init=rand_val;
                a11 = 0; a12 = 0; a13 = 0; a14 = 0; a22 = 0; a23 = 0; a24 = 0; a33 = 0; a34 = 0; a44 = 0; e11 = 0; e21 = 0; e31 = 0; e41 = 0; count = 0;
                t_c=p_init(1);m=p_init(2);omega=0;
                for i=1:length(data)
                    var1 = data(i,:); t_i = var1(1); var_i = var1(2); 
                    a11 = a11+1; 
                    %f_i = (t_c-t_i)^m; g_i = (t_c-t_i)^m*cos(omega*log(t_c-t_i)); h_i = (t_c-t_i)^m*sin(omega*log(t_c-t_i)); 
                    f_i = trial_functions(t_c,t_i,m); 
                    a12 = a12+f_i; 
                    a22 = f_i^2+a22;
                    e11 = e11+var_i; e21 = f_i*var_i+e21;
                    count = count+1;
                end

                X=[a11 a12;
                   a12 a22;];
                b=[e11; e21;];
                if abs(det(X))>1e-2
                    y=inv(X)*b;
                    A = y(1); B = y(2);
                    sse=sum((y_data-lm_lp_modified(p_init,t)).^2);
                    test_sse=[test_sse; sse t(1) t(end) A B p_init];
                    opt = optimset('display','notify','TolX',1e-18,'TolFun',1e-8);
                    [bestParams,fval,exitflag,output] = fminsearch(@errFun,p_init,opt);
                    norm_vec=[norm_vec; exitflag fval bestParams A B p_init sse t(1) t(end)];
                end
            end
            nnv=[];
            l=find(norm_vec(:,end-1)==t(1) & norm_vec(:,end)==t(end));
            id=find(norm_vec(l,1)>0 & imag(norm_vec(l,2))==0 & norm_vec(l,4)>0.099);% & norm_vec(l,4)<1);% & norm_vec(l,5)>5 & norm_vec(l,5)<15);
            nnv1=norm_vec(l(id),:);
            raw_norn_vec=[raw_norn_vec;nnv1];
            min_index=find(nnv1(:,2)==min(nnv1(:,2)));
            min_val_matrix=[min_val_matrix; nnv1(min_index,:)];
            sr=sortrows(min_val_matrix,2);
            abc_matrix=[abc_matrix; sr];
        end
        [lb_cl_tc mean_tc ub_cl_tc]=confidence_interval(abc_matrix,3);
        [lb_cl_m mean_m ub_cl_m]=confidence_interval(abc_matrix,4);
        [lb_cl_omega mean_omega ub_cl_omega]=confidence_interval(abc_matrix,5);
        error_tc_vs_t2=[error_tc_vs_t2; lb_cl_tc mean_tc ub_cl_tc lb_cl_m mean_m ub_cl_m lb_cl_omega mean_omega ub_cl_omega sr(end,end)];

    end
end
fclose(fid3);