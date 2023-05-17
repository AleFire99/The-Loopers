close all
clear all
clc
%%% NOTE: run this code first and then the main from State estimators
%%% folder
addpath("./Implementations/")
addpath("./Arco's Longsim/Simulation_Signals")
addpath("./Extended_KF/")

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

%% Creation of Model with Uncertanties

sysest_ct_uncertanties = sysest_ct;

%Simulation flexible arm
m1 = 0.064;
m2 = 0.03;
L1 = 29.8/100;
L2 = 15.6/100;
d = 20/100; 

Kt = 0.00768;
Kg = 70; %high gear
Km = 0.00768;
nm = 0.69;
ng = 0.9;
Rm = 2.6;

Jeq = 0.002087; %High gear moment of inertia
JL = m1*L1*L1/3 + m2*L2*L2/12 + m2*d*d;
BL = 0; %invented but i am neglecting the damping in the link
Beq = 0.015;

f=3.846;
wn = 2*pi*f;
Ks = JL*wn*wn; %invented  

%% Estimated System

TaoCons = ng*nm*Kt*Kg/Rm;
sysest_ct.A = [0 1 0 0;
                            0 -(TaoCons*Km*Kg+Beq)/Jeq Ks/Jeq BL/Jeq;
                            0 0 0 1;
                            0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
 
sysest_ct.B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
sysest_ct.C = [1 0 0 0; 0 0 1 0];


%% Uncertian System

JL = 0.1* JL;

TaoCons = ng*nm*Kt*Kg/Rm;
sysest_ct_uncertanties.A = [0 1 0 0;
                            0 -(TaoCons*Km*Kg+Beq)/Jeq Ks/Jeq BL/Jeq;
                            0 0 0 1;
                            0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
 
sysest_ct_uncertanties.B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
sysest_ct_uncertanties.C = [1 0 0 0; 0 0 1 0];

% ng and nm are efficiency we may need to estimate
% Jeq for the base and its fixed
% Beq may be estimated
% Ks jesus measured
% Bl we dont know
% JL in future it can be a disturbance and it can be calculated


%% To create the long reference's signal for the simulation
%Longsim_Signal;                 %All possible references
 Longsim_Signal_Step_Ramp;       %Only ramp and step references
%Longsim_Signal_Sinewaves;       %Only sinewaves references

%% To get a comparison

% Estimated Model

sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0; 0 0 1 0],sysest_ct.D);
G_tip_ct = tf(sysest_ct_tip(1));

eigs_tip = pole(G_tip_ct);
zeros_tip = zero(G_tip_ct);

% Closed Loop System

T_CL = G_tip_ct/(1+G_tip_ct);

L_poles = pole(T_CL);
L_zeros = zero(T_CL);


% Uncertain Model

sysest_ct_tip_uncertanties = ss(sysest_ct_uncertanties.A,sysest_ct_uncertanties.B,[1 0 1 0; 0 0 1 0],sysest_ct_uncertanties.D);
G_tip_ct_uncertanties = tf(sysest_ct_tip_uncertanties(1));

eigs_tip_uncertanties = pole(G_tip_ct_uncertanties);
zeros_tip_uncertanties = zero(G_tip_ct_uncertanties);

T_CL_uncertanties = G_tip_ct_uncertanties/(1+G_tip_ct_uncertanties);

L_poles_uncertanties = pole(T_CL_uncertanties);
L_zeros_uncertanties = zero(T_CL_uncertanties);


figure;
bode(G_tip_ct,G_tip_ct_uncertanties,{10e-2,10e6});
legend('Estimated Open Loop', 'Uncertain Open Loop');
grid;

% figure;
% pzmap(G_tip_ct);

figure;
hold on;
step(T_CL);
step(T_CL_uncertanties);
legend('Estimated Closed Loop', 'Uncertain Closed Loop');
grid;
hold off;

figure;
bode(T_CL,T_CL_uncertanties,{10e-2,10e6});
legend('Estimated Closed Loop', 'Uncertain Closed Loop');
grid;

% 
%% State space control

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 15;


%% Arco's LQR

tau = 5;           % Maximum value related to the satuaration of the control variable limit

[K_lqr_x, K_lqr_eta] = Arco_LQRegulator(sysest_ct, tau);

%% Kalman Filter

Q_KF = eye(4)*10e-5;     %Arco
R_KF = eye(1)*10e-8;

%Q_KF = eye(4);     %Alp
%R_KF = eye(1)*10;

L_KF = KalmanFilter(sysest_ct, Q_KF, R_KF);

%% Comparison 

A_tilde = [ sysest_ct.A, zeros(4,1), zeros(4,4);
            -sysest_ct.C(1, :), 0, zeros(1,4);
            L_KF*sysest_ct.C,  -sysest_ct.B*K_lqr_eta, sysest_ct.A-sysest_ct.B*K_lqr_x-L_KF*sysest_ct.C];
        
B_tilde = [ sysest_ct.B;
            0;
            zeros(4,1)];
        
C_tilde = [ sysest_ct.C, zeros(2,5)];

D_tilde = zeros(2,1);


A_tilde_unc = [ sysest_ct_uncertanties.A, zeros(4,1), zeros(4,4);
            -sysest_ct_uncertanties.C(1, :), 0, zeros(1,4);
            L_KF*sysest_ct_uncertanties.C,  -sysest_ct_uncertanties.B*K_lqr_eta, sysest_ct_uncertanties.A-sysest_ct_uncertanties.B*K_lqr_x-L_KF*sysest_ct_uncertanties.C];
        
B_tilde_unc = [ sysest_ct_uncertanties.B;
            0;
            zeros(4,1)];
        
C_tilde_unc = [ sysest_ct_uncertanties.C, zeros(2,5)];

D_tilde_unc = zeros(2,1);
        
sys_controlled = ss(A_tilde, B_tilde, C_tilde,D_tilde);      

        
sys_controlled_unc = ss(A_tilde_unc, B_tilde_unc, C_tilde_unc,D_tilde_unc);      


figure;
bode(sysest_ct(1),sys_controlled(1), sys_controlled_unc(1),{10e-2,10e6});
legend('Uncontrolled Estimated Closed Loop','Estimated Closed Loop', 'Uncertain Closed Loop');
grid;

figure;
margin(sys_controlled(1));
figure;
margin(sys_controlled_unc(1));


figure;
bode(sysest_ct_tip, sysest_ct_tip_uncertanties,{1,1e3});
legend('Estimated', 'Uncertain');
grid;