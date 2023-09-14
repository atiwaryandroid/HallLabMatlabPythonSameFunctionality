function [ read_result ] = FPGA_USB_Read( xem,pt_num )
%% Read ADC
%pause time
fs=1e6;
pt=0.65;
%pt_num=2^20;

setwireinvalue(xem, hex2dec('00'),bin2dec('01'),hex2dec('ffffffff'));
updatewireins(xem)
pause(0.01);

setwireinvalue(xem, hex2dec('00'),bin2dec('00'),hex2dec('ffffffff'));
updatewireins(xem);
pause(1.2);

fifo_read_time=ceil(pt_num/2^18*4);
pipeout_num(1:1:pt_num*4)=0;
for i=1:1:fifo_read_time
    fprintf('Read Processing step %d/%d\n',i,fifo_read_time);
    pipeout = readfromblockpipeout(xem, hex2dec('a1'), 8192 ,2^18);
    pipeout_num((i-1)*2^18+1:i*2^18)=pipeout;
    pause(pt);
end
word_array = double(pipeout_num(1:4:end)) + bitshift(double(pipeout_num(2:4:end)),8);
read_result = (word_array./4096).*5;
end