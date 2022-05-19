function y_hat = lm_lp_modified(p,t,c)

global data A B C1 C2 tc

t_c=p(1);
m=p(2);
if numel(p)<3
    omega=0;
else 
    omega=p(3);
end

if t_c>t
 y_hat = A+B*trial_functions(t_c,t,m)+C1*trial_functions(t_c,t,m).*cos(log(t_c-t).*omega)+C2*trial_functions(t_c,t,m).*sin(log(t_c-t)*omega);
else
 y_hat = A+B*trial_functions(t_c,t,m)+C1*trial_functions(t_c,t,m).*cos(log(t-t_c).*omega)+C2*trial_functions(t_c,t,m).*sin(log(t-t_c)*omega);
end