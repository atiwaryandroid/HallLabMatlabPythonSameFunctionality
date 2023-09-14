function [ bin_out] = dec2binarray32(bin_in)
    
    bin_out(1:32) = 0;
    for i = 1:32                    % LSB is at bin_out(1), MSB is at bin_out(32)
        bin_out(i) = mod(bin_in,2);
        bin_in = (bin_in - mod(bin_in,2))/2;
    end

end