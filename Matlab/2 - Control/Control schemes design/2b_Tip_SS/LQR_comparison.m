close all
clear all
clc
%%% NOTE: run this code first and then the main from State estimators
%%% folder
addpath("./Implementations/")
addpath("./Arco's Longsim/Simulation_Signals")

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

%% To create the long reference's signal for the simulation
%Longsim_Signal;                 %All possible references
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

v_a_max = 13;

%% Arco's LQR 1

tau_1 = 15;

Q_lqr_1 = diag([1 1 1 1 1]);     %initial values

[K_lqr_x_1, K_lqr_eta_1] = Arco_LQRegulator(sysest_ct_tip, tau_1, Q_lqr_1);
%% Arco's LQR 2

tau_2 = 17;

Q_lqr_2 = diag([1 1 1 1 1]);     %initial values

[K_lqr_x_2, K_lqr_eta_2] = Arco_LQRegulator(sysest_ct_tip, tau_2, Q_lqr_2);

%% Arco's LQR 3

tau_3 = 20;

Q_lqr_3 = diag([1 1 1 1 1]);     %initial values

[K_lqr_x_3, K_lqr_eta_3] = Arco_LQRegulator(sysest_ct_tip, tau_3, Q_lqr_3);

%% Arco's LQR 4

tau_4 = 25;

Q_lqr_4 = diag([1 1 1 1 1]);     %initial values

[K_lqr_x_4, K_lqr_eta_4] = Arco_LQRegulator(sysest_ct_tip, tau_4, Q_lqr_4);

%% Observer implementation  

pp_poles = [-23 -25 -27 -29];                  %JC/Arco

obs_poles = 10*pp_poles;            %Arco
%obs_poles = 2*pp_poles;            %Jc

L_obs = StateObserver(sysest_ct,obs_poles);

%% Kalman Filter

Q_KF = eye(4)*10e-5;     %Arco
R_KF = eye(1)*10e-8;

%Q_KF = eye(4);     %Alp
%R_KF = eye(1)*10;

L_KF = KalmanFilter(sysest_ct, Q_KF, R_KF);


%% Comparison 

% Enlarged Estimated Systems

%System 1
A_ob = sysest_ct.A - L_obs*sysest_ct.C;

A_tilde = [ sysest_ct.A, -sysest_ct.B*K_lqr_eta_1 , -sysest_ct.B*K_lqr_x_1;
            -[1 0 1 0], -[0]*K_lqr_eta_1 , -[0]*K_lqr_x_1;
            L_obs*sysest_ct.C, -sysest_ct.B*K_lqr_eta_1, A_ob-sysest_ct.B*K_lqr_x_1];
B_tilde = [ zeros(4,1);
            eye(1,1);
            zeros(4,1)];       
C_tilde = [ sysest_ct_tip.C, zeros(2,1), zeros(2,4)];
D_tilde = zeros(2,1);

sys_controlled_1 = ss(A_tilde, B_tilde, C_tilde,D_tilde); 

%System 2

A_ob = sysest_ct.A - L_obs*sysest_ct.C;

A_tilde = [ sysest_ct.A, -sysest_ct.B*K_lqr_eta_2 , -sysest_ct.B*K_lqr_x_2;
            -[1 0 1 0], -[0]*K_lqr_eta_2 , -[0]*K_lqr_x_2;
            L_obs*sysest_ct.C, -sysest_ct.B*K_lqr_eta_2, A_ob-sysest_ct.B*K_lqr_x_2];
B_tilde = [ zeros(4,1);
            eye(1,1);
            zeros(4,1)];       
C_tilde = [ sysest_ct_tip.C, zeros(2,1), zeros(2,4)];
D_tilde = zeros(2,1);

sys_controlled_2 = ss(A_tilde, B_tilde, C_tilde,D_tilde); 

%System 3

A_ob = sysest_ct.A - L_obs*sysest_ct.C;

A_tilde = [ sysest_ct.A, -sysest_ct.B*K_lqr_eta_3 , -sysest_ct.B*K_lqr_x_3;
            -[1 0 1 0], -[0]*K_lqr_eta_3 , -[0]*K_lqr_x_3;
            L_obs*sysest_ct.C, -sysest_ct.B*K_lqr_eta_3, A_ob-sysest_ct.B*K_lqr_x_3];
B_tilde = [ zeros(4,1);
            eye(1,1);
            zeros(4,1)];       
C_tilde = [ sysest_ct_tip.C, zeros(2,1), zeros(2,4)];
D_tilde = zeros(2,1);

sys_controlled_3 = ss(A_tilde, B_tilde, C_tilde,D_tilde); 


%Plotting Part


figure;
bode(sysest_ct_tip(1),sys_controlled_1(1),{10e-2,10e6});
legend('Uncontrolled Estimated Open Loop','Enlarged Estimated Closed Loop');
grid;

figure;
margin(sysest_ct_tip(1));

figure;
pzmap(sys_controlled_1(1),'g');
grid; legend('Enlarged Estimated Closed Loop');

figure;
hold on
nyqplot(sys_controlled_1(1),'g');
plot(-(1/v_a_max)*ones(10,1), linspace(-1,1,10))
hold off
grid; legend('Enlarged Estimated Closed Loop');

L_poles_sys_controlled = pole(sys_controlled_1(1))
L_zeros_sys_controlled = zero(sys_controlled_1(1))
 