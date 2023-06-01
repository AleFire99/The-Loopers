%% This code does following: 
% Frequency based controller Base and Tip, Pole placement for Tip, LQR for Tip
%1-load sinusoid tests on real system (requires .mat)
%2-calculate fourier transforms from sine tests
%3-load controllers and system model (requires .mat)
%4-plot bode for real system in Closed loop and design in closed loop
%5-plot step responses from real data and simulation
%6-save images to folder

%% Load of Datas
close all
clear all

close all
clear all
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

%% Load of the Sine Datasets to plot the bode diagrams 

% loads all tests in folders:
% [data_struct_base, N_data_struct_base] = load_mat("FBBase_Sine_tests");            
% [data_struct_tip, N_data_struct_tip]   = load_mat("FBTip_Sine_test");            %loads all tests in
% [data_struct_LO, N_data_struct_LO]     = load_mat("ppLO_sin_test");            %loads all tests in
% load("FB_Base_moddeddata.mat"); %data_modded, N_data_modded

% [data_struct_LQRarco, N_data_struct_LQRarco]     = load_mat("LQR_arco_sin_test");            %loads all tests in
% [data_struct_basefire N_data_struct_basefire ] = load_mat("FB_Fire_Sine_Tests_base");
% [data_struct_tipfire N_data_struct_tipfire ] = load_mat("FB_Fire_Sine_Tests_tip");

%controllers loadded
% controller_base = load("FB_controller_base_alp.mat").controller_base*load("FB_controller_base_alp.mat").kd_base;
% controller_base_fire = load("Fire_base_controller.mat").controller;
% controller_tip_fire = load("Fire_tip_FB_3.0.mat").controller;
% 
% load("FB_controller_tip.mat")
% load("syspp.mat")
% load("CL_LQRFire.mat") %%
CL_LQR = CL_Fire;

dt = sysest.Ts;
fs =1/dt;

%% Fourier Transform Computations for base
%[u_base,y1_base,ybase12,omegabase] = fourier(data_struct_base,N_data_struct_base,dt);
[u_base,y1_base,ybase12,omegabase] = fourier(data_modded,N_data_modded,dt); % usses modified data
[u_tip,y1_tip,y12_tip,omegatip]    = fourier(data_struct_tip,N_data_struct_tip,dt);
[u_tip_LO,y1_LO,y12_LO,omegaLO]    = fourier(data_struct_LO,N_data_struct_LO,dt);
[u_tip_LQRarco,y1_LQRarco,y12_LQRarco,omegaLqrarco]    = fourier(data_struct_LQRarco,N_data_struct_LQRarco,dt);
[u_base_firefb,y1_base_firefb,y2_base_firefb,omegafbfirebase]    = fourier(data_struct_basefire,N_data_struct_basefire,dt);
[u_tip_firefb,y1_tip_firefb,y2_tip_firefb,omegafbfiretip]    = fourier(data_struct_tipfire,N_data_struct_tipfire,dt);


%% converting to closed loop 
%PPLO conversion to summing two outputs
CL_PPLO = syspp;
CL_PPLO = ss(CL_PPLO);
CL_PPLO.C(2,1) = 1;
CL_PPLO.C(1,3) = 1;
CL_PPLO = (tf(CL_PPLO(1)));

%closed loop base
sys1 = d2c(tf(sysest));
CL_base = feedback(sys1(1)*controller_base,1, -1);

%closed loop tip
sys2 = sysest;
sys2.C(2,1) = 1;
sys2.C(1,3) = 1;
sys2 = d2c((tf(sys2(1))));
CL_tip = feedback(sys2*controller_tip*kd_tip,1, -1);

%closed loop fires
CL_base_fire = feedback(sys1(1)*controller_base_fire,1, -1);
CL_tip_fire = feedback(sys2*controller_tip_fire,1, -1); 


%% Plot of Results compared with the Bode Diagram of the Model
%simulation bode
[magb,phabase] = bode(CL_base,omegabase);
[magt,phatip] = bode(CL_tip,omegatip);
[maglo,phaLO] = bode(CL_PPLO,omegaLO);
[magLQR,phaLQR] = bode(CL_LQR,omegaLqrarco);
[magFBbase,phaFBbase] = bode(CL_base_fire,omegafbfirebase);
[magFBtip,phaFBtip] = bode(CL_tip_fire,omegafbfiretip);

