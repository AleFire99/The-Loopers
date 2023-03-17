% using the data from the experiment
% apply a sine sweep signal.
%use Chirp signal block to create a sine signal that increase the frequency
%from 1 to 10 Hz
%storage the data in a variable X
%sample data:
x = y(:,4);
dt = t(2)-t(1);
%samples
N = length(x);
%Next power of 2 from length
NFFT = 2^nextpow2(N);
%FourierT
y = fft(x,NFFT);
%power spectral density (V^2)/Hz
Sx = abs(y)/N;
%Single sided power spectrum of signal x: px
Px = 2*Sx(1:NFFT/2);
%sampling frequency
fs = 1/dt;
%frequency division
f = fs/2*linspace(0,1,NFFT/2);
%plot to 10 Hz
figure
plot(f,Px)

%%  From analysis of the plot we get this peak
wn  = 2*pi*3.846; %3.846 is the frequency of the highest point
Ks = JL * wn*wn;


