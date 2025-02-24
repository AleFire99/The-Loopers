%% Initial commands
clear all
close all
clc
%Simulation flexible arm
m1 = 0.064;
m2 = 0.03;
L1 = 29.8/100;
L2 = 15.6/100;
d = 20/100; %we have 3 d12 ??????

Kt = 0.00768;
Kg = 70; %high gear
Km = 0.00768;
nm = 0.69;
ng = 0.9;
Rm = 2.6;

Jeq = 0.002087; %High gear moment of inertia
JL = m1*L1*L1/3 + m2*L2*L2/12 + m2*d*d;
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
     0 -(TaoCons*Km*Kg+Beq)/Jeq Ks/Jeq BL/Jeq;
     0 0 0 1;
     0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
 B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
C =[1 0 0 0; 0 0 1 0];

sys_c = ss(A,B,C,[]);
sys_c = c2d(sys_c,0.002);
Adt = sys_c.A;
Bdt = sys_c.B;
Cdt = sys_c.C;
%Adt= expm(A*0.002);
%% 
% ng and nm are efficiency we may need to estimate
% Jeq for the base and its fixed
% Beq may be estimated
% Ks jesus measured
% Bl we dont know
% JL in future it can be a disturbance and it can be calculated

%% Load data collected from the system in open loop to provide the parameters of the matrix from the optimization
%load ./Dataset/data_newsetup_chirp.mat
%d1 = data;
%load ./Dataset/slowquare2.mat
%d2 = data;
data_val = data;
%data = [d1 d2];
%data(:,floor(length(data)/10):floor(length(data)/10)+100)];
%data=data(:,500*8:end) ;
%data = data(:,1:500*0.5);
Ts_002 = 0.002;
downsample_factor   =   1;
Ts                  =   Ts_002*downsample_factor;
Uvec                =   data(2,1:downsample_factor:end);
Time_vec            =   data(1,1:downsample_factor:end);
N                   =   length(Time_vec);                               % Total number of data points

%% Use noise-corrupted values
conv2angle = (2*pi)/4096;
theta           =  -data(3,1:downsample_factor:end)*conv2angle;               % Measured sideslip angle
alfa            =  data(4,1:downsample_factor:end)*conv2angle;                % Measured yaw rate

%calculate these using forward difference method
thetadot = zeros(1,length(theta));
alfadot = zeros(1,length(theta));
thetadot(2:end) = 1*imgaussfilt([theta(2:end)- theta(1:end-1)]/Ts,0.99); 
alfadot(2:end)  = 1*imgaussfilt([alfa(2:end)- alfa(1:end-1)]/Ts,0.99);

%% Use noise-free values
% betavec_true        =   State.signals.values(1:end,4);                  % True sideslip angle
% rvec_true           =   State.signals.values(1:end,6);                  % True yaw rate
% betavec             =   interp1(State.time,betavec_true,Time_vec);      % True sideslip angle - resampled
% rvec                =   interp1(State.time,rvec_true,Time_vec);         % True sideslip angle - resampled


%% Define regressor and outputs matrix (PEM criterion)
nz             =   4;
nu              =   1;

PHI             =   zeros(nz*(N-1),(nz*nz+nu*nz));                          % Initialize regressors' matrix
Y               =   zeros(nz*(N-1),1);                                      % Initialize output vector
W               =   ones(nz*(N-1),1);                                       % Relative weight between r and beta

%W(length(W)*0.75:end) = 1 * ones(length(W)-(length(W)*0.75)+1,1);           % addition of weights 

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
minimize norm((Y-PHI*theta_cvx).*W)
subject to
theta_cvx(1,1) == 1;
theta_cvx(2,1) == Ts; 
theta_cvx(3,1) == 0; 
theta_cvx(4,1) == 0;
theta_cvx(5,1) == 0;
theta_cvx(8,1) ==  0.0017;
theta_cvx(9,1) == 0; 
theta_cvx(10,1) == 0;
theta_cvx(11,1) == 1; 
theta_cvx(12,1) ==  Ts;
theta_cvx(13,1) == 0;

theta_cvx(8,1) * Jeq == -(theta_cvx(16,1)-1)/((Jeq+JL)/(JL*Jeq)); % 
theta_cvx(6,1) + theta_cvx(14,1) == 1;
theta_cvx(7,1) * Jeq == -theta_cvx(15,1)/((Jeq+JL)/(JL*Jeq)); % 
%theta_cvx(8,1) + theta_cvx(16,1) == 1;

theta_cvx(18,1)*Km*Kg+Beq*Rm/(Jeq*Rm)*Ts == (theta_cvx(14,1));
theta_cvx(18,1) == -theta_cvx(20,1);
theta_cvx(17,1) == 0;
theta_cvx(19,1) == 0;

% theta_cvx(7,1) >= 0.8*Ts*Ks/Jeq;
% theta_cvx(7,1) <= 1.2*Ts*Ks/Jeq;


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

