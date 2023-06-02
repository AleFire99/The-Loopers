close all
clear all
clc

v_a_max = 13;

addpath("./Implementations/")

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

%% Control with Pole Placement in Continous Time
                     
pp_poles = [-23 -25 -27 -29];

[sys_controlled_pp, K_pp,K_p] = PolePlacement(sysest_ct,pp_poles);

%% LQR

tau = 20;

[K_lqr_x, K_lqr_eta] = LQRegulator(sysest_ct_tip, tau);

%% Observer implementation  

obs_poles = 10*pp_poles;

L_obs = place(sysest_ct_tip.A',sysest_ct_tip.C', obs_poles)';

%% Comparison 

% Enlarged Estimated System for the LQR control

A_ob = sysest_ct.A - L_obs*sysest_ct.C;

A_tilde = [ sysest_ct.A, -sysest_ct.B*K_lqr_eta , -sysest_ct.B*K_lqr_x;
            -[1 0 1 0], -[0]*K_lqr_eta , -[0]*K_lqr_x;
            L_obs*sysest_ct.C, -sysest_ct.B*K_lqr_eta, A_ob-sysest_ct.B*K_lqr_x];
B_tilde = [ zeros(4,1);
            eye(1,1);
            zeros(4,1)];       
C_tilde = [ sysest_ct_tip.C, zeros(2,1), zeros(2,4)];
D_tilde = zeros(2,1);

sys_controlled = ss(A_tilde, B_tilde, C_tilde,D_tilde); 

%% Plots

figure;
bode(sysest_ct_tip(1),sys_controlled(1),{10e-2,10e6});
legend('Uncontrolled Estimated Open Loop','Enlarged Estimated Closed Loop');
grid;

figure;
margin(sysest_ct_tip(1));

figure;
pzmap(sys_controlled(1),'g');
grid; legend('Enlarged Estimated Closed Loop');

figure;
hold on
nyqplot(sys_controlled(1),'g');
plot(-(1/v_a_max)*ones(10,1), linspace(-1,1,10))
hold off
grid; legend('Enlarged Estimated Closed Loop');

L_poles_sys_controlled = pole(sys_controlled(1))
L_zeros_sys_controlled = zero(sys_controlled(1))
 