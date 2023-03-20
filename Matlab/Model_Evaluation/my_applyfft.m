input = data(2,:);          %extracting data
output = data(3,:);
dt = 0.002;

x_max = 5;                  %plot x axis limit

N = length(input);          %FFT input
NFFT = 2^nextpow2(N);
y = fft(input,NFFT);
Sx = abs(y)/N;
Pin = 2*Sx(1:NFFT/2);

N = length(output);         %FFT output
NFFT = 2^nextpow2(N);
y = fft(output,NFFT);
Sx = abs(y)/N;
Pout = 2*Sx(1:NFFT/2);

fs =1/dt;
f = fs/2*linspace(0,1,NFFT/2);


figure(1)                   %Plot input in time domain
plot(data(1,:),data(2,:));

figure(2)                   %Plot input in freq domain
plot(f,Pin);
xlim([0,x_max]);

figure(3)                   %Plot output in freq domain
plot(f,Pout);
xlim([0,x_max]);

G = 20*log10(abs(Pout ./Pin));

figure(4)
semilogx(f, G);
xlim([0,x_max]);

[u_max, index] = max(Pin)  %Find amplitude and index of input principal component
y_max = Pout(index)



%clear all