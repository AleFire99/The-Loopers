close all
clear all
clc

sysest = load("sysest.mat").sysest;
sysest_cont = d2c(sysest);              % Implementation provided in Continuous time

G_sysest_cont = tf(sysest_cont);
G_theta_cont = G_sysest_cont(1);
G_alpha_cont = G_sysest_cont(1);
eigs = pole(G_sysest_cont(1));
theta_zeros = zero(G_theta_cont);

figure(1)
bode(G_theta_cont);
margin(G_theta_cont);

figure(2)
pzmap(G_theta_cont);

%% Control with a Compensator 

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 15;

s = tf('s');

%%
%JC's design

syscomp_JC =((s-eigs(3))*(s-eigs(4)))/((s+22)*(s+wn*zeta))     %Poles come from the pid action

num =syscomp_JC.Numerator{:};
dem = syscomp_JC.Denominator{:};

L_JC = syscomp_JC*G_theta_cont;

figure(3)
bode(L_JC);
margin(L_JC);

figure(4)
pzmap(L_JC);

%%
%Fire's design

DC_gain_theta = dcgain(s*G_theta_cont);

C_desired = (s-eigs(3))*(s-eigs(4))/((s+24)*(s+25));      %Compensator scheme
DC_C_des = dcgain(C_desired); 

t_set = 2;       %Good trade-off between speed and robustness
tau = t_set/5;
BW = 1/(tau*DC_C_des*DC_gain_theta);

syscomp_Fire = C_desired*BW

L_Fire = syscomp_Fire*G_theta_cont;

figure(5)
bode(L_Fire);
margin(L_Fire);

figure(6)
pzmap(L_Fire);