% to analyse the dataset load the dataset and change the name of the vector in data
close all
vett_t = data(1,:);
Out_t1 = data(2,:);
Out_t2 = data(3,:);
Out_t3 = data(4,:);
Out_t4 = data(5,:);
Out_t5 = data(6,:);
Out_t6 = data(7,:);
dt = data(1,2) - data(1,1);



figure(1)
subplot 611;plot(vett_t,Out_t1);grid;
xlabel('Time [s]');

subplot 612;plot(vett_t,Out_t2);grid
xlabel('Time [s]');

subplot 613;plot(vett_t,Out_t3);grid
xlabel('Time [s]');

subplot 614;plot(vett_t,Out_t4);grid
xlabel('Time [s]');

subplot 615;plot(vett_t,Out_t5);grid
xlabel('Time [s]');

subplot 616;plot(vett_t,Out_t6);grid
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

