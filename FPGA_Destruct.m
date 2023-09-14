function FPGA_Destruct(xptr)
    calllib('okFrontPanel', 'okFrontPanel_Destruct', xptr);
    fprintf('FPGA destruct succesfull\n');
end