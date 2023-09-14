clc; clear;


filename = 'C:\Users\Adjain\Documents\EIS_data\V1p1\O1.csv';
delimiterIn=',';
dataIn1=csvread(filename);
format long
[B1,TF] = rmoutliers(dataIn1(1:9900));
std(dataIn1)
h=histogram(B1,30)
alpha(0.5);
% hold on
% filename = 'C:\Users\Adjain\Documents\EIS_data\V1p1\O1H.csv';
% delimiterIn=',';
% dataIn2=csvread(filename);
% format long
% [B2,TF] = rmoutliers(dataIn2(1:10000));
% std(dataIn2)
% h=histogram(B2,30)
% alpha(0.5);
% legend('DC-Coupled','AC-Coupled')
