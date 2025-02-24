%% Load of Datas
close all
clear all

analysed_model = 'sysest09c_trick.mat';

[data_struct, N_data_struct] = load_mat;            %loads all tests in ./Sine_tests
load(analysed_model)                                %loads the linear system
dt = sysest.Ts;
fs =1/dt;
time_skip = 5;                                      %second to be skipped from each sinwave

sysest.A(1,3) = 0;

%% Fourier Transform Computations Linear Model

for i = 1:N_data_struct
    
    data = data_struct(i).data;                 %select the time serie in the struct
    
    %Extraction of data component
    
    Numb_freq = length(data);
    time = data(1,time_skip/dt:Numb_freq);              
    input = data(2,time_skip/dt:Numb_freq);             
    output_base = data(3,time_skip/dt:Numb_freq);       %Outputs: 3 for base, 4 for tip
    output_tip = data(4,time_skip/dt:Numb_freq);        
    
    
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
semilogx(omega,magbase,"r",omega,G_1,"xk");grid;
title("Plot of the Base Frequency Responce");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data');

figure;
semilogx(omega,magtip,"r",omega,G_2,"xk");grid;
title("Plot of the Tip Frequency Responce");
xlabel("Frequency [ras/s]");
ylabel("Gain");
legend('Model', 'Data');

figure;
bode(sysest);









%% Load of a second System (repeatable)

%flag to get the comparison between 2 systems:   
%                                       0 - on 
%                                       1 - off

comparison = 0;

if comparison == 1
    magbase_compared = magbase;
    magtip_compared = magtip;

    load('sysest07_matching.mat')                             %loads the linear system

%% Plot of Results compared with the Bode Diagram of the Model

    [mag,pha] = bode(sysest,omega);              

    if logscale_flag==0

        magbase = mag(1,:,:);           %extraction of the mag of base, first dynamic
        magbase = squeeze (magbase);

        magtip = mag(2,:,:);           %extraction of the mag of tip, second dynamic
        magtip = squeeze (magtip);

    elseif logscale_flag==1

        magbase = mag(1,:,:);           %extraction of the mag of base, first dynamic
        magbase = squeeze (magbase);
        magbase = 20*log10(magbase);

        magtip = mag(2,:,:);           %extraction of the mag of tip, second dynamic
        magtip = squeeze (magtip);
        magtip = 20*log10(magtip);

    end


    figure;
    semilogx(omega,magbase_compared,"g",omega,magbase,"r",omega,G_1,"xk");
    title("Plot of the Base Frequency Responce");
    xlabel("Frequency [rad/s]");
    ylabel("Gain");
    legend('Model', 'Data');

    figure;
    semilogx(omega,magtip_compared,"g",omega,magtip,"r",omega,G_2,"xk");
    title("Plot of the Tip Frequency Responce");
    xlabel("Frequency [rad/s]");
    ylabel("Gain");
    legend('Model', 'Data');

    figure;
    bode(sysest);
    
end

