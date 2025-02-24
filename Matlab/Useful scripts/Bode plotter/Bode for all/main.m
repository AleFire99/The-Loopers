%% Load of Datas
close all
clear all

load("sysest09c_trick.mat")                                %loads the linear system

%[data_struct_base, N_data_struct_base] = load_mat("FBBase_Sine_tests");            %loads all tests in
[data_struct_tip, N_data_struct_tip]   = load_mat("FBTip_Sine_test");            %loads all tests in
[data_struct_LO, N_data_struct_LO]     = load_mat("ppLO_sin_test");            %loads all tests in
load("FB_Base_moddeddata.mat"); %data_modded, N_data_modded

%controllers
load("FB_controller_base.mat")
load("FB_controller_tip.mat")
load("syspp.mat")

dt = sysest.Ts;
fs =1/dt;

sysest.A(1,3) = 0;
%% Fourier Transform Computations for base
%[u_base,y1_base,ybase12,omegabase] = fourier(data_struct_base,N_data_struct_base,dt);
[u_base,y1_base,ybase12,omegabase] = fourier(data_modded,N_data_modded,dt); % usses modified data
[u_tip,y1_tip,y12_tip,omegatip]    = fourier(data_struct_tip,N_data_struct_tip,dt);
[u_tip_LO,y1_LO,y12_LO,omegaLO]    = fourier(data_struct_LO,N_data_struct_LO,dt);

%% closed loop
%PPLO conversion to summing two outputs
CL_PPLO = syspp;
CL_PPLO = ss(CL_PPLO);
CL_PPLO.C(2,1) = 1;
CL_PPLO.C(1,3) = 1;
CL_PPLO = (tf(CL_PPLO(1)));

%closed loop base
sys1 = d2c(tf(sysest));
CL_base = feedback(sys1(1)*controller_base*kd_base,1, -1);

%closed loop tip
sys1 = sysest;
sys1.C(2,1) = 1;
sys1.C(1,3) = 1;
sys1 = d2c((tf(sys1(1))));
CL_tip = feedback(sys1*controller_tip*kd_tip,1, -1);

%% Plot of Results compared with the Bode Diagram of the Model
%simulation bode
[magb,phabase] = bode(CL_base,omegabase);
[magt,phatip] = bode(CL_tip,omegatip);
[maglo,phaLO] = bode(CL_PPLO,omegaLO);

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

%plots 
figure;
semilogx(omegabase,magbase,"r",omegabase,G_1,"xk");grid;
title("Base FB controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data');

figure;
semilogx(omegatip,magtip,"r",omegatip,G_2,"xk");grid;
title("Tip FB controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data');

figure;
semilogx(omegaLO,magLO,"r",omegaLO,G_3,"xk");grid;
title("Tip PP controller Closed Loop");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data');




