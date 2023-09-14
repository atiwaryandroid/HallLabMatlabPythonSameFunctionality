function [  ] = FB_set( xem, digi_gain, vcm, vth, vth1, DC_comp)
%% Set Digipart

if digi_gain>15 || digi_gain<1
    disp('Illegal Digital Gain!');
    return;
end

if vth>2 || vth<0
    disp('Illegal Vth!');
    return;
end

if vth1>vth || vth<0
    disp('Illegal Vth1!');
    return;
end

if DC_comp>2 || DC_comp<0
     disp('Illegal DC_comp!');
    return;
end

if vcm>5 || vcm<0
     disp('Illegal Common-mode Voltage!');
    return;
end

% write variable
setwireinvalue(xem, hex2dec('02'),round(digi_gain),hex2dec('fff'));
setwireinvalue(xem, hex2dec('03'),round(vth/5*4096),hex2dec('fff'));
setwireinvalue(xem, hex2dec('04'),round(DC_comp/5*4096),hex2dec('fff'));
setwireinvalue(xem, hex2dec('05'),round(vth1/5*4096),hex2dec('fff'));
setwireinvalue(xem, hex2dec('06'),round(vcm/5*4096),hex2dec('fff'));
updatewireins(xem)
pause(0.01);



% show
fprintf('Digital Gain=%f, Vcm=%f, Vth=%f, Vth1=%f, DC_comp=%f is programmed successfully!\n',digi_gain ,vcm,vth,vth1, DC_comp);
end
