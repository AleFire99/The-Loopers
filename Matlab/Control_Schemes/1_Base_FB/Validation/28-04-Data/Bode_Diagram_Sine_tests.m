%% Load of Datas
close all
clear all

analysed_model = 'sysest09c_trick.mat';
controller_model = 'FB_controller_base.mat';


[data_struct, N_data_struct] = load_mat;            %loads all tests in ./Sine_tests

load(analysed_model)                                %loads the linear system
load(controller_model)
dt = sysest.Ts;
fs =1/dt;
time_skip = 5;                                      %second to be skipped from each sinwave

%% Fourier Transform Computations Linear Model

for i = 1:N_data_struct
    
    data = data_struct(i).data;                 %select the time serie in the struct
    
    %Extraction of data component
    
    Numb_freq = length(data);
    time = data(1,time_skip/dt:Numb_freq);              
    input = data(2,time_skip/dt:Numb_freq);             
    output_theta = data(3,time_skip/dt:Numb_freq);       %Outputs: 3 for base, 4 for tip
    output_alpha = data(4,time_skip/dt:Numb_freq);        
    
    
    %FFT computation of input
    
    N = length(input);                          
    NFFT = 2^nextpow2(N);
    u_freq = fft(input,NFFT)/N;
    Sx = abs(u_freq);
    Pin = 2*Sx(1:NFFT/2);
    

    %FFT output_base
    
    N = length(output_theta);                    
    NFFT = 2^nextpow2(N);
    y1_freq = fft(output_theta,NFFT)/N;
    Sx = abs(y1_freq);
    Pout_1 = 2*Sx(1:NFFT/2);
    
    
    %FFT output_tip
    
    N = length(output_alpha);         
    NFFT = 2^nextpow2(N);
    y2_freq = fft(output_alpha,NFFT)/N;
    Sx = abs(y2_freq);
    Pout_2 = 2*Sx(1:NFFT/2);
       
    f_vect = fs/2*linspace(0,1,NFFT/2);

    %Find amplitude and index of input principal component
    
    [u_max(i), index] = max(Pin);  
    y1_max(i) = Pout_1(index);
    y2_max(i) = Pout_2(index);
    omega(i) = 2*pi*f_vect(index);
    
end

%% Plot of Results compared with the Bode Diagram of the Model


sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

s = tf('s');

G_sysest_cont = tf(sysest_ct);
G_theta_cont_tf = G_sysest_cont(1);
controller_base_tf = tf(controller_base);
L_Controlled = controller_base_tf*G_theta_cont_tf;
CL_Controlled = L_Controlled/(1+L_Controlled);
  
[mag_sysest,pha_sysest] = bode(G_theta_cont_tf, omega);
[mag_CL,pha_CL] = bode(CL_Controlled, omega);

G_1 = 20*log10(abs(y1_max ./u_max));

mag_sysest_base = mag_sysest(1,:,:);           %extraction of the mag of base, first dynamic
mag_sysest_base = squeeze (mag_sysest_base);
mag_sysest_base = 20*log10(mag_sysest_base);

mag_CL_base = mag_CL(1,:,:);           %extraction of the mag of base, first dynamic
mag_CL_base = squeeze (mag_CL_base);
mag_CL_base = 20*log10(mag_CL_base);



figure;
semilogx(omega,mag_sysest_base,"r", omega,mag_CL_base,"g", omega,G_1,"xk");grid on;
title("Plot of the Base Frequency Responce");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model Open Loop', 'Model Controlled Closed Loop', 'Data Controlled Closed Loop');


