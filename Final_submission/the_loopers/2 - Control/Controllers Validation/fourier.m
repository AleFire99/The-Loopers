function [u_max,y1_max,y2_max,omega] = fourier(data_struct,N_data_struct,dt)
%Calculates fourier transform 
time_skip = 1;                                      %second to be skipped from each sinwave
fs =1/dt;

for i = 1:N_data_struct

    %data collected in several different forms 
    %this part captures related elements from data.
    try
        data = data_struct(i).data;                 %select the time serie in the struct
        index_base = 3;
        index_tip = 4;
        index_u = 2;

    catch

        data = data_struct(i).Data;                 %select the time serie in the struct
        if length(data(:,1)) == 7
            index_base = 3;
            index_tip = 4;
            index_u = 2;
        else
            index_base = 7;
            index_tip = 8;
            index_u = 2;
        end
    end
    %Extraction of data component

    Numb_freq = length(data);
    time = data(1,time_skip/dt:Numb_freq);
    input = data(index_u,time_skip/dt:Numb_freq);
    output_base = data(index_base,time_skip/dt:Numb_freq);       %Outputs: 3 for base, 4 for tip
    output_tip = data(index_tip,time_skip/dt:Numb_freq);


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
    y2_freq = fft(output_base+output_tip,NFFT)/N;
    Sx = abs(y2_freq);
    Pout_2 = 2*Sx(1:NFFT/2);

    f_vect = fs/2*linspace(0,1,NFFT/2);

    %Find amplitude and index of input principal component

    [u_max(i), index] = max(Pin);
    y1_max(i) = Pout_1(index);
    y2_max(i) = Pout_2(index);
    omega(i) = 2*pi*f_vect(index);

end
end

