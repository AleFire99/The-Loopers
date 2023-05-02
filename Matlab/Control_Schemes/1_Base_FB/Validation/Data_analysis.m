% to analyse the dataset load the dataset and change the name of the vector in data
close all
vett_t = data(1,:);
Out_t1 = data(2,:);
Out_t2 = data(3,:);
Out_t3 = data(4,:);
dt = data(1,2) - data(1,1);



figure(1)
subplot 411;plot(vett_t,Out_t1,vett_t,Out_t2);grid;
xlabel('Time [s]');
legend('reference','theta');

subplot 412;plot(vett_t,Out_t2);grid
xlabel('Time [s]');

subplot 413;plot(vett_t,Out_t3);grid
xlabel('Time [s]');

Out_t2_norm = Out_t2/ max(abs(Out_t2));
Out_t3_norm = Out_t3/ max(abs(Out_t3));

subplot 414;plot(vett_t,Out_t2_norm,"r",vett_t,Out_t3_norm,"g");grid
xlabel('Time [s]');
legend('theta','alpha');

 
% N = length(Out_t);
% NFFT = 2^nextpow2(N);
% y = fft(Out_t,NFFT);
% Sx = abs(y)/N;
% Px = 2*Sx(1:NFFT/2);
% fs =1/dt;
% f = fs/2*linspace(0,1,NFFT/2);
% %plot(f,Px);


%clear all