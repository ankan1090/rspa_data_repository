function ssem = errFun(param)

global data
t=data(:,1); y_data=data(:,2);
y_h=lm_lp_modified(param,t);
ssem = sum((y_data-y_h).^2);