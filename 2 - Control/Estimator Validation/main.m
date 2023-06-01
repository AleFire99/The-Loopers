%this file to compare state extractor, Luenberger, Kalman filter
%0.Loads experiments from mat file 
%1.PP and estimators
%2.LQR and estimators
%3.openloop and estimators 
%plotted and calculated the man absolute error

clear all
close all
clc
%% pole placement
%dataKF = load("ppKF_data_28-Apr-2023_12-27-23.mat").Data;
%dataSE = load("ppSE_data_28-Apr-2023_12-31-24.mat").Data;
%dataLO = load("ppLO_data_05-May-2023_09-34-06.mat").Data;

%order time,u,x,y
data = dataSE;
time = data(1,:);


[GND Xest ME_se] = evaluatorPP(dataSE);
plotter(time, GND, Xest,"State Extractor")
[GND Xest ME_KF] = evaluatorPP(dataKF);
plotter(time, GND, Xest,"Kalman Filter")
[GND Xest ME_LO] = evaluatorPP(dataLO);
plotter(time, GND, Xest,"Luenberger Obserber")
 

display(["State estimator comparisons PP:";"SE:" + string(ME_se);"KF:" + string(ME_KF); "LO:" + string(ME_LO)])


%% LQR
%dataKF_lqr = load("Data_StepTests_LQRFire_KFArco2.mat").data;
%dataSE_lqr = load("Data_StepTests_LQRFire_SE2.mat").data;
%dataLO_lqr = load("Data_StepTests_LQRFire_LO2.mat").data;

%order time,u,x,y
time2 = dataSE_lqr(1,:);
time1 = dataLO_lqr(1,:);


[GND Xest ME_se] = evaluatorLQR(dataSE_lqr);
plotter(time2, GND, Xest,"Euler")
[GND Xest ME_KF] = evaluatorLQR(dataKF_lqr);
plotter(time1, GND, Xest,"Kalman Filter")
[GND Xest ME_LO] = evaluatorLQR(dataLO_lqr);
plotter(time1, GND, Xest, "Luenbergerg Observer")
 

display(["State estimator comparisons LQR:";"SE:" + string(ME_se);"KF:" + string(ME_KF); "LO:" + string(ME_LO)])

%% Open loop
%dataKF1 = load("Observer_tests_ConstantSignal_KFAlp.mat").data;
%dataKF2 = load("Observer_tests_ConstantSignal_KFArco.mat").data;
%dataLO = load("Observer_tests_ConstantSignal_LO.mat").data;
%dataSE = load("Observer_tests_ConstantSignal_SE.mat").data;

%order time,u,x,y
time2 = dataKF1(1,:);
time1 = dataKF1(1,:);

[GND Xest ME_SE] = evaluatorOL(dataSE);
plotter(time1, GND, Xest, "Euler") 
%[GND Xest ME_KF1] = evaluatorOL(dataKF1);
%plotter(time2, GND, Xest,"kf1")
[GND Xest ME_KF2] = evaluatorOL(dataKF2);
plotter(time1, GND, Xest,"Kalman Filter")
[GND Xest ME_LO] = evaluatorOL(dataLO);
plotter(time1, GND, Xest, "Luenbergerg Obserber")


display(["State estimator comparisons OL:";...  
     "SE:" + string(ME_SE);...
    % "KF1:" + string(ME_KF1);...
     "KF2:" + string(ME_KF2);
     "LO:" + string(ME_LO)])
