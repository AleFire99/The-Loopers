close all
clear all
clc

addpath("./Implementations/")
addpath("./Simulation_Signals/")

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

%% Model Parameters coming from resonance measurements

v_a_max = 13;

G_sysest_cont = tf(sysest_ct);
G_theta_cont = G_sysest_cont(1)
G_alpha_cont = G_sysest_cont(2);
eigs = pole(G_sysest_cont(1))
theta_zeros = zero(G_theta_cont)

CL = G_theta_cont/(1+G_theta_cont);

L_poles = pole(CL);
L_zeros = zero(CL);


%% Control with a Compensator 

controller = Fires_design(sysest_ct);

%% Alp design

%[controller,K_comp] = Alps_design(sysest_ct, zeta, wn);

%% Comparison Part

L_Controlled = controller*G_theta_cont;

figure;
bode(L_Controlled);
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

CL_Controlled = L_Controlled/(1+L_Controlled);

figure; hold on;
step(CL);
step(CL_Controlled);
legend;
hold off;
grid;

L_poles = pole(CL_Controlled);
L_zeros = zero(CL_Controlled);