dtsys = ss(A_cvx,B_cvx,C,[], 0.002);
sysestc = d2c(dtsys);
% Beq may be estimated
% Ks jesus measured
% Bl we dont know
% nm
%Retrieve physical parameters
%(-ng*nm*Kt/Rm*Km/Kt-Beq)/Jeq 
% Ks/Jeq
nm_est           =   (-sysestc.A(2,2)*Jeq - Beq)/(ng*Kt*Km*Kg*Kg)*Rm;
%Beq_est          =   A_cvx(2,2)*Jeq;
Ks_est           =   sysestc.A(2,3)*Jeq;
Bl_est           =   sysestc.A(2,4)*Jeq;

%Compare estimates
display("Compare estimates")
display("A Adt Acvx Adtcvx")
[A(2,2) Adt(2,2) sysestc.A(2,2) A_cvx(2,2)]

[B(2) Bdt(2) sysestc.B(2) B_cvx(2)]


%[nm nm_est]
%[Beq Beq_est]
%[Ks Ks_est]
%[0 Bl_est]
%%
%sys_est = ss(A_cvx,B_cvx, C ,[])

%% Plot results

%figure(1),plot(Time_vec(2:end),Y(1:2:end)),grid on, hold on
%plot(Time_vec(2:end),PHI(1:2:end,:)*theta_cvx)

%% validation 

%data = data(:,500*4:end);

Uvec_val                =   data_val(2,1:downsample_factor:end);
Time_vec_val            =   data_val(1,1:downsample_factor:end);
N_val                   =   length(Time_vec_val);                               % Total number of data points

remove_settling = 0;
if remove_settling == 0
    tstart = 1;
elseif remove_settling == 1
    tstart = 5/Ts_002;
end

%% Use noise-corrupted values

theta_val           =  -data_val(3,1:downsample_factor:end)*conv2angle;               % Measured sideslip angle
alfa_val            =  data_val(4,1:downsample_factor:end)*conv2angle;                % Measured yaw rate

%calculate these using forward difference method

thetadot_val = zeros(1,length(theta_val));
alfadot_val = zeros(1,length(theta_val));
thetadot_val(2:end) = 1*imgaussfilt([(theta_val(2:end)- theta_val(1:end-1))/Ts],0.99); 
alfadot_val(2:end)  = 1*imgaussfilt([(alfa_val(2:end)- alfa_val(1:end-1))/Ts],0.99);

initial = [theta_val(tstart)  thetadot_val(tstart) alfa_val(tstart) alfadot_val(tstart)]';
statess_est(:,1) = initial;
statess_phy(:,1) = initial;
for i = 1:N_val-tstart

statess_est(:,i+1) = A_cvx * statess_est(:,i) + B_cvx*Uvec_val(i);
%statess_est1(:,i+1) = A_cvx * statess_est1(:,i) + Ts*B_cvx*Uvec_val(i);

statess_phy(:,i+1) = Adt *statess_phy(:,i) + Bdt*Uvec_val(i);
end
states_val = [theta_val(tstart:end);thetadot_val(tstart:end);alfa_val(tstart:end); alfadot_val(tstart:end)];

%statess_est([2 4],:) = statess_est1([2 4],:);

size(statess_est)
size(states_val)

ylab = ["theta" ,"thetadot", "alfa", "alfadot"];
figure
title('real(continuous) and estimated(dotted)')
tvec = Time_vec_val(tstart:end);
for i=1:4
subplot(2,2,i)
plot(tvec,statess_est(i,:),":r",tvec,states_val(i,:),"k", tvec, statess_phy(i,:),"b:");

title(ylab(i));

end
sysest = ss(A_cvx, B_cvx,C, [], Ts);
%save("sysest.mat","sysest")


%% Non linear System Generation 

%flag to get the non linear model:      0 - skip the extraction
%                                       1 - extraction as "sysest_nonlin.mat"

non_lin_flag = 0;                

if non_lin_flag == 1                         
    states_nonlinear = initial;
    A23 = A_cvx(2,3);
    A43 = A_cvx(4,3);
    Tmodel1 = 0;
    Tmodel2 = 0;
    for i = 1:N_val-tstart
    alfa = states_nonlinear(3,i);
       % if abs(alfa)  0.1
            Tmodel1 = Ts*springcomp(alfa)/Jeq;
            Tmodel2 = -Ts*springcomp(alfa)*((Jeq+JL)/(JL*Jeq));
            A_cvx(2,3) = 0;
            A_cvx(4,3) = 0;
        %else
         %   A_cvx(4,3) = A23;
          %          A_cvx(4,3) = A43;

           % Tmodel =0;
            %Tmodel2 = 0;

    %    end
    states_nonlinear(:,i+1) = A_cvx * states_nonlinear(:,i) + B_cvx*Uvec_val(i) + [0 Tmodel1 0 Tmodel2 ]';
    %statess_est1(:,i+1) = A_cvx * statess_est1(:,i) + Ts*B_cvx*Uvec_val(i);
    end

    figure

    for i=1:4
    subplot(2,2,i)
    plot(tvec,statess_est(i,:),":r",tvec,states_val(i,:),"k", tvec, statess_phy(i,:),"b:", tvec, states_nonlinear(i,:),":x");
    title(ylab(i));

    end
    
    sysest = ss(A_cvx,B_cvx,C,[],0.002);
    %save("sysest_nonlin.mat","sysest")
    
end
