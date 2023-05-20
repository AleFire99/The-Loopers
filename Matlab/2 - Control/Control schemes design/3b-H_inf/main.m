% H infinity control (mu-control) for robustness

clear
close all
clc

%% System model
% Model parameters
load('sysest09c_trick.mat')   
sysfake = load("sysfake.mat").sysfake;

sysest_ct = d2c(sysest);
sysfake_ct = d2c(sysfake);

v_a_max = 10;       %Maximum voltage                
Ts  = 0.002;        %Sampling time

%% No weights design

P = sysest_ct;
P.u = "u";
P.y = ["theta","alpha"];

sum_2 = sumblk("f = theta + alpha");
sum_1 = sumblk("e = r - f");

P_aug = connect(P, sum_1, sum_2, ["r","u"], ["e", "theta","alpha"]);

nmeas = 2;      %Number of y
ncont = 1;      %Number of u

[K, CL, gamma] = hinfsyn(P_aug,nmeas,ncont);