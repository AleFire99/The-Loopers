%% Initial commands
clear all
close all
clc
%Simulation flexible arm
m1 = 0.064;
m2 = 0.03;
L1 = 29.8/100;
L2 = 15.6/100;
d = 21.5/100; %we have 3 d12 ??????

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

%% god
%TaoCons = ng*nm*Kt/Rm;
TaoCons = ng*nm*Kt*Kg/Rm;
 A = [0 1 0 0;
     0 (-TaoCons*Km*Kg-Beq)/Jeq Ks/Jeq BL/Jeq;
     0 0 0 1;
     0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
 B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
C =[1 0 0 0; 0 0 1 0];
%% 
% ng and nm are efficiency we may need to estimate
% Jeq for the base and its fixed
% Beq may be estimated
% Ks jesus measured
% Bl we dont know
% JL in future it can be a disturbance and it can be calculated

%% Load data
load data_train.mat
%data=data(:,500*8:1:500*10) ;
data = data(:,1:500*1);
Ts_002 = 0.002;
downsample_factor   =   10;
Ts                  =   Ts_002*downsample_factor;
Uvec                =   data(2,1:downsample_factor:end);
Time_vec            =   data(1,1:downsample_factor:end);
N                   =   length(Time_vec);                               % Total number of data points

%% Use noise-corrupted values
conv2angle = (2*pi)/4096;
theta           =  data(3,1:downsample_factor:end)*conv2angle;               % Measured sideslip angle
alfa            =  data(4,1:downsample_factor:end)*conv2angle;                % Measured yaw rate

%calculate these using forward difference method
thetadot = zeros(1,length(theta));
alfadot = zeros(1,length(theta));
thetadot(2:end) = 1*imgaussfilt([theta(2:end)- theta(1:end-1)],0.9); 
alfadot(2:end)  = 1*imgaussfilt([alfa(2:end)- alfa(1:end-1)],0.9);

%% Use noise-free values
% betavec_true        =   State.signals.values(1:end,4);                  % True sideslip angle
% rvec_true           =   State.signals.values(1:end,6);                  % True yaw rate
% betavec             =   interp1(State.time,betavec_true,Time_vec);      % True sideslip angle - resampled
% rvec                =   interp1(State.time,rvec_true,Time_vec);         % True sideslip angle - resampled


%% Define regressor and outputs matrix (PEM criterion)
nz             =   4;
nu              =   1;

PHI             =   zeros(nz*(N-1),(nz*nz+nu*nz));                        % Initialize regressors' matrix
Y               =   zeros(nz*(N-1),1);                                 % Initialize output vector
W               =   1;% Relative weight between r and beta
for ind = 1:N-1
    state = [theta(ind) thetadot(ind) alfa(ind) alfadot(ind)];
    
    PHI((ind-1)*nz+1:ind*nz,:)    =   [state,zeros(1, 12), Uvec(ind), 0, 0, 0;
                                       zeros(1, 4), state,zeros(1, 8), 0 Uvec(ind) 0 0;
                                       zeros(1, 8), state,zeros(1, 4), 0 0  Uvec(ind) 0;
                                       zeros(1, 12), state, 0 0 0 Uvec(ind)];
    Y((ind-1)*nz+1:ind*nz,1)      =   [theta(ind+1) thetadot(ind+1) alfa(ind+1) alfadot(ind+1)];
end

%% Compute and post-process constrained least squares estimate - cvx
% Beq may be estimated
% Ks jesus measured
% Bl we dont know
% nm
variation = 0.1;

tic
cvx_begin
variable theta_cvx(20,1)
minimize norm(Y-PHI*theta_cvx)
subject to
theta_cvx(1,1) == 0; theta_cvx(2,1) == 1; theta_cvx(3,1) == 0; theta_cvx(4,1) == 0;
theta_cvx(5,1) == 0;
theta_cvx(9,1) == 0; theta_cvx(10,1) == 0; theta_cvx(11,1) == 0; theta_cvx(12,1) == 1;

theta_cvx(6,1) == -theta_cvx(14,1); 
theta_cvx(7,1) == Ks/Jeq; 
theta_cvx(7,1) * Jeq == -theta_cvx(15,1)/((Jeq+JL)/(JL*Jeq)); % 
theta_cvx(8,1) * Jeq == -theta_cvx(16,1)/((Jeq+JL)/(JL*Jeq)); % 

theta_cvx(13,1) == 0;

%theta_cvx(0,1) == -Beq / Jeq;

theta_cvx(17,1) == 0;
theta_cvx(18,1) == -theta_cvx(20,1);
theta_cvx(18,1) >= 0.5;
theta_cvx(18,1) <=2;
theta_cvx(19,1) == 0;
%A_cvx(2,3)*Jeq
cvx_end
toc
% Retrieve model matrices in continuous time (Forward Finite Difference)
A_cvx           =   [theta_cvx(1,1) theta_cvx(2,1) theta_cvx(3,1) theta_cvx(4,1);
                    theta_cvx(5,1) theta_cvx(6,1) theta_cvx(7,1) theta_cvx(8,1);
                    theta_cvx(9,1) theta_cvx(10,1) theta_cvx(11,1) theta_cvx(12,1);
                    theta_cvx(13,1) theta_cvx(14,1) theta_cvx(15,1) theta_cvx(16,1)];
 
B_cvx           =   [theta_cvx(17,1) theta_cvx(18,1) theta_cvx(19,1) theta_cvx(20,1)]';
Atc_cvx         =   (A_cvx-eye(nz))/Ts;
Btc_cvx         =   B_cvx/Ts;

% Beq may be estimated
% Ks jesus measured
% Bl we dont know
% nm
%Retrieve physical parameters
%(-ng*nm*Kt/Rm*Km/Kt-Beq)/Jeq 
% Ks/Jeq
nm_est           =   -(A_cvx(2,2)*Jeq + Beq)/(ng*Kt*Km*Kg*Kg)*Rm;
Beq_est          =   A_cvx(2,2)*Jeq;
Ks_est           =   A_cvx(2,3)*Jeq;
Bl_est           =   A_cvx(2,4)*Jeq;

%Compare estimates
display("Compare estimates")
[nm nm_est]
%[Beq Beq_est]
%[Ks Ks_est]
[0 Bl_est]
%%
sys_est = ss(A_cvx,B_cvx, C ,[])

%% Plot results
figure(1),plot(Time_vec(2:end),Y(1:2:end)),grid on, hold on
plot(Time_vec(2:end),PHI(1:2:end,:)*theta_cvx)
