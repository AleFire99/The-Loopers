clc; clear all; close all;

sysest = load("sysest.mat").sysest;

%% continous
sysestc = d2c(sysest);
zeta = 0.8;
wn = 24.1651;
p_ol = pole(sysestc);
new_pole = [-wn*zeta ; -21; -23; -25];

A = sysestc.A;
B = sysestc.B;
C = sysestc.C;
D = sysestc.D;

k = place(A, B, new_pole);
syspp = ss(A-B*k,B,C,D);
p_cl = pole(syspp);
step(syspp)
Kdc = dcgain(syspp);
Kr = 1/Kdc;
L = place(A',C', 10*new_pole)';


%Integral action
A_en = [A, zeros(4,1);
       -C(1,:), 0];
B_en = [B; 0];
C_en = [C, zeros(2,1)];
D_en = [0;0];
sys_en = ss(A_en, B_en, C_en, D_en);

poles_en = [new_pole; 1.1*min(new_pole)];
K_en = place(A_en, B_en, poles_en);
K_x = K_en(1:4);
K_eta = K_en(5);
sys_pp_int = ss(A_en-B_en*K_en, B_en, C_en, D_en);

%% discrete
new_pole2 = [0.95 + 0.0i, 0.98 + 0.0i, 0.96 + 0.0i, 0.993 - 0.0i];
k2 = place(sysest.A, sysest.B, new_pole2);
syspp2 = ss(sysest.A-sysest.B*k2,sysest.B,sysest.C,sysest.D, 0.002);
p_cl2 = pole(syspp2);
step(syspp2)
Kdc2 = dcgain(syspp2);
Kr2 = 1/Kdc2;
L22 = place(sysest.A',sysest.C', new_pole2/0.99)';