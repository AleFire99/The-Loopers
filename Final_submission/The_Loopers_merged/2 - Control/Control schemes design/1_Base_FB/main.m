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

G_theta_cont = tf(sysest_ct(1));

poles = pole(G_theta_cont)
zeros = zero(G_theta_cont)

figure
margin(G_theta_cont);

figure
pzmap(G_theta_cont);


%% Compensator design

s = tf("s");

C_desired = (s-poles(3))*(s-poles(2))*(s+3)^2/(s*(s+22)^2*(s+150));      %Compensator scheme

%Manually adjust K
K = 150;

controller = C_desired*K

%% Plots

L_Controlled = controller*G_theta_cont;

figure;
margin(L_Controlled);
grid;

figure;
hold on;
sigma(G_theta_cont);
sigma(L_Controlled)
hold off; legend;
grid;


figure
pzmap(L_Controlled);