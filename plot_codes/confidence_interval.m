function [lb_cl mtc ub_cl]=confidence_interval(abc_matrix,col_num)
min_val_matrix=abc_matrix;
n=length(abc_matrix);
index=randperm(length(min_val_matrix));
n=length(abc_matrix);
s=sqrt(var(min_val_matrix(index,col_num)));
c1=0.8; z=1.28;
% c1=0.9;z=1.645;
% c1=0.95;z=1.96;
alf=(1-c1)/2;
mtc=mean(min_val_matrix(index,col_num));
lb_cl=mtc-z*s/sqrt(n);
ub_cl=mtc+z*s/sqrt(n);
%[lb_cl mtc ub_cl]