load('./Sweep_Data');
x = data_03_Mar_2023_09_40_29(2,:);
dt = data_03_Mar_2023_09_40_29(1,2) - data_03_Mar_2023_09_40_29(1,1);

N = length(x);
NFFT = 2^nextpow2(N);
y = fft(x,NFFT);
Sx = abs(y)/N;
Px = 2*Sx(1:NFFT/2);
fs =1/dt;
f = fs/2*linspace(0,1,NFFT/2);
plot(f,Px);
%% 
wn  = 2*pi*3.846; %3.846 is the frequency of the highest point
Ks = JL * wn*wn;

