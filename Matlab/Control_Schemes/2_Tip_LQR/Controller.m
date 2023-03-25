clear all    %Initialization
close all

sysest = load("sysest.mat").sysest;     %Loading system
sysestc = d2c(sysest);

TF = tf(sysestc);

poles = eig(sysestc);               %Find poles and zeros
zeros_1 = zero(TF(1));
zeros_2 = zero(TF(2));

s = tf("s");

DC_gain_1 = dcgain(s*TF);
DC_gain_2 = dcgain(TF);

%%
% PI Base Controller
%The actual set time differs due to DC gain in the system

C_desired = (s-poles(3))*(s-poles(4))/((s+24)*(s+25));      %Compensator scheme

%gain = dcgain(s*L(1));

t_set = 0.0065;         %if smaller weird complex numbers appears in C_PI
tau = t_set/5;
BW = 1/tau;

C_PI = C_desired*BW;

%PI scheme needs pre compensation!
%C_PI = BW*(s-poles(3))*(s-poles(4))/s;

% OL = minreal(C_PI*TF);
% OL_1 = OL(1);
% OL_2 = OL(2);
% CL_1 = OL_1/(1+OL_1);
% CL_2 = OL_2/(1+OL_2);

%num_C_PI = cell2mat(C_desired.num);


%TODO PID unstable! Non phase-minimum zeros!
% K_D = num_C_PI(1);
% K_P = num_C_PI(2);
% K_I = num_C_PI(3);
% 
% R = K_P + 1/s*K_I + s*K_D;


%%
% LQR

Q = diag([10 1 100 1]);
R = [1];
K_lqr = lqr(sysestc,Q,R);
