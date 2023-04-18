%% Initial commands
clear all
close all
clc

%% Load of the Optimized Model

load('sysest09c_trick.mat');                                

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

load ("./Dataset/slowquare2.mat");
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

states_opt(:,1) = initial;
states_datasheet(:,1) = initial;

for i = 1:N_val-tstart
    
    states_opt(:,i+1) = sysest.A * states_opt(:,i) + sysest.B*Uvec_val(i);      %computation of the values for the optimised system
    states_datasheet(:,i+1) = sys_dt.A *states_datasheet(:,i) + sys_dt.B*Uvec_val(i);           %computation of the values for the datasheet's system

end

ylab = ["theta" ,"thetadot", "alfa", "alfadot"];
figure
title('real(continuous) and estimated(dotted)')
tvec = Time_vec_val(tstart:end);
for i=1:4
    
    subplot(4,1,i)
    plot(tvec,states_opt(i,:),":r",tvec,states_val(i,:),"k", tvec, states_datasheet(i,:),"b:");
    ylabel(ylab(i));
    xlabel("Time [s]");
    legend('Optimised curve','Validation Datas','Datasheet curve')

end

%% Fourier transformation for all states fs is frequencies, Px are the magnitudes normalized

[fs, Pxs_opt] = fft2data(states_opt,Uvec_val);
[fs, Pxs_datasheet] = fft2data(states_datasheet,Uvec_val);
[fs, Pxs_val] = fft2data(states_val,Uvec_val);

%% Plotting of the Results of The Evaluation

figure;
semilogx(fs,Pxs_opt(1,:),"r",fs,Pxs_datasheet(1,:),"b",fs,Pxs_val(1,:),"k");
%semilogx(fs,Pxs_phy(1,:));
%semilogx(fs,Pxs_val(1,:));

%% Results of the Frequency evaluation

evaluation_phy = compareffts(Pxs_val(:,1:3277), Pxs_datasheet(:,1:3277));
evaluation_est = compareffts(Pxs_val(:,1:3277), Pxs_opt(:,1:3277));

display(["compatison physics based error:"+ evaluation_phy + " and optimization based error " + evaluation_est])

%% Results of the Time evaluation

timerphy = comparetime(states_val,states_datasheet );
timerest = comparetime(states_val,states_opt );

display(["compatison physics based error:"+ timerphy + " and optimization based error " + timerest])




