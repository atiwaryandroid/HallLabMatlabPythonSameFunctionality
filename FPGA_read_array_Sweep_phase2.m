%% FPGA readout for Hourglass ADC
%% initial parameter

fprintf('reading data from FPGA\n');
time_run = datestr(now,'_yyyy-mm-dd_HHMMSS');
data_points = 2^11;
data_read_leng = 2^10;

clear cnt_diff_meas;
clear phase;
clear freq; 


%% run the measurement
% sweep freq and phase
runs = 1;
% phase = (0:5:360);
% phase = (0.1:0.1:runs);
phase(1:1:runs) = 270;
% no_freq = 6;
% freq = [5 10 25 50 75 100]*1e3;
no_freq = 1;
freq    = 25e3;
Vos     = 1.2;
Vsin_pp = 50e-3;
cnt_diff_meas(1:1:runs,1:1:no_freq) = zeros(runs,no_freq);

for k=1:1:runs
   for f = 1:1:no_freq 
        fprintf('Run #%d-%d\n',k,f);
        % setup function generator
        fg = FunctionGeneratorController(freq(f), phase(k), Vsin_pp, Vos);
%         fg = FunctionGeneratorController(freq,    phase(k), Vsin_pp, Vos);

        % readout FPGA data
        pause(1);  
        data_pipeout_old  = readfromblockpipeout(xem, hex2dec('b3'), data_read_leng, 4*data_points);
        pause(0.1);
        data_pipeout      = readfromblockpipeout(xem, hex2dec('b3'), data_read_leng, 4*data_points);

        % process FPGA data
        data_out = mod(double(data_pipeout(2:4:end)),2^6)*2^8 + double(data_pipeout(1:4:end));

        % plot FPGA data
        close all;
        figure;
        plot(data_out,'o-');
        cnt_diff_meas(k,f) = cnt_diff(data_out);
        fprintf('           Test_cnt_avg = %f\n',cnt_diff_meas(k,f));
   end
   pause(15);
end

    %% write data
    time_run = datestr(now,'_yyyy-mm-dd_HHMMSS');
    File_Name = ['Assay_Glass' time_run '.csv'];
    sdir = 'C:\Users\Adjain\Documents\MATLAB\EIS_Edwin\FPGA_EIS_V1_array_18rows_EDWIN';
    csvwrite(sprintf('%s\\%s',sdir,File_Name), cnt_diff_meas);

    figure;
    hold on;
    for f = 1:1:no_freq
        plot(cnt_diff_meas(:,f),'o-');
    end