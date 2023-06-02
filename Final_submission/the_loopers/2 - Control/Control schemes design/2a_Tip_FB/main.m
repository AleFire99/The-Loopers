close all
clear all
clc

v_a_max = 13;

%% Creation of the Estimated system in State Space

A_sysest_dt = [     1,      0.002,      0,          0;
                    0,      0.928,      1.162,      0.0017;
                    0,      0,          1,          0.002;
                    0,      0.0716,     -1.930,     0.9971];
                
B_sysest_dt = [     0;
                    0.10661;
                    0;
                    -0.1066];
                
C_sysest_dt = [     1,      0,          0,          0;
                    0,      0,          1,          0];
                
D_sysest_dt = [     0;
                    0];
                
Ts = 0.002;

sysest = ss(A_sysest_dt, B_sysest_dt, C_sysest_dt, D_sysest_dt, Ts);

%% Extraction of Matrices  in continuos time

sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

%% Modification of the C matrix to have the tip position

sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0; 0 0 1 0],sysest_ct.D);

G_tip_cont = tf(sysest_ct_tip(1));

s = tf('s');

poles = pole(G_tip_cont)
zeros = zero(G_tip_cont)

figure(1)
margin(G_tip_cont);

figure(2)
pzmap(G_tip_cont);

%% Compensator design

controller  = (s-poles(2))*(s-poles(3))*(s+1)/(s*(s+100)^2);        %Compensator scheme

controller = controller/dcgain(s^2*G_tip_cont*controller);          %Normalization

k = 5;                                                              %Manually finding gain

controller = controller*k

%% Plots

L = G_tip_cont*controller;

figure(3)
margin(L);

figure(4)
pzmap(L);