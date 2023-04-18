%% Load of Datas
close all
clear all

[data_struct, N_data_struct] = load_mat;        %loads all tests in ./Sine_tests
load('sysest09c_trick.mat')                             %loads the linear system
Ts = sysest.Ts;
fs =1/Ts;


%% Fourier Transform Computations Linear Model

for i = 1:N_data_struct
    
    data = data_struct(i).data;                 %select the time serie in the struct
    
    %Extraction of data component
    
    Numb_freq = length(data);
    time = data(1,2500:Numb_freq);              
    input = data(2,2500:Numb_freq);             
    output_base = data(3,2500:Numb_freq);       %Outputs: 3 for base, 4 for tip
    output_tip = data(4,2500:Numb_freq);        
    
    
    %FFT computation of input
    
    N = length(input);                          
    NFFT = 2^nextpow2(N);
    u_freq = fft(input,NFFT)/N;
    Sx = abs(u_freq);
    Pin = 2*Sx(1:NFFT/2);
    

    %FFT output_base
    
    N = length(output_base);                    
    NFFT = 2^nextpow2(N);
    y1_freq = fft(output_base,NFFT)/N;
    Sx = abs(y1_freq);
    Pout_1 = 2*Sx(1:NFFT/2);
    
    
    %FFT output_tip
    
    N = length(output_tip);         
    NFFT = 2^nextpow2(N);
    y2_freq = fft(output_tip,NFFT)/N;
    Sx = abs(y2_freq);
    Pout_2 = 2*Sx(1:NFFT/2);
       
    f_vect = fs/2*linspace(0,1,NFFT/2);

    %Find amplitude and index of input principal component
    
    [u_max(i), index] = max(Pin);  
    y1_max(i) = Pout_1(index);
    y2_max(i) = Pout_2(index);
    omega(i) = 2*pi*f_vect(index);
    
end


%% Parameters of the model
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
BL = 0; %invented but i am neglecting the damping in the link
Beq = 0.015;


% Supposed Value of Ks

Ks_lin = 250;


%% Matrix Extraction

A = sysest.A ;
B= sysest.B;
C = sysest.C;
D = sysest.D;
Ts = sysest.Ts;

initial = [0 0 0 0]';

% t_start = 0;
% t_end = 10;
% time = t_start:Ts:10;
% N_val = length(time);


%% Fourier Transform Computations of Non Linear Model

for i = 1:N_data_struct
        
    data = data_struct(i).data;                 %select the time serie in the struct
    
    %Extraction of input component
    
    Numb_freq = length(data);
    time = data(1,2500:Numb_freq); 
    N_val = length(time);
    input= data(2,2500:Numb_freq);
    
    % Initializatio of Simulation
    
    states_nonlinear = initial;
    
    A23 = A(2,3);
    A43 = A(4,3);
    Tmodel1 = 0;
    Tmodel2 = 0;
    
    % Simulation of Non linear behaviour
    
    for k = 1:N_val-1
        
        alfa = states_nonlinear(3,k);
        [Mx_real, Mx_lin] = springcomp_double(alfa, Ks_lin);
        Tmodel1 = (Ts/Jeq) * Mx_real;
        Tmodel2 = -Ts*((Jeq+JL)/(JL*Jeq)) * Mx_real;
        A(2,3) = 0;
        A(4,3) = 0;
        states_nonlinear(:,k+1) = A * states_nonlinear(:,k) + B*input(k) + [0 Tmodel1 0 Tmodel2 ]';
   
    end
    
    %FFT computation of input
    
    output_base = states_nonlinear(1,:);
    output_tip = states_nonlinear(3,:);


    %FFT computation of input
    
    N = length(input);                          
    NFFT = 2^nextpow2(N);
    u_freq = fft(input,NFFT)/N;
    Sx = abs(u_freq);
    Pin = 2*Sx(1:NFFT/2);
    

    %FFT output_base
    
    N = length(output_base);                    
    NFFT = 2^nextpow2(N);
    y1_freq = fft(output_base,NFFT)/N;
    Sx = abs(y1_freq);
    Pout_1 = 2*Sx(1:NFFT/2);
    
    
    %FFT output_tip
    
    N = length(output_tip);         
    NFFT = 2^nextpow2(N);
    y2_freq = fft(output_tip,NFFT)/N;
    Sx = abs(y2_freq);
    Pout_2 = 2*Sx(1:NFFT/2);
       
    f_vect = fs/2*linspace(0,1,NFFT/2);
    

    %Find amplitude and index of input principal component
    
    [u_max_nl(i), index] = max(Pin);  
    y1_max_nl(i) = Pout_1(index);
    y2_max_nl(i) = Pout_2(index);
    omega_nl(i) = 2*pi*f_vect(index);

end    

%% Plot of Results compared with the Bode Diagram of the Model

[mag,pha] = bode(sysest,omega);

%flag to get the results in logscale:   0 - linear scale
%                                       1 - log scale
logscale_flag = 0;              

if logscale_flag==0

    G_1 = (abs(y1_max ./u_max)*(2*pi/4096));
    G_1_nl = (abs(y1_max_nl ./u_max_nl));
    magbase = mag(1,:,:);           %extraction of the mag of base, first dynamic
    magbase = squeeze (magbase);

    G_2 = (abs(y2_max ./u_max)*(2*pi/4096));
    G_2_nl = (abs(y2_max_nl ./u_max_nl));
    magtip = mag(2,:,:);           %extraction of the mag of tip, second dynamic
    magtip = squeeze (magtip);
     
elseif logscale_flag==1
        
    G_1 = 20*log10(abs(y1_max ./u_max)*(2*pi/4096));
    G_1_nl = 20*log10(abs(y1_max_nl ./u_max_nl)*(2*pi/4096));
    magbase = mag(1,:,:);           %extraction of the mag of base, first dynamic
    magbase = squeeze (magbase);
    magbase = 20*log10(magbase);

    G_2 = 20*log10(abs(y2_max ./u_max)*(2*pi/4096));
    G_2_nl = 20*log10(abs(y2_max_nl ./u_max_nl)*(2*pi/4096));
    magtip = mag(2,:,:);           %extraction of the mag of tip, second dynamic
    magtip = squeeze (magtip);
    magtip = 20*log10(magtip);
        
end
        

figure;
semilogx(omega,magbase,"r",omega,G_1,"xk" ,omega_nl,G_1_nl,"*b");
title("Plot of the Base Frequency Responce (Ks = "+ Ks_lin +" N/m)");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data lin', 'Sim n-lin');

figure;
semilogx(omega,magtip,"r",omega,G_2,"xk" ,omega_nl,G_2_nl,"*b");
title("Plot of the Tip Frequency Responce (Ks = "+ Ks_lin +" N/m)");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data lin', 'Sim n-lin');




