close all
clear all
clc

%%
%Loading model
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

Vd = [0.0001, 0, 0.0001, 0];

%% LQGR

% Enlarge the system considering the integral actions
        
Q_lqgr = diag([100, 10, 100, 10]);
R_lqgr = [1];

% We can do so using the |lqr| command:

K_lq = lqr(A_ct, B_ct, Q_lqgr, R_lqgr);

% Addition noises on the states and on the output

Q_kf = diag([0.1, 1, 0.1, 1]);  % The models of state 1 (z) and state 3 (theta) are the most reliable
R_kf = diag([0.1, 0.1]);                     % We trust the measurements more than the linearized model

% Implementation of the Kalman Filter 

L_kf = lqr(A_ct.', C_ct.', Q_kf, R_kf).';













