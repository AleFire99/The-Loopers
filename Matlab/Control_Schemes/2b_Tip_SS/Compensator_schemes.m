close all
clear all
clc

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

addpath("./Implementations/")
sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0;0 0 1 0],sysest_ct.D);
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

new_pole = [-23; -25; -27; -29];                           %Definition of the new poles

[sys_controlled_pp, K_pp,K_p] = PolePlacement(sysest_ct_tip,new_pole);

%% Observer implementation  

L = place(sysest_ct_tip.A',sysest_ct_tip.C', 10*new_pole)'; 

%% Pole placement with Integral action

%poles_en = [new_pole; 2*new_pole(end-1:end)];               %reduce new pole gain accordingly

%[sys_controlled_pp_enla,K_pp_en_x,K_pp_en_eta] = PolePlacement_en(sysest_ct_tip,poles_en);

%% LQR

K_lqr = LQRegulator(sysest_ct_tip);

%% Comparison Part

figure;
sigma(sysest_ct_tip, 'b-x', sys_controlled_pp, 'r-o');
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


