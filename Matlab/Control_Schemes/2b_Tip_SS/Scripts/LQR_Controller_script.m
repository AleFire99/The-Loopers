close all
clear all
clc

%% Loading model
sysest = load("sysest09c_trick.mat").sysest;
sysest_cont = d2c(sysest);              % Implementation provided in Continuous time

A_ct = sysest_cont.A;
B_ct = sysest_cont.B;
C_ct = sysest_cont.C;
D_ct = sysest_cont.D;

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

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 10;

s = tf('s');

%% LQR

Q = diag([1000 1 100 1]);     %initial values
R = [1];
K_lqr = lqr(sysest_cont,Q,R);
