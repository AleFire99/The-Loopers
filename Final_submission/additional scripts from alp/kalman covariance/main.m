% this scrip is to estimate kalman covariance matrix
%1. load real data
%2. simulate over real input
%3. calculate variance of error: (xreal - xsim) 
%
close all
clc
clear all
load("data_newsetup_chirp.mat")
load("sysest09c_trick.mat")
%load("square_wave_in_theta_alpha.mat")

data ;
sysest.A(1,3) = 0;
data(3,:) = -data(3,:)*2*pi/4096; % convert to radians
data(4,:) = data(4,:)*2*pi/4096;
ysim = lsim(sysest, data(2,:),data(1,:)); %simulation according to our model

xgnd = stateestimation(data(3:4,:)); % real accoring to data collected
xsim = stateestimation(ysim');

mean = mean((xgnd-xsim)')
variance = var((xgnd-xsim)')

