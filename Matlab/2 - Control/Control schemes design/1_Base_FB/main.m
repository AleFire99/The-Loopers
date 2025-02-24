close all
clear all
clc

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

addpath("./Implementations/")

G_sysest_cont = tf(sysest_ct);
G_theta_cont = G_sysest_cont(1)
G_alpha_cont = G_sysest_cont(2);
eigs = pole(G_sysest_cont(1))
theta_zeros = zero(G_theta_cont)

CL = G_theta_cont/(1+G_theta_cont);

L_poles = pole(CL);
L_zeros = zero(CL);


%% Control with a Compensator 

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 10;

%% PI: Ziegler-Nichols step response method (not good)

%[Kp,Ti] = PI_Ziegler_Nichols(sysest_ct, zeta, wn);

%% JC's design

%controller = JCs_design(sysest_ct);

%% Fire's design

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

