% H infinity control (mu-control) for robustness

clear
close all
clc

%% Creation of the Estimated system in State Space

A_sysest_dt = [     1,      0.002,      0,          0;
                    0,      0.928,      1.162,      0.0017;
                    0,      0,          1,          0.002;
                    0,      0.0716,     -1.930,     0.9971];
                
B_sysest_dt = [     0;
                    0.10661;
                    0;
                    -0.1066];
                
C_sysest_dt = [     1,      0,          0,          0;
                    0,      0,          1,          0];
                
D_sysest_dt = [     0;
                    0];
                
Ts = 0.002;

sysest = ss(A_sysest_dt, B_sysest_dt, C_sysest_dt, D_sysest_dt, Ts);

%% Extraction of Matrices  in continuos time

sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

%% Modification of the C matrix to have the tip position

sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0; 0 0 1 0],sysest_ct.D);

G_tip_cont = tf(sysest_ct_tip(1));

%% Model Parameters coming from resonance measurements

v_a_max = 13;

%% System model
% Model parameters

[A,B,C,D] = ssdata(sysest_ct);

%% H infinity control

P = sysest_ct;

P.u = "u";
P.y = ["theta","alpha"];

sum_2 = sumblk("f = theta + alpha");
sum_1 = sumblk("e = r - f");

P_aug = connect(P, sum_1, sum_2, ["r","u"], ["e", "theta","alpha"]);

nmeas = 2;      %Number of y
ncont = 1;      %Number of u

[K_H_inf, CL_H_inf, gamma] = hinfsyn(P_aug,nmeas,ncont);

%% Mu synthesis

unc_1 = ureal("unc_1",sysest_ct(1,1).A(3,3),"percentage",7);      %defining uncertainties in parameters
%get(unc_1)

unc_2 = ureal("unc_2",sysest_ct(1,1).A(4,3),"percentage",7);
%get(unc_2)

unc_3 = ureal("unc_3",sysest_ct(1,1).A(4,4),"percentage",7);
%get(unc_3)

A_unc = umat(A);        %creating uncertain matrix
A_unc(3,3) = unc_1; 
A_unc(4,3) = unc_2;
A_unc(4,4) = unc_3;

sys_unc_ct = ss(A_unc,B,C,D);

P_unc = sys_unc_ct;
P_unc.u = "u";
P_unc.y = ["theta","alpha"];

sum_2 = sumblk("f = theta + alpha");
sum_1 = sumblk("e = r - f");

P_unc_aug = connect(P_unc, sum_1, sum_2, ["r","u"], ["e", "theta","alpha"]);

nmeas = 2;      %Number of y
ncont = 1;      %Number of u

opts = musynOptions("MixedMU", "on");
[K_mu, CL_mu] = musyn(P_unc_aug,nmeas,ncont,opts);
