close all
clear all
clc

addpath("./Implementations/")
addpath("./Simulation_Signals/")
addpath("./Validation/")

sysest = load("sysest09c_trick.mat").sysest;
sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

% To create the long reference's signal for the simulation
Longsim_Signal;                 %All possible references
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


%% Control with a Compensator 

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

v_a_max = 15;

%% Control with Pole Placement in Continous Time
%Definition of the new poles

%pp_poles = [-23 -25 -27 -29];                  %Arco                         
pp_poles = [-23 -25 -27 -29];                  %JC   

[sys_controlled_pp, K_pp,K_p] = PolePlacement(sysest_ct_tip,pp_poles);

% Addition of the PI in the outer loop instead of just the proportional action

wc_req = 2;
s = tf('s');
PI_pp = wc_req * K_p * (s + 1) / s;

%% Pole placement with Integral action

pp_pole_en = [-23 -25 -27 -29 -31];                       %Definition of the new poles

[sys_controlled_pp_enla,K_pp_en_x,K_pp_en_eta] = PolePlacement_en(sysest_ct_tip,pp_pole_en);

%% LQR

omega_c = 20;                                   %Restiction on the speed of the controller

[K_lqr_x, K_lqr_eta] = LQRegulator(sysest_ct_tip, omega_c);

%% Observer implementation  

%obs_poles = 10*pp_poles;            %Arco
obs_poles = 2*pp_poles;            %Jc

L_obs = StateObserver(sysest_ct,obs_poles);

%% Kalman Filter

Q_KF = eye(4);     %Arco
R_KF = eye(1);

%Q_KF = eye(4);     %Alp
%R_KF = eye(1)*10;


L_KF = KalmanFilter(sysest_ct, Q_KF, R_KF);

%% Comparison Part

comparison_flag = 1;

if comparison_flag == 1
  
    figure;
    sigma(sysest_ct_tip, 'b-x', sys_controlled_pp, 'r-o');
    legend;grid on;
    
%     figure
%     pzmap(L_Controlled);
%     
%     CL_Controlled = L_Controlled/(1+L_Controlled);
%     
%     figure; hold on;
%     step(CL);
%     step(CL_Controlled);
%     legend;
%     hold off;
%     grid;
%     
%     L_poles = pole(CL_Controlled);
%     L_zeros = zero(CL_Controlled);

end


