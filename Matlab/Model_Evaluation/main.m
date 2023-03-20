close all
clear all
clc;
%load datas
load('./states_estimation.mat');
states_estimation = statess_est;        % Optımızatıon based
load('./states_pysics.mat');
states_pysics = statess_phy;            % Accordıng to datasheet
load('./states_validation.mat');
states_validation= states_val;          % Real Data

var = strcat("./Uvec_"+"01"+"_val.mat");
load(var);

Uvec_val= Uvec_val(1,:);          % Real Data

%fourier transformation for all states fs is frequencies, Px are the
%magnitudes normalized 
[fs Pxs_est] = fft2data(states_estimation,Uvec_val);
[fs Pxs_phy] = fft2data(states_pysics,Uvec_val);
[fs Pxs_val] = fft2data(states_validation,Uvec_val);

figure();
hold;
plot(fs,Pxs_est);
plot(fs,Pxs_phy);
plot(fs,Pxs_val);

evaluation_phy = compareffts(Pxs_val, Pxs_phy);
evaluation_est = compareffts(Pxs_val, Pxs_est);

display(["compatison pysics based error:"+ evaluation_phy + " and optimization based error " + evaluation_est])


timerphy = comparetime(states_validation,states_pysics );
timerest = comparetime(states_validation,states_estimation );


display(["compatison pysics based error:"+timerphy + " and optimization based error " + timerest])




