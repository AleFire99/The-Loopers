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

%% Control with Pole Placement in Continous Time

new_pole = [-wn*zeta ; -21; -23; -25];          %Definition of the new poles

%Pole placement implementation

k = place(A, B, new_pole);      
syspp = ss(A-B*k,B,C,D);
p_cl = pole(syspp);
Kdc = dcgain(syspp);
Kr = 1/Kdc(1);

%Observer implementation  

L = place(sysestc.A',sysestc.C', 10*new_pole)'; 

%Pole placement with Integral action

A_en = [A, zeros(4,1);
       -C(1,:), 0];
B_en = [B; 0];
C_en = [C, zeros(2,1)];
D_en = [0;0];

sys_en = ss(A_en, B_en, C_en, D_en);

poles_en = [new_pole; 1.1*min(new_pole)];               %reduce new pole gain accordingly
K_en = place(A_en, B_en, poles_en);
K_x = K_en(1:4);
K_eta = K_en(5);
sys_pp_int = ss(A_en-B_en*K_en, B_en, C_en, D_en);

%% Control with Pole Placement in Discrete Time
new_pole2 = [0.95 + 0.0i, 0.98 + 0.0i, 0.96 + 0.0i, 0.993 - 0.0i];
k2 = place(sysest.A, sysest.B, new_pole2);
syspp2 = ss(sysest.A-sysest.B*k2,sysest.B,sysest.C,sysest.D, 0.002);
p_cl2 = pole(syspp2);
step(syspp2)
Kdc2 = dcgain(syspp2);
Kr2 = 1/Kdc2;
L22 = place(sysest.A',sysest.C', new_pole2/0.99)';