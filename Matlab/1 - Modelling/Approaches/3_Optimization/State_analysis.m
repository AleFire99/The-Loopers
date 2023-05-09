% to analyse the dataset load the dataset and change the name of the vector in data
close all

Out_t0 = data(1,:)*(360/(2*pi));
Out_t1 = data(2,:)*(360/(2*pi));
Out_t2 = data(3,:)*(360/(2*pi));
Out_t3 = data(4,:)*(360/(2*pi));
dt = 0.02;
Dt = dt*(length(Out_t1)-1);
vett_t = 0:dt:Dt;



figure(1)
subplot 411;plot(vett_t,Out_t0);grid;
xlabel('Time [s]');

subplot 412;plot(vett_t,Out_t1);grid
xlabel('Time [s]');

subplot 413;plot(vett_t,Out_t2);grid
xlabel('Time [s]');

subplot 414;plot(vett_t,Out_t3);grid
xlabel('Time [s]');


% 
% N = length(Out_t);
% NFFT = 2^nextpow2(N);
% y = fft(Out_t,NFFT);
% Sx = abs(y)/N;
% Px = 2*Sx(1:NFFT/2);
% fs =1/dt;
% f = fs/2*linspace(0,1,NFFT/2);
% %plot(f,Px);


%clear all

