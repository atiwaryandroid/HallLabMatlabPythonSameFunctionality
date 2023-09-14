%% FPGA readout for Hourglass ADC
%close all;
%figure;
fprintf('reading data from FPGA\n');
data_points = 2^16;
data_pipeout_old = readfromblockpipeout(xem, hex2dec('a1'), 1024, 4*data_points);
pause(0.5);
data_pipeout = readfromblockpipeout(xem, hex2dec('a1'), 1024, 4*data_points);


data_out(1:1:data_points) = 0;
for i = 1:1:data_points
    data1 = dec2binarray(data_pipeout((i-1)*4+1));
    data2 = dec2binarray(data_pipeout((i-1)*4+1));
    %data_out(i) = bi2de([fliplr(data1(1:8)) fliplr(data2(3:8))]); 
    data_out(i) = bi2de([data2(3:8) data1(1:8)]); 
end
plot(data_out,'o-');
grid on;
fprintf('        Ref_cnt_avg = %f\n',cnt_diff(data_out));
%% write data
File_Name = ['HR_DIR' sprintf('%d',t_pulse_tdc) datestr(now,'_yyyy-mm-dd_HHMMSS') '.csv'];
sdir = 'C:\Users\Adjain\Documents\MATLAB\EIS_Edwin\FPGA_EIS_V1_array_18rows_EDWIN';
csvwrite(sprintf('%s\\%s',sdir,File_Name), data_out');


