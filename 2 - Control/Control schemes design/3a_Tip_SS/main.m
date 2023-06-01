close all
clear all
clc

addpath("./Implementations/")
addpath("./Simulation_Signals")

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

%% Creation of Model with Uncertanties

sysest_ct_uncertanties_JLL = sysest_ct;
sysest_ct_uncertanties_JLH = sysest_ct;

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

% Overwrite of the sys matrix for tests

% TaoCons = ng*nm*Kt*Kg/Rm;
% sysest_ct.A = [0 1 0 0;
%                             0 -(TaoCons*Km*Kg+Beq)/Jeq Ks/Jeq BL/Jeq;
%                             0 0 0 1;
%                             0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
%  
% sysest_ct.B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
% sysest_ct.C = [1 0 0 0; 0 0 1 0];


%% Uncertian System Smaller JL (faster system with higer resonance)

alpha1 = 0.5;

JL = alpha1* JL;

TaoCons = ng*nm*Kt*Kg/Rm;
sysest_ct_uncertanties_JLL.A = [0 1 0 0;
                            0 -(TaoCons*Km*Kg+Beq)/Jeq Ks/Jeq BL/Jeq;
                            0 0 0 1;
                            0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
 
sysest_ct_uncertanties_JLL.B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
sysest_ct_uncertanties_JLL.C = [1 0 0 0; 0 0 1 0];

JL =  JL/alpha1;  % Back to original Value

%% Uncertian System Smaller JL (slower system system with lower resonance)

alpha2 = 2;

JL = alpha2* JL;

TaoCons = ng*nm*Kt*Kg/Rm;
sysest_ct_uncertanties_JLH.A = [0 1 0 0;
                            0 -(TaoCons*Km*Kg+Beq)/Jeq Ks/Jeq BL/Jeq;
                            0 0 0 1;
                            0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
 
sysest_ct_uncertanties_JLH.B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
sysest_ct_uncertanties_JLH.C = [1 0 0 0; 0 0 1 0];


JL = JL/ alpha2;  % Back to original Value

%% To create the long reference's signal for the simulation
%Longsim_Signal;                 %All possible references
%Longsim_Signal_Step_Ramp;       %Only ramp and step references
%Longsim_Signal_Sinewaves;       %Only sinewaves references

%% To get a comparison

% Estimated Model

sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0; 0 0 1 0],sysest_ct.D);
G_tip_ct = tf(sysest_ct_tip(1));

eigs_tip = pole(G_tip_ct);
zeros_tip = zero(G_tip_ct);

% Closed Loop System

T_CL = G_tip_ct/(1+G_tip_ct);

L_poles = pole(T_CL)
L_zeros = zero(T_CL)


% Faster Uncertain Model

sysest_ct_tip_uncertanties_JLL = ss(sysest_ct_uncertanties_JLL.A,sysest_ct_uncertanties_JLL.B,[1 0 1 0; 0 0 1 0],sysest_ct_uncertanties_JLL.D);
G_tip_ct_uncertanties_JLL = tf(sysest_ct_tip_uncertanties_JLL(1));

eigs_tip_uncertanties_JLL = pole(G_tip_ct_uncertanties_JLL);
zeros_tip_uncertanties_JLL = zero(G_tip_ct_uncertanties_JLL);

T_CL_uncertanties_JLL = G_tip_ct_uncertanties_JLL/(1+G_tip_ct_uncertanties_JLL);

L_poles_uncertanties_JLL = pole(T_CL_uncertanties_JLL)
L_zeros_uncertanties_JLL = zero(T_CL_uncertanties_JLL)

% Slower Uncertain Model

sysest_ct_tip_uncertanties_JLH = ss(sysest_ct_uncertanties_JLH.A,sysest_ct_uncertanties_JLH.B,[1 0 1 0; 0 0 1 0],sysest_ct_uncertanties_JLH.D);
G_tip_ct_uncertanties_JLH = tf(sysest_ct_tip_uncertanties_JLH(1));

eigs_tip_uncertanties_JLH = pole(G_tip_ct_uncertanties_JLH);
zeros_tip_uncertanties_JLH = zero(G_tip_ct_uncertanties_JLH);

T_CL_uncertanties_JLH = G_tip_ct_uncertanties_JLH/(1+G_tip_ct_uncertanties_JLH);

L_poles_uncertanties_JLH = pole(T_CL_uncertanties_JLH)
L_zeros_uncertanties_JLH = zero(T_CL_uncertanties_JLH)
 
%% Arco's LQR

tau = 10;                       % Value to have a lighter control action

Q_lqr = diag([1 1 1 1 1]);     %initial values

[K_lqr_x, K_lqr_eta] = Arco_LQRegulator(sysest_ct_tip, tau, Q_lqr);

%% Observer implementation  

pp_poles = [-23 -25 -27 -29];                  %JC/Arco

obs_poles = 10*pp_poles;            %Arco
%obs_poles = 2*pp_poles;            %Jc

L_obs = StateObserver(sysest_ct,obs_poles);

%% Kalman Filter

Q_KF = eye(4)*10e-5;     %Arco
R_KF = eye(1)*10e-8;

L_KF = KalmanFilter(sysest_ct, Q_KF, R_KF);

%% Comparison 

% System Comparisons

figure;
bode(G_tip_ct,G_tip_ct_uncertanties_JLL,G_tip_ct_uncertanties_JLH,{10e-2,10e6});
legend('Estimated Open Loop', 'Uncertain Open Loop JL = 0.1*JL', 'Uncertain Open Loop JL = 10*JL');
grid;


figure;
hold on;
step(T_CL);
step(T_CL_uncertanties_JLL);
step(T_CL_uncertanties_JLH);
legend('Estimated Closed Loop', 'Uncertain Closed Loop JL = 0.1*JL', 'Uncertain Closed Loop JL = 10*JL');
grid;
hold off;

figure;
bode(T_CL,T_CL_uncertanties_JLL,T_CL_uncertanties_JLH,{10e-2,10e6});
legend('Estimated Closed Loop', 'Uncertain Closed Loop JL = 0.1*JL', 'Uncertain Closed Loop JL = 10*JL');
grid;


% Enlarged Estimated System

A_tilde = [ sysest_ct.A, -sysest_ct.B*K_lqr_eta , sysest_ct.B*K_lqr_x;
            -[1 0 1 0], -[0]*K_lqr_eta , [0]*K_lqr_x;
            L_KF*sysest_ct.C, -sysest_ct.B*K_lqr_eta, sysest_ct.A-sysest_ct.B*K_lqr_x];
B_tilde = [ zeros(4,1);
            eye(1,1);
            zeros(4,1)];       
C_tilde = [ sysest_ct.C, zeros(2,1), zeros(2,4)];
D_tilde = zeros(2,1);

sys_controlled = ss(A_tilde, B_tilde, C_tilde,D_tilde); 

% Enlarged Uncertain System Faster

A_tilde_unc_JLL = [ sysest_ct_uncertanties_JLL.A, -sysest_ct_uncertanties_JLL.B*K_lqr_eta , sysest_ct_uncertanties_JLL.B*K_lqr_x;
            -[1 0 1 0], -[0]*K_lqr_eta , [0]*K_lqr_x;
            L_KF*sysest_ct_uncertanties_JLL.C, -sysest_ct_uncertanties_JLL.B*K_lqr_eta, sysest_ct_uncertanties_JLL.A-sysest_ct_uncertanties_JLL.B*K_lqr_x];
B_tilde_unc_JLL = [ zeros(4,1);
            eye(1,1);
            zeros(4,1)];       
C_tilde_unc_JLL = [ sysest_ct_uncertanties_JLL.C, zeros(2,1), zeros(2,4)];
D_tilde_unc_JLL = zeros(2,1);

sys_controlled_unc_JLL = ss(A_tilde_unc_JLL, B_tilde_unc_JLL, C_tilde_unc_JLL,D_tilde_unc_JLL);

% Enlarged Uncertain System Slower

A_tilde_unc_JLH = [ sysest_ct_uncertanties_JLH.A, -sysest_ct_uncertanties_JLH.B*K_lqr_eta , sysest_ct_uncertanties_JLH.B*K_lqr_x;
            -[1 0 1 0], -[0]*K_lqr_eta , [0]*K_lqr_x;
            L_KF*sysest_ct_uncertanties_JLH.C, -sysest_ct_uncertanties_JLH.B*K_lqr_eta, sysest_ct_uncertanties_JLH.A-sysest_ct_uncertanties_JLH.B*K_lqr_x];
B_tilde_unc_JLH = [ zeros(4,1);
            eye(1,1);
            zeros(4,1)];       
C_tilde_unc_JLH = [ sysest_ct_uncertanties_JLH.C, zeros(2,1), zeros(2,4)];
D_tilde_unc_JLH = zeros(2,1);

sys_controlled_unc_JLH = ss(A_tilde_unc_JLH, B_tilde_unc_JLH, C_tilde_unc_JLH,D_tilde_unc_JLH);      

% Plotting Part

figure;
bode(sysest_ct_tip(1),sys_controlled(1), sys_controlled_unc_JLL(1), sys_controlled_unc_JLH(1),{10e-2,10e6});
legend('Uncontrolled Estimated Closed Loop','Enlarged Estimated Closed Loop', 'Enlarged Uncertain Closed Loop JL = 0.1*JL', 'Enlarged Uncertain Closed Loop JL = 10*JL');
grid;

figure;
margin(sys_controlled(1));
figure;
margin(sys_controlled_unc_JLL(1));
figure;
margin(sys_controlled_unc_JLH(1));

figure;
pzmap(sys_controlled(1),'g',sys_controlled_unc_JLL(1),'r',sys_controlled_unc_JLH(1),'b');
grid; legend('Enlarged Estimated Closed Loop', 'Enlarged Uncertain Closed Loop JL = 0.1*JL', 'Enlarged Uncertain Closed Loop JL = 10*JL');

figure;
nyqplot(sys_controlled(1),'g',sys_controlled_unc_JLL(1),'r',sys_controlled_unc_JLH(1),'b');
grid; legend('Enlarged Estimated Closed Loop', 'Enlarged Uncertain Closed Loop JL = 0.1*JL', 'Enlarged Uncertain Closed Loop JL = 10*JL');


L_poles_sys_controlled = pole(sys_controlled(1))
L_zeros_sys_controlled = zero(sys_controlled(1))
 
L_poles_sys_controlled_unc_JLL = pole(sys_controlled_unc_JLL(1))
L_zeros_sys_controlled_unc_JLL = zero(sys_controlled_unc_JLL(1))
 
L_poles_sys_controlled_unc_JLH = pole(sys_controlled_unc_JLH(1))
L_zeros_sys_controlled_unc_JLH = zero(sys_controlled_unc_JLH(1))
 


