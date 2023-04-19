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

%% Control with a Compensator 
%%
%JC's design

syscomp_JC =2.6464+1.1/s; %((s-eigs(2))*(s-eigs(3)))/((s+20)*s)     %Poles come from the pid action

L_JC = syscomp_JC*G_theta_cont;

% figure(3)
% bode(L_JC);
% margin(L_JC);

% figure(4)
% pzmap(L_JC);

%%
% Fire's design

DC_gain_theta = dcgain(s*G_theta_cont);

C_desired = (s-eigs(3))*(s-eigs(2))/((s+24)*(s+25));      %Compensator scheme
DC_C_des = dcgain(C_desired); 

t_set = 2;       %Good trade-off between speed and robustness
tau = t_set/5;
BW = 1/(tau*DC_C_des*DC_gain_theta);

syscomp_Fire = C_desired*BW;

L_Fire = syscomp_Fire*G_theta_cont;

% figure(5)
% bode(L_Fire);
% margin(L_Fire);

% figure(6)
% pzmap(L_Fire);

%% LQR

Q_lqr = diag([1000 1 100 1]);     %initial values
R_lqr = [1];
K_lqr = lqr(sysestc,Q_lqr,R_lqr);

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
