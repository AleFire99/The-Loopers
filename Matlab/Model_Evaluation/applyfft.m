function [f,Px] = applyfft(input,output, dt)


N = length(input);
NFFT = 2^nextpow2(N);
y = fft(input,NFFT);
Sx = abs(y)/N;
Pin = 2*Sx(1:NFFT/2);

N = length(output);
NFFT = 2^nextpow2(N);
y = fft(output,NFFT);
Sx = abs(y)/N;
Pout = 2*Sx(1:NFFT/2);

Px = Pout ./Pin;

fs =1/dt;
f = fs/2*linspace(0,1,NFFT/2);
end

