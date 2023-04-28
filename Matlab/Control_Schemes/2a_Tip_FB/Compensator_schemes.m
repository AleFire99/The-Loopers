close all
clear all
clc

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

addpath("./Implementations/")
sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0],0);
G_tip_cont = tf(sysest_ct_tip);
eigs = pole(G_tip_cont)
zeros = zero(G_tip_cont)

figure
bode(G_tip_cont);
margin(G_tip_cont);

figure
pzmap(G_tip_cont);

CL = G_tip_cont/(1+G_tip_cont);

figure
step(CL);

figure
bode(CL);
margin(CL);

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

controller = Fires_desiged(sysest_ct);


%% Alp Design

%[controller,K_comp,kd] = pzcancellation(sysest_ct, zeta, wn);

