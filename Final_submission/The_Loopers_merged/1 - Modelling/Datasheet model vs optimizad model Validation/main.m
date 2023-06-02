%This code:
%1. load system model (requires .mat)
%2. create model from datasheet
%3. load data from real system (requires .mat)
%4. apply the real input to estimated model from optimization
%5. apply the real input to the model based on datasheet
%6. compare the moedls in frequency response and time response
%7. comparison is based on mean absolute error

%% Initial commands
clear all
close all
clc

addpath("./Implementations/")
addpath("./Simulation_Signals/")

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

sysest_main = sysest;
%% Creation of the Model using the Datasheet

m1 = 0.064;
m2 = 0.03;
L1 = 29.8/100;
L2 = 15.6/100;
d = 20/100; 

Kt = 0.00768;
Kg = 70; 
Km = 0.00768;
nm = 0.69;
ng = 0.9;
Rm = 2.6;

Jeq = 0.002087; 
JL = m1*L1*L1/3 + m2*L2*L2/12 + m2*d*d;
BL = 0; 
Beq = 0.015;

% JC frequency
f=3.846;
wn = 2*pi*f;
Ks = JL*wn*wn; %invented  


TaoCons = ng*nm*Kt*Kg/Rm;
A = [0 1 0 0;
     0 -(TaoCons*Km*Kg+Beq)/Jeq Ks/Jeq BL/Jeq;
     0 0 0 1;
     0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];
B = [0; TaoCons/Jeq; 0; -TaoCons/Jeq];
C = [1 0 0 0; 0 0 1 0];

sys_ct = ss(A,B,C,[]);
sys_dt = c2d(sys_ct,sysest.Ts);

%% Load data

% load ("./Dataset/data_newsetup_chirp.mat");  %Validation 
data_val = data;

downsample_factor   =   1;
Ts                  =   sysest.Ts*downsample_factor;
Uvec_val                =   data_val(2,1:downsample_factor:end);
Time_vec_val            =   data_val(1,1:downsample_factor:end);
N_val                   =   length(Time_vec_val);                               % Total number of data points

remove_settling = 0;
if remove_settling == 0
    tstart = 1;
elseif remove_settling == 1
    tstart = 5/Ts;
end

%% Computation of the Data's Time series

theta_val           =  -data_val(3,1:downsample_factor:end)*(2*pi)/4096;               % Measured sideslip angle
alfa_val            =  data_val(4,1:downsample_factor:end)*(2*pi)/4096;                % Measured yaw rate

thetadot_val = zeros(1,length(theta_val));
alfadot_val = zeros(1,length(theta_val));
thetadot_val(2:end) = 1*imgaussfilt([(theta_val(2:end)- theta_val(1:end-1))/Ts],0.99); 
alfadot_val(2:end)  = 1*imgaussfilt([(alfa_val(2:end)- alfa_val(1:end-1))/Ts],0.99);

states_val = [theta_val(tstart:end);thetadot_val(tstart:end);alfa_val(tstart:end); alfadot_val(tstart:end)];

%% Computation of the Tme series of Optimized model and datasheet's model

initial = [theta_val(tstart)  thetadot_val(tstart) alfa_val(tstart) alfadot_val(tstart)]';

states_opt_main(:,1) = initial;
states_opt_compared(:,1) = initial;
states_datasheet(:,1) = initial;

for i = 1:N_val-tstart
    
    states_opt_main(:,i+1) = sysest_main.A * states_opt_main(:,i) + sysest_main.B*Uvec_val(i);                      %computation of the values for the optimised system main
    states_datasheet(:,i+1) = sys_dt.A *states_datasheet(:,i) + sys_dt.B*Uvec_val(i);                               %computation of the values for the datasheet's system

end

ylab = ["theta" ,"thetadot", "alfa", "alfadot"];
figure
title('real(continuous) and estimated(dotted)')
tvec = Time_vec_val(tstart:end);

for i=1:4
    
    subplot(4,1,i)
    plot(tvec,states_opt_main(i,:),":r",tvec,states_val(i,:),"k", tvec, states_datasheet(i,:),"b:");
    ylabel(ylab(i));
    xlabel("Time [s]");
    legend('Main Optimised curve', 'Validation Datas','Datasheet curve')

end

%% Fourier transformation for all states fs is frequencies, Px are the magnitudes normalized
fs =1/Ts;
N = length(Uvec_val);         
NFFT = 2^nextpow2(N);
f_vect = fs/2*linspace(0,1,NFFT/2);

Pxs_opt_main        = fft2data(states_opt_main,Uvec_val);
Pxs_datasheet       = fft2data(states_datasheet,Uvec_val);
Pxs_val             = fft2data(states_val,Uvec_val);

% Troncation of the Spectral content

f_max = 20;
df = f_vect(2);

Pxs_opt_main        = Pxs_opt_main(:,1:floor(f_max/df));
Pxs_datasheet       = Pxs_datasheet(:,1:floor(f_max/df));
Pxs_val             = Pxs_val(:,1:floor(f_max/df));
f_vect              = f_vect(1:floor(f_max/df));


%% Plotting of the Results of The Evaluation

figure;
semilogx(f_vect,Pxs_opt_main(1,:),"r",f_vect,Pxs_datasheet(1,:),"b",f_vect,Pxs_val(1,:),"k");
title("Plot of the Base Frequency Responce");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Main Optimised curve', 'Validation Datas','Datasheet curve')

figure;
semilogx(f_vect,Pxs_opt_main(2,:),"r",f_vect,Pxs_datasheet(2,:),"b",f_vect,Pxs_val(2,:),"k");
title("Plot of the Tip Frequency Responce");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Main Optimised curve', 'Validation Datas','Datasheet curve')

%semilogx(fs,Pxs_phy(1,:));
%semilogx(fs,Pxs_val(1,:));

%% Results of the Frequency evaluation
evaluation_datasheet    = compareffts(Pxs_val, Pxs_datasheet);
evaluation_opt_main     = compareffts(Pxs_val, Pxs_opt_main);

%% Results of the Time evaluation
timer_datasheet         = comparetime(states_val,states_datasheet );
timer_opt_main          = comparetime(states_val,states_opt_main );

display(["comparison in frequency between datasheet and Real values: "+ evaluation_datasheet])
display(["comparison in time between datasheet and Real values: "+ timer_datasheet])
display(["comparison in frequency between Main Optimised and Real values: "+ evaluation_opt_main])
display(["comparison in time between Main Optimised and Real values: "+ timer_opt_main])

