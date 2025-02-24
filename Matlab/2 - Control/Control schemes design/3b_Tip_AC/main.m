% Constrained Numerical Optimization for Estimation and Control (based on lab F)
% Script to set up and simulate a linear-quadratic MPC strategy
% for the linear servo-mechanism example, with equality constraints and
% terminal equality constraint

clear all
close all
clc

%% System model
% Model parameters
load('sysest09c_trick.mat')   

syses_ct = d2c(sysest);
sysest_ct = d2c(sysest);
Vbar = 5;%max volts
v_a_max = Vbar;
%Ts  =   0.002;            % Sampling time                       
Ts  = 0.02;
% System matrices:
[A,B,C,D]       =   ssdata(c2d((d2c(sysest)*1),Ts));                  % Model matrices 

%% Signal dimensions
nz     =   size(A,1);
nu      =   size(B,2);
ny      =   size(C,1);

%% Prediction horizon and cost function weighting matrices
predhorizonseconds = 3;
N       =   predhorizonseconds/Ts;
Q       =   1e4;
R       =   1e2;

%% Inequality constraints
% Input inequalities
Au      =   [eye(nu);-eye(nu)];
bu      =   Vbar*ones(2*nu,1);
nqu     =   size(Au,1);                 % Number of input inequality constraints per stage

% State inequalities
%Az     =   [eye(4);-eye(4)];
%bz     =   100*[pi 10 pi/10 10]*ones(4,1);
%nqz    =   size(Az,1);
nqz = 0;
%% Reference output and initial state
z0     =   zeros(nz,1);
yref    =   [deg2rad(30);  0];

%% Build overall matrices and vectors for QP (note - quadprog solves: min 0.5*x'*H*x + f'*x   subject to:  A*x <= b, Aeq*x = beq)
[Lambda_y,Gamma_y,Lambda_z,Gamma_z]   =   Traj_matrices(N,A,B,C,D);
Qbar                                    =   zeros((N+1)*ny);
Rbar                                    =   zeros(N*nu);
Yref                                    =   zeros((N+1)*ny,1);
Aubar                                   =   zeros(N*nqu,N*nu);
bubar                                   =   zeros(N*nqu,1);
Azbar                                  =   zeros((N+1)*nqz,(N+1)*nz);
bzbar                                  =   zeros((N+1)*nqz,1);

for ind = 1:N+1
    Qbar((ind-1)*ny+1:ind*ny,(ind-1)*ny+1:ind*ny)           =   Q;
    Yref((ind-1)*ny+1:ind*ny,1)                             =   yref;
   % Azbar((ind-1)*nqz+1:ind*nqz,(ind-1)*nz+1:ind*nz)   =   Az;
%    bzbar((ind-1)*nqz+1:ind*nqz,1)                       =   bz;
end

for ind = 1:N
    Rbar((ind-1)*nu+1:ind*nu,(ind-1)*nu+1:ind*nu)           =   R;
    Aubar((ind-1)*nqu+1:ind*nqu,(ind-1)*nu+1:ind*nu)        =   Au;
    bubar((ind-1)*nqu+1:ind*nqu,1)                          =   bu;
end
%
Aineq   =   [Aubar;Azbar*Gamma_z];
bineq   =   [bubar;bzbar-Azbar*Lambda_z*z0];

% Terminal equality constraint
Aeq     =   Gamma_z(end-nz+1:end,:)-Gamma_z(end-2*nz+1:end-nz,:);
beq     =   -(Lambda_z(end-nz+1:end,:)-Lambda_z(end-2*nz+1:end-nz,:))*z0;

% Cost function
f       =   z0'*Lambda_y'*Qbar*Gamma_y-Yref'*Qbar*Gamma_y;
H       =   (Gamma_y'*Qbar*Gamma_y)+Rbar;
H       =   0.5*(H+H');

%% QP options
options =   optimset('display','none');

%% Simulate with MPC
seconds = 5;
Nsim                =   seconds/Ts;
Zsim_MPC            =   zeros((Nsim+1)*nz,1);
Ysim_MPC            =   zeros(Nsim*ny,1);
Usim_MPC            =   zeros(Nsim*nu,1);
Zsim_MPC(1:nz,1)    =   z0;
zt                  =   z0;
tQP                 =   zeros(Nsim-1,1);

uprev = 0;
unow = 0;
U = zeros(N,1);
T = zeros(4,4);
%T(3,3) = 1e3; 
for ind=2:Nsim+1
    bineq                               =   [bubar;bzbar-Azbar*Lambda_z*zt];
    beq                                 =   -(Lambda_z(end-nz+1:end,:)-Lambda_z(end-2*nz+1:end-nz,:))*zt;
    %f                                   =   zt'*Lambda_y'*Qbar*Gamma_y-Yref'*Qbar*Gamma_y;
    f                                   =   zt'*Lambda_y'*Qbar*Gamma_y-Yref'*Qbar*Gamma_y + zt'*T*zt;
    tic
    U                                   =   quadprog(H,f,Aineq,bineq,Aeq,beq,[],[],[],options);
    tQP(ind-1,1)                        =   toc;
    Usim_MPC((ind-2)*nu+1:(ind-1)*nu,1) =   U(1:nu,1);
    uprev = unow;
    unow =  U(1:nu,1);
    
    Zsim_MPC((ind-1)*nz+1:ind*nz,1)     =   A*Zsim_MPC((ind-2)*nz+1:(ind-1)*nz,1)+B*Usim_MPC((ind-2)*nu+1:(ind-1)*nu,1);
    Ysim_MPC((ind-2)*ny+1:(ind-1)*ny,1) =   C*Zsim_MPC((ind-2)*nz+1:(ind-1)*nz,1)+D*Usim_MPC((ind-2)*nu+1:(ind-1)*nu,1);
    zt                                  =   Zsim_MPC((ind-1)*nz+1:ind*nz,1);
end

theta = Ysim_MPC(1:2:end);
alfa= Ysim_MPC(2:2:end);
tpause = Ts;
simulateArm(theta,alfa,Ts,tpause)  
%%
time = 0:Ts:Nsim*Ts-Ts
plot(time,Usim_MPC)
xlabel("time[s]")
ylabel("Voltage(V)")