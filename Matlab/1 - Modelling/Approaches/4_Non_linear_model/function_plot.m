close all
clear all
clc

Ks = 250;
max_angle = 30;
max_angle = deg2rad(max_angle);
alpha = -max_angle:0.001:max_angle;
M_real = zeros(length(alpha),1);
M_lin = zeros(length(alpha),1);


for i=1:length(alpha)
    
    [Mx_real(i), Mx_lin(i)] = springcomp_double(alpha(i),Ks);

end
%alpha = rad2deg(alpha);
figure;
plot(alpha,Mx_real,alpha,Mx_lin);
xlabel("Angle alpha [rad]");
ylabel("Momentums");
legend('Real', 'Linearized');

error = (Mx_real - Mx_lin)./Mx_real*100;
figure;
plot(alpha,error);
xlabel("Angle alpha [rad]");
ylabel("Relative Error % ");



