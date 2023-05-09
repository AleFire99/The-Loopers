% to analyse the dataset load the dataset and change the name of the vector in data
close all
clc

vett_t = data(1,:);
ref = data(2,:);
theta = data(3,:);
alpha = data(4,:);
dt = data(1,2) - data(1,1);



figure(1)
subplot 411;plot(vett_t,ref);grid;
xlabel('Time [s]');
legend('reference');

subplot 412;plot(vett_t,theta);grid
xlabel('Time [s]')
legend('theta');

subplot 413;plot(vett_t,alpha);grid
xlabel('Time [s]');
legend('alpha')

theta_norm = theta/ max(abs(theta));
alpha_norm = alpha/ max(abs(alpha));

subplot 414;plot(vett_t,theta_norm,"r",vett_t,alpha_norm,"g");grid
xlabel('Time [s]');
legend('theta norm','alpha norm');


%clear all