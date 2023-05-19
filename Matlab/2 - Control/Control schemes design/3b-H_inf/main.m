% H infinity control (mu-control) for robustness

clear all
close all
clc

%% System model
% Model parameters
load('sysest09c_trick.mat')   

sysest_ct = d2c(sysest);

v_a_max = 10;       %Maximum voltage                
Ts  = 0.002;        %Sampling time
% System matrices:
[A,B,C,D]       =   ssdata(c2d((d2c(sysest)*1),Ts));                  % Model matrices

%% No weights design

A_p = A;
B_p = [B B];
C_p = [C; C];
D_p = zeros(4,2); D_p(1,1) = -1;

P = ss(A_p,B_p,C_p,D_p);

nmeas = 2;      %Number of y
ncont = 1;      %Number of u

[K, CL, gamma] = hinfsyn(P,nmeas,ncont);