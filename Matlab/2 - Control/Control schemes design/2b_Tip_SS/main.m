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

%% Control with Pole Placement in Continous Time
%Definition of the new poles
                     
pp_poles = [-23 -25 -27 -29];                  %JC/Arco

%[sys_controlled_pp, K_pp,K_p] = JC_PolePlacement(sysest_ct,pp_poles);

% Addition of the PI in the outer loop instead of just the proportional action
 
% wc_req = 2;
% s = tf('s');
% PI_pp = wc_req * K_p * (s + 1) / s;

%% Pole placement with Integral action

%pp_pole_en = [-23 -25 -27 -29 -31];                       %Definition of the new poles

%[sys_controlled_pp_enla,K_pp_en_x,K_pp_en_eta] = Fire_PolePlacement_en(sysest_ct,pp_pole_en);

%% Fire's LQR

%[K_lqr] = Fire_LQRegulator(sysest_ct);

%% Fire's LQR with integrator and FeedForward

%tau = 3;    %Rate of convergence, real part of CL eigs smaller than tau

%[K_lqrFF_x, K_lqrFF_eta] = Fire_LQRFF(sysest_ct_tip, tau);

%% Arco's LQR

tau = 20;

Q_lqr = diag([1 1 1 1 1]);     %initial values

[K_lqr_x, K_lqr_eta] = Arco_LQRegulator(sysest_ct_tip, tau, Q_lqr);

%% LQGR

%[K_lqgr, L_lqgr] = Arco_LQGR(sysest_ct);


%% Observer implementation  

obs_poles = 10*pp_poles;            %Arco
%obs_poles = 2*pp_poles;            %Jc

L_obs = StateObserver(sysest_ct,obs_poles);

%% Kalman Filter

Q_KF = eye(4)*10e-5;     %Alp
R_KF = eye(1)*10e-8;

%Q_KF = eye(4);     %Alp
%R_KF = eye(1)*10;

L_KF = KalmanFilter(sysest_ct, Q_KF, R_KF);

%% Comparison 

% Enlarged Estimated Systems

%System 1
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

%Plotting Part


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
 