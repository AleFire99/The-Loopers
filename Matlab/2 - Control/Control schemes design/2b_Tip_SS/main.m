close all
clear all
clc
%%% NOTE: run this code first and then the main from State estimators
%%% folder
addpath("./Implementations/")
addpath("./Simulation_Signals/")

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

% To create the long reference's signal for the simulation
% Longsim_Signal;                 %All possible references
%Longsim_Signal_Step_Ramp;       %Only ramp and step references
%Longsim_Signal_Sinewaves;       %Only sinewaves references


sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0; 0 0 1 0],sysest_ct.D);
G_tip_cont = tf(sysest_ct_tip(1));

eigs_tip = pole(G_tip_cont);
zeros_tip = zero(G_tip_cont);

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


%% State space control

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 15;

%% Observer

obs_poles = [-23 -25 -27 -29]*10;  

L_obs = place(sysest_ct_tip.A',sysest_ct_tip.C', obs_poles)'; 


%% Control with Pole Placement in Continous Time
%Definition of the new poles
                     
pp_poles = [-23 -25 -27 -29];                  %JC/Arco

[sys_controlled_pp, K_pp,K_p] = JC_PolePlacement(sysest_ct,pp_poles);

% Addition of the PI in the outer loop instead of just the proportional action

wc_req = 2;
s = tf('s');
PI_pp = wc_req * K_p * (s + 1) / s;

%% Pole placement with Integral action

pp_pole_en = [-23 -25 -27 -29 -31];                       %Definition of the new poles

[sys_controlled_pp_enla,K_pp_en_x,K_pp_en_eta] = Fire_PolePlacement_en(sysest_ct,pp_pole_en);

%% Fire's LQR

[K_lqr] = Fire_LQRegulator(sysest_ct);

%% Fire's LQR with integrator and FeedForward

tau = 5;    %Rate of convergence, real part of CL eigs smaller than tau

[K_lqrFF_x, K_lqrFF_eta] = Fire_LQRFF(sysest_ct, tau);

%% Arco's LQR

omega_c = 15;

[K_lqr_x, K_lqr_eta] = Arco_LQRegulator(sysest_ct_tip, omega_c);

%% LQGR

%[K_lqgr, L_lqgr] = Arco_LQGR(sysest_ct);




