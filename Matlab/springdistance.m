clc
clear all
close all

kspring = 1;
th0 = pi/2;
pin1 = [-1 1];
pin2 = [1 1];

pinrod = [0 3];
dth = pi/18;
xfree1 = norm(pinrod- pin1);
xfree2 = norm(pinrod- pin2);

pinnew = norm(pinrod).*[cos(th0 - dth), sin(th0 - dth)];
x1 = pinnew - pin1;
x2 = pinnew - pin2;

xforced1 = norm(x1);
xforced2 = norm(x2);
th1 = atan(x1(2)/x1(1));
th2 = atan(x2(2)/x2(1));

ths1 = th1 + dth;
ths2 = pi - th2 + dth;

Fs1 = 0.5*xforced1*kspring*[cos(ths1), sin(ths1)];
Fs2 =0.5*xforced2*kspring*[cos(ths2), sin(ths2)];

F = norm(Fs1)*[-cos(ths1-th1) sin(ths1-th1)];
figure
xlim([-5 5])
ylim([-5 5])
grid on
hold on
viscircles([0 0],3,'Color',"b");

plot(pin1(1),pin1(2),"ko")
plot(pin2(1),pin2(2),"ko")

plot(pinnew(1),pinnew(2),"rx")
line([0 pinnew(1)*5], [0 pinnew(2)*5])

line([pin1(1) pinnew(1)], [pin1(2) pinnew(2)])
line([pin2(1) pinnew(1)], [pin2(2) pinnew(2)])
line([pinnew(1)+F(1), pinnew(1)],[pinnew(2)+F(2), pinnew(2)])


%% non linear and linearized model
clear all 
close all
P0 = [-1 1];
PP = [0 5];
l = norm(PP);
alfa = 0:0.01:pi/6;
theta0 = atan2(PP(2)-P0(2), PP(1)-P0(1));
Pinit = [PP(2)-P0(2), PP(1)-P0(1)];
xk = norm(Pinit);
pdiff = [l*sin(alfa) - P0(1);l*cos(alfa)- P0(2)];

theta = atan2(pdiff(2,:), pdiff(1,:));
norms = pdiff.*pdiff;
norms = sqrt(norms(1,:) + norms(2,:));

Fx_real = norms.*cos(theta+alfa);
%Fx_lin = (alfa+ norm(Pinit)).*taylorapp(theta0, alfa);%cosx = cos(x0) - sin(x0)*(x);
%Fx_lin = norm(Pinit)*cos(theta0) - norm(Pinit)*sin(theta0).*alfa + alfa*cos(theta0);
Fx_lin = (xk + alfa.*(xk)).*(cos(theta0));

degree = alfa*180/pi;
plot(degree,Fx_real,"k", degree,Fx_lin, "k:")

figure
error = Fx_real-Fx_lin;
plot(degree,error, "r")

%% checking taylor approx
close all
plot(degree,cos(theta0+alfa),degree, taylorapp(theta0, alfa))
err = cos(theta0+alfa)-taylorapp(theta0, alfa);
figure
plot(abs(err),"r")








