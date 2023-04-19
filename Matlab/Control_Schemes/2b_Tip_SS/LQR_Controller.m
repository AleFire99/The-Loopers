%clear all    %Initialization
%close all

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
DC_C_des = dcgain(C_desired); 

t_set = 1.75;       %Good trade-off between speed and robustness
tau = t_set/5;
BW = 1/(tau*DC_C_des*DC_gain_1(1));

C_comp = C_desired*BW;

%PI not feasible, unstable poles, no phase margin!
%C_PI = BW*(s-poles(3))*(s-poles(4))/s;

L = C_comp*TF(1);
bode(L);


%%
% LQR

Q = diag([1000 1 100 1]);     %initial values
R = [1];
K_lqr = lqr(sysestc,Q,R);
