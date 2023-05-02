clear all
close all
clc
dataKF = load("ppKF_data_28-Apr-2023_12-27-23.mat").Data;
dataSE = load("ppSE_data_28-Apr-2023_12-31-24.mat").Data;


%order time,u,x,y
data = dataSE;
time = data(1,:);

[GND Xest ME_se] = evaluator(dataSE);
plotter(time, GND, Xest)
[GND Xest ME_KF] = evaluator(dataKF);
plotter(time, GND, Xest)
 
display(["State estimator comparisons:";"SE:" + string(ME_se);"KF:" + string(ME_KF)])