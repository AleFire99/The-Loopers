close all
clear all
clc

addpath("./Implementations/")
addpath("./Arco's Longsim/Simulation_Signals")

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

% To create the long reference's signal for the simulation
Longsim_Signal;                 %All possible references
%Longsim_Signal_Step_Ramp;       %Only ramp and step references
%Longsim_Signal_Sinewaves;       %Only sinewaves references



sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0;0 0 1 0],sysest_ct.D);
G_tip_cont = tf(sysest_ct_tip(1));
eigs_tip = pole(G_tip_cont)
zeros_tip = zero(G_tip_cont)

figure;
bode(G_tip_cont);
margin(G_tip_cont);
grid;

figure;
pzmap(G_tip_cont);

CL = G_tip_cont/(1+G_tip_cont);

% figure;
% step(CL);
% grid;
% 
% figure;
% bode(CL);
% margin(CL);
% grid;

L_poles = pole(CL);
L_zeros = zero(CL);


%% Control with a Compensator 

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 15;

%% PI: Ziegler-Nichols step response method (not good)

%[Kp,Ti] = PI_Ziegler_Nichols(sysest_ct, zeta, wn);

%% JC's design

%controller = JCs_desiged(sysest_ct);

%% Fire's design

%controller = Fires_desiged(sysest_ct);


%% Alp Design 01

%[controller, Kd, K_comp] = pzcancellation(sysest_ct, zeta, wn);

%% Alp Design 02

[controller, Kd, K_comp] = pzcancellation(sysest_ct, zeta, wn);

%% Comparison Part

L_Controlled = controller*G_tip_cont;

figure;
bode(L_Controlled);
margin(L_Controlled);
grid;

figure;
hold on;
sigma(G_tip_cont);
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


%% Save of the Parameters

% controller
% Kd
% K_comp

% save('FB_controller_tip','controller', "Kd",'K_comp')

