function cnt_avg = cnt_diff(data_in)
    data_in_diff = diff(data_in);
    data_in_med = median(data_in_diff);
    if (data_in_med >2)
    ind = find(data_in_diff<1.5*data_in_med & data_in_diff>0.5*data_in_med ); 
    end
    if (data_in_med <=1)
        ind = find(data_in_diff<=2*data_in_med & data_in_diff>=0 ); 
    end
    if (data_in_med <=2 && data_in_med > 1)
        ind = find(data_in_diff<=2*data_in_med & data_in_diff>=0 ); 
    end
    cnt_avg = mean(data_in_diff(ind)); 
    data_final = data_in_diff(ind);
    std(data_final);
end