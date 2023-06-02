%% non linear and linearized model
clear all 
close all
% Considering 2 Sprin, one per side

P0_A = [-3.2 3.5]/100;
P0_B = [+3.2 3.5]/100;

PP = [0 7.7]/100;
l = norm(PP);
alfa = -pi/6:0.01:pi/6;
Ks = 1;
%% Side A
theta0 = atan2(PP(2)-P0_A(2), PP(1)-P0_A(1));
Pinit = [PP(2)-P0_A(2), PP(1)-P0_A(1)];
xk = norm(Pinit);
pdiff = [l*sin(alfa) - P0_A(1);l*cos(alfa)- P0_A(2)];

theta = atan2(pdiff(2,:), pdiff(1,:));
norms = pdiff.*pdiff;
norms = sqrt(norms(1,:) + norms(2,:));

Fx_real_a = Ks*(norms-xk).*cos(theta+alfa);
%Fx_lin = (alfa+ norm(Pinit)).*taylorapp(theta0, alfa);%cosx = cos(x0) - sin(x0)*(x);
%Fx_lin = norm(Pinit)*cos(theta0) - norm(Pinit)*sin(theta0).*alfa + alfa*cos(theta0);
%Fx_lin_a = Ks*(norms-xk + alpha.*(norms-xk)).*(cos(theta0));
Fx_lin_a = Ks*(cos(theta0))*(norms-xk);
 
%% Side B

theta0 = atan2(PP(2)-P0_B(2), PP(1)-P0_B(1));
Pinit = [PP(2)-P0_B(2), PP(1)-P0_B(1)];
xk = norm(Pinit);
pdiff = [l*sin(alfa) - P0_B(1);l*cos(alfa)- P0_B(2)];

theta = atan2(pdiff(2,:), pdiff(1,:));
norms = pdiff.*pdiff;
norms = sqrt(norms(1,:) + norms(2,:));

Fx_real_b = Ks*(norms-xk).*cos(theta+alfa);
%Fx_lin = (alfa+ norm(Pinit)).*taylorapp(theta0, alfa);%cosx = cos(x0) - sin(x0)*(x);
%Fx_lin = norm(Pinit)*cos(theta0) - norm(Pinit)*sin(theta0).*alfa + alfa*cos(theta0);
%Fx_lin_b = Ks*(norms-xk + alpha.*(norms-xk)).*(cos(theta0));
Fx_lin_b = Ks*(cos(theta0))*(norms-xk);

Mx_real = (Fx_real_a + Fx_real_b)*l;
Mx_lin = (Fx_lin_a + Fx_lin_b)*l;



degree = alfa*180/pi;
figure(1)
plot(degree,Mx_real,"k", degree,Mx_lin, "r")
title("Linearized vs Real model of springs")
xlabel("alfa [degrees]")
ylabel("Normalized Moments")
legend(["Real", "Linearized"])
grid on
figure(2)
error = (Mx_lin-Mx_real)./Mx_real*100;
plot(degree,error, "r")
title("Error between real and linearized model")
xlabel("alfa [degrees]")
ylabel("Error [%]")
grid on
saveas(figure(1), "Linearized vs Real model of springs.png")
saveas(figure(2), "Error between real and linearized model.png")

%% checking taylor approx
% close all
% plot(degree,cos(theta0+alfa),degree, taylorapp(theta0, alfa))
% err = cos(theta0+alfa)-taylorapp(theta0, alfa);
% figure
% plot(abs(err),"r")








