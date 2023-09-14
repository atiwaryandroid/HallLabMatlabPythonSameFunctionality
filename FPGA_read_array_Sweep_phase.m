%% FPGA readout
%% initial parameter

fprintf('reading data from FPGA\n');
time_run = datestr(now,'_yyyy-mm-dd_HHMMSS');
data_points = 2^12;
data_read_leng = 2^10;

clear cnt_diff_meas;
clear phase;
clear freq; 


%% run the measurement
% sweep freq and phase
runs = 2601;
% phase = 300;
phase = (-80:0.1:180);
% phase(1:1:runs) = 270;
% freq = [5 10 25 50 75 100 250 500 750 1000 2500 5000]*1e3;
% freq = [5  25 50 100 250 500 1000]*1e3;
freq    = 300e3;
Vos     = 0;
Vsin_pp = 2;
% Vsin_pp = (1:0.5:5)*20e-3;
cnt_diff_meas(1:1:runs) = 0;

for f = 1:1:1
    for k=1:1:runs
        fprintf('Run #%d\n',k);
        % setup function generator
%         fg = FunctionGeneratorController(freq(f), phase(k), Vsin_pp, Vos);
        fg = FunctionGeneratorControllerSinSqr(freq,    phase(k), Vsin_pp, Vos);
%         fg = FunctionGeneratorController(freq(f), phase(k), Vsin_pp(k), Vos);

        % readout FPGA data
        pause(1);  
        data_pipeout_old  = readfromblockpipeout(xem, hex2dec('b3'), data_read_leng, 4*data_points);
        pause(1);
        data_pipeout      = readfromblockpipeout(xem, hex2dec('b3'), data_read_leng, 4*data_points);

        % process FPGA data
        data_out = mod(double(data_pipeout(2:4:end)),2^6)*2^8 + double(data_pipeout(1:4:end))+(mod(double(data_pipeout(3:4:end)),2^5)*2^2+fix(double(data_pipeout(2:4:end))/2^6))/128;

        % plot FPGA data
        close all;
        figure;
        plot(data_out,'o-');
        pause(0.1);
        cnt_diff_meas(k) = cnt_diff(data_out);
        fprintf('        Test_cnt_avg = %f\n',cnt_diff_meas(k));
%         pause(15);
    end

    %% write data
    figure;
    plot(phase, cnt_diff_meas,'o-');
    time_run = datestr(now,'_yyyy-mm-dd_HHMMSS');
    File_Name = ['PhaseSweep' time_run '.csv'];
    sdir = 'C:\Users\Adjain\Documents\MATLAB\EIS_v1p1\EIS_V1p1';
    csvwrite(sprintf('%s\\%s',sdir,File_Name), [phase' cnt_diff_meas']);
end