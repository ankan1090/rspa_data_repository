list_freq=[];index=[];w=0;
for i=1:length(data_cell)
    temp=[data_cell{i,2} data_cell{i,3} data_cell{i,4}];
    sorted_data=sortrows(temp,2);
    temp_freq=sorted_data(end-100:end,1)';
    w=isempty(list_freq);
    if isempty(list_freq)
        list_freq=[list_freq; temp_freq'];
    else
        for j=1:length(temp_freq)
            k=1;
            while k<=length(list_freq)
                if temp_freq(j)~=list_freq(k)
                    k=k+1;
                else 
                    break;
                end
            end
            if k>length(list_freq)
                list_freq=[list_freq; temp_freq(j)];
            end
        end
    end
end
Fourier_amplitudes=zeros(length(list_freq),length(data_cell));
Fourier_argz=zeros(length(list_freq),length(data_cell));
Fourier_psd=zeros(length(list_freq),length(data_cell));
for i=1:length(data_cell)
    temp=[data_cell{i,2} data_cell{i,3} data_cell{i,4}  data_cell{i,4}];
    for j=1:length(list_freq)
        index=find(list_freq(j)==temp(:,1));
        Fourier_amplitudes(j,i)=temp(index,2);
        Fourier_argz(j,i)=temp(index,3);
        Fourier_psd(j,i)=temp(index,4).*conj(temp(index,4));
    end
end
save all_window_frequencies.mat data_cell -v7.3
save modes_all_data_cell.mat Fourier_amplitudes Fourier_argz Fourier_psd list_freq -v7.3