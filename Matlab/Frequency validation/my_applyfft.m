%% Load of Datas
close all
clear all

[data_struct, N_data_struct] = load_mat;        %loads all tests in ./Sine_tests
load('systrick.mat')                             %loads the linear system
dt = sysest.Ts;
fs =1/dt;

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

%% Plot of Results compared with the Bode Diagram of the Model

[mag,pha] = bode(sysest,omega);

%flag to get the results in logscale:   0 - linear scale
%                                       1 - log scale
logscale_flag = 1;              

if logscale_flag==0

    G_1 = (abs(y1_max ./u_max)*(2*pi/4096));
    magbase = mag(1,:,:);           %extraction of the mag of base, first dynamic
    magbase = squeeze (magbase);

    G_2 = (abs(y2_max ./u_max)*(2*pi/4096));
    magtip = mag(2,:,:);           %extraction of the mag of tip, second dynamic
    magtip = squeeze (magtip);
        
elseif logscale_flag==1
        
    G_1 = 20*log10(abs(y1_max ./u_max)*(2*pi/4096));
    magbase = mag(1,:,:);           %extraction of the mag of base, first dynamic
    magbase = squeeze (magbase);
    magbase = 20*log10(magbase);

    G_2 = 20*log10(abs(y2_max ./u_max)*(2*pi/4096));
    magtip = mag(2,:,:);           %extraction of the mag of tip, second dynamic
    magtip = squeeze (magtip);
    magtip = 20*log10(magtip);
        
end
        

figure;
semilogx(omega,magbase,"r",omega,G_1,"xk");
title("Plot of the Base Frequency Responce");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data');

figure;
semilogx(omega,magtip,"r",omega,G_2,"xk");
title("Plot of the Tip Frequency Responce");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data');

figure;
bode(sysest);

