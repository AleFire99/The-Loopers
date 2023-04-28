close all
clear all
clc

%%
%Loading model
sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

G_sysest_cont = tf(sysest_ct);
G_theta_cont = G_sysest_cont(1);
G_alpha_cont = G_sysest_cont(1);
eigs = pole(G_sysest_cont(1));
theta_zeros = zero(G_theta_cont);

figure;
bode(G_theta_cont);
margin(G_theta_cont);
grid;

figure;
pzmap(G_theta_cont);

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 10;

s = tf('s');

%% Control with Pole Placement in Continous Time

new_pole = [-21 ; -22; -23; -25];          %Definition of the new poles

%Pole placement implementation

Kpp = place(sysest_ct.A, sysest_ct.B, new_pole);      
sys_pp = ss(sysest_ct.A - sysest_ct.B * Kpp,sysest_ct.B,sysest_ct.C,sysest_ct.D);
p_cl = pole(sys_pp);
Kdc = dcgain(sys_pp);
Kr = 1/Kdc(1);

figure;
sigma(G_sysest_cont, 'b-x', sys_pp, 'r-o');
legend;grid;

%Observer implementation  

L = place(sysest_ct.A',sysest_ct.C', 10*new_pole)'; 

%Pole placement with Integral action

A_en = [sysest_ct.A, zeros(4,1);
       -sysest_ct.C(1,:), 0];
B_en = [sysest_ct.B; 0];
C_en = [sysest_ct.C, zeros(2,1)];
D_en = [0;0];

sys_en = ss(A_en, B_en, C_en, D_en);

poles_en = [new_pole; 1.1*min(new_pole)];               %reduce new pole gain accordingly
K_en = place(A_en, B_en, poles_en);
K_x = K_en(1:4);
K_eta = K_en(5);
sys_pp_int = ss(A_en-B_en*K_en, B_en, C_en, D_en);

%% Control with Pole Placement in Discrete Time

% new_pole2 = [0.95 + 0.0i, 0.98 + 0.0i, 0.96 + 0.0i, 0.993 - 0.0i];
% k2 = place(sysest.A, sysest.B, new_pole2);
% syspp2 = ss(sysest.A-sysest.B*k2,sysest.B,sysest.C,sysest.D, 0.002);
% p_cl2 = pole(syspp2);
% step(syspp2)
% Kdc2 = dcgain(syspp2);
% Kr2 = 1/Kdc2;
% L22 = place(sysest.A',sysest.C', new_pole2/0.99)';