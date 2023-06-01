function [Px] = applyfft(input,output)


    %FFT computation of input
    
    N = length(input);                          
    NFFT = 2^nextpow2(N);
    u_freq = fft(input,NFFT)/N;
    Sx = abs(u_freq);
    Pin = 2*Sx(1:NFFT/2);
    

    %FFT output_base
    
    N = length(output);                    
    NFFT = 2^nextpow2(N);
    y_freq = fft(output,NFFT)/N;
    Sx = abs(y_freq);
    Pout = 2*Sx(1:NFFT/2);

    Px = Pout ./Pin;

end