%real data bode
G_1 = 20*log10(abs(y1_base ./u_base)*(2*pi/4096));
magbase = magb(1,:,:);           %extraction of the mag of base, first dynamic
magbase = squeeze (magbase);
magbase = 20*log10(magbase);

G_2 = 20*log10(abs(y12_tip ./u_tip));
magtip = magt(1,:,:);           %extraction of the mag of tip, second dynamic
magtip = squeeze (magtip);
magtip = 20*log10(magtip/dcgain(CL_tip));

G_3 =   20*log10(((abs(y12_LO))./u_tip_LO));
magLO = maglo(1,:,:);           %extraction of the mag of tip, second dynamic
magLO = squeeze (magLO);
magLO = 20*log10(magLO/dcgain(CL_PPLO));

G_4 =   20*log10(((abs(y12_LQRarco))./u_tip_LQRarco));
magLQR = magLQR(1,:,:);           %extraction of the mag of tip, second dynamic
magLQR = squeeze (magLQR);
magLQR = 20*log10(magLQR/dcgain(CL_LQR));

G_5 =   20*log10(((abs(y1_base_firefb))./u_base_firefb));
magFBbase = magFBbase(1,:,:);           %extraction of the mag of tip, second dynamic
magFBbase = squeeze (magFBbase);
magFBbase = 20*log10(magFBbase/dcgain(CL_base_fire));

G_6 =   20*log10(((abs(y2_tip_firefb))./u_tip_firefb));
magFBtip = magFBtip(1,:,:);           %extraction of the mag of tip, second dynamic
magFBtip = squeeze (magFBtip);
magFBtip = 20*log10(magFBtip/dcgain(CL_tip_fire));


%%

%plots 
figure(1);
semilogx(omegabase,magbase,"b",omegabase,G_1,"xk");grid;
title("Base FB controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain [dB]");
legend('Model', 'Data');

figure(2);
semilogx(omegatip,magtip,"b",omegatip,G_2,"xk");grid;
title("Tip FB controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain [dB]");
legend('Model', 'Data');

figure(3);
semilogx(omegaLO,magLO,"b",omegaLO,G_3,"xk");grid;
title("Tip PP controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain [dB]");
legend('Model', 'Data');

figure(4);
semilogx(omegaLqrarco,magLQR,"b",omegaLqrarco,G_4,"xk");grid;
title("Tip LQR controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain [dB]");
legend('Model', 'Data');

figure(5);
semilogx(omegafbfirebase,magFBbase,"b",omegafbfirebase,G_5,"xk");grid;
title("BASE FB Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain [dB]");
legend('Model', 'Data');

figure(6);
semilogx(omegafbfiretip,magFBtip,"b",omegafbfiretip,G_6,"xk");grid;
title("Tip FB controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain [dB]");
legend('Model', 'Data');

figure(7);
semilogx(omegatip,magtip',"b"); hold on; semilogx(omegatip,G_2,"xk");grid;
title("Base FB controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain [dB]");
legend('Model', 'Data');

saveas(figure(1), "Base FB controller Closed Loop.png")
saveas(figure(2), "Tip FB controller Closed Loop.png")
saveas(figure(3), "Tip PP controller Closed Loop.png")
%saveas(figure(4), "Tip LQR controller Closed Loop.png")
saveas(figure(5), "Base FB fire controller Closed Loop.png")
saveas(figure(6), "Tip FB fire controller Closed Loop.png")


%% steps:
figure(7)
load("FB_Fire_stepBase.mat")
delay = 500;
step(CL_base_fire*45, data(1,1:end-delay+1),"k")
hold on
plot(data(1,1:end-delay+1),data(3,delay:end),"b")
grid on 
legend(["Simulation", "Real"])

figure(8)
load("FB_Alp_tipStep.mat")
%load("FB_Fire_stepBase.mat")
delay = 500;
step(CL_tip*45, data(1,1:end-delay+1),"k")
%step(CL_tip_fire*45, data(1,1:end-delay+1),"k")
hold on
plot(data(1,1:end-delay+1),data(3,delay:end)+data(4,delay:end),"b")
grid on 
legend(["Simulation", "Real"])

saveas(figure(7), "Base FB fire Step.png")
saveas(figure(8), "Tip FB Step.png")



