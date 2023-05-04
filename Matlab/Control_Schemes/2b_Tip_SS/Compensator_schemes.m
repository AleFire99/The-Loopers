close all
clear all
clc

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

addpath("./Implementations/")
sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0; 0 0 1 0],sysest_ct.D);
G_tip_cont = tf(sysest_ct_tip(1))
eigs_tip = pole(G_tip_cont)
zeros_tip = zero(G_tip_cont)

% figure;
% bode(G_tip_cont);
% margin(G_tip_cont);
% grid;
% 
% figure;
% pzmap(G_tip_cont);

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

%% Control with Pole Placement in Continous Time

pp_poles = [-23 -25 -27 -29];                           %Definition of the new poles

[sys_controlled_pp, K_pp,K_p] = PolePlacement(sysest_ct_tip,pp_poles);

%% Pole placement with Integral action

pp_pole_en = [-23 -25 -27 -29 -31];                       %Definition of the new poles

[sys_controlled_pp_enla,K_pp_en_x,K_pp_en_eta] = PolePlacement_en(sysest_ct_tip,pp_pole_en);

%% LQR

omega_c = 20;                                   %Restiction on the speed of the controller

[K_lqr_x, K_lqr_eta] = LQRegulator(sysest_ct_tip, omega_c);

%% Observer implementation  

obs_poles = 10*pp_poles;

L_obs = StateObserver(sysest_ct_tip,obs_poles);

A_ob = sysest_ct_tip.A - L_obs*sysest_ct_tip.C;
B_ob = [ sysest_ct_tip.B - L_obs*sysest_ct_tip.D, L_obs];
C_ob = eye(4);
D_ob = zeros(4, 3);

Obs = ss(A_ob, B_ob, C_ob, D_ob);


%% Kalman Filter

L_KF = KalmanFilter(sysest_ct_tip);

%% Comparison Part

figure;
sigma(sysest_ct_tip, 'b-x', Obs, 'r-o');
legend;grid;

% figure
% pzmap(L_Controlled);
% 
% CL_Controlled = L_Controlled/(1+L_Controlled);
% 
% figure; hold on;
% step(CL);
% step(CL_Controlled);
% legend;
% hold off;
% grid;
% 
% L_poles = pole(CL_Controlled);
% L_zeros = zero(CL_Controlled);


